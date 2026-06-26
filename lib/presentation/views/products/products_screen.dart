import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/product_provider.dart';
import 'package:unifytechxenoswebowner/core/utils/debouncer.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/confirmation_dialog.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';
import 'package:unifytechxenoswebowner/presentation/providers/category_provider.dart';
import 'package:unifytechxenoswebowner/presentation/views/products/widgets/product_form_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared/lotes_produto_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/products/widgets/print_labels_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/products/widgets/bulk_print_labels_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/products/widgets/product_bulk_actions_bar.dart';
import 'package:unifytechxenoswebowner/presentation/views/products/widgets/batch_price_edit_dialog.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:unifytechxenoswebowner/data/repositories/report_repository.dart';
import 'package:unifytechxenoswebowner/presentation/views/products/widgets/products_help_dialog.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});
  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchController = TextEditingController();
  final _horizontalController = ScrollController();
  final _verticalController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 500);
  final _searchFocus = FocusNode();
  final Set<int> _selectedIds = {};
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleKeyPress);
  }

  bool _handleKeyPress(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final isControl = HardwareKeyboard.instance.isControlPressed;
    final isAlt = HardwareKeyboard.instance.isAltPressed;

    if (isControl && event.logicalKey == LogicalKeyboardKey.keyF) {
      _searchFocus.requestFocus();
      return true;
    }
    if (isAlt && event.logicalKey == LogicalKeyboardKey.keyN) {
      _showProductForm(context);
      return true;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_searchFocus.hasFocus) {
        _searchController.clear();
        ref.read(productsProvider.notifier).setSearch('');
        _searchFocus.unfocus();
        return true;
      }
    }

    return false;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyPress);
    _searchController.dispose();
    _horizontalController.dispose();
    _verticalController.dispose();
    _debouncer.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _showFeedback(String message, bool isSuccess) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isSuccess ? AppTheme.accentGreen : AppTheme.accentRed,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: isSuccess ? 3 : 5),
      ),
    );
  }

  Widget _buildVencimentoCell(DateTime? data) {
    if (data == null) return const Text('-', style: TextStyle(color: Colors.white38));
    final now = DateTime.now();
    final diff = data.difference(now).inDays;
    
    Color? color;
    if (data.isBefore(now)) {
      color = AppTheme.accentRed;
    } else if (diff <= 15) {
      color = AppTheme.accentOrange;
    } else if (diff <= 30) {
      color = Colors.yellow;
    }
    
    return Text(
      Formatters.date(data),
      style: TextStyle(
        color: color,
        fontWeight: color != null ? FontWeight.bold : null,
      ),
    );
  }

  Future<void> _exportar(String formato) async {
    setState(() => _isExporting = true);
    final productsState = ref.read(productsProvider);
    
    try {
      String fileName = 'produtos_${DateTime.now().millisecondsSinceEpoch}.$formato';
      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Exportar Produtos',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: [formato],
      );

      if (outputFile != null) {
        if (!outputFile.endsWith('.$formato')) outputFile += '.$formato';
        
        final params = {
          'search': productsState.search,
          'categoria_id': productsState.categoriaId,
          'baixo_estoque': productsState.onlyLowStock,
        };

        await ref.read(reportRepositoryProvider).exportarRelatorio(
          formato, 
          outputFile, 
          'estoque_lista',
          params: params,
        );

        _showFeedback('Catálogo exportado: $outputFile', true);
      }
    } catch (e) {
      _showFeedback('Erro ao exportar: $e', false);
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _importarPlanilha() async {
    setState(() => _isExporting = true);
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final bytes = result.files.first.bytes;
        final name = result.files.first.name;
        if (bytes != null) {
          final (success, msg, data) = await ref.read(productsProvider.notifier).importarPlanilha(bytes, name);
          if (success && data != null) {
            final erros = List<String>.from(data['erros'] ?? []);
            if (erros.isNotEmpty) {
              _showFeedback('$msg\nExistem ${erros.length} erros. O log foi salvo no terminal.', false);
              // Para evitar estourar o snackbar com muitos erros, a gente mostra só a quantidade e um log
              for (var err in erros) {
                 debugPrint('Erro Importação: $err');
              }
            } else {
              _showFeedback(msg, true);
            }
          } else {
            _showFeedback(msg, false);
          }
        }
      }
    } catch (e) {
      _showFeedback('Erro ao importar: $e', false);
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Produtos', style: theme.textTheme.headlineLarge),
                      const SizedBox(height: 4),
                      Text('Gerencie o catálogo de produtos',
                          style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (_isExporting)
                      const Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                    IconButton(
                      tooltip: 'Exportar PDF',
                      icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
                      onPressed: _isExporting ? null : () => _exportar('pdf'),
                    ),
                    IconButton(
                      tooltip: 'Exportar Excel',
                      icon: const Icon(Icons.table_chart_rounded, color: Colors.green),
                      onPressed: _isExporting ? null : () => _exportar('xlsx'),
                    ),
                    IconButton(
                      tooltip: 'Exportar para Balança',
                      icon: const Icon(Icons.scale_rounded, color: Colors.orange),
                      onPressed: _isExporting ? null : () => _exportar('txt'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Search & Filters
            Container(
              decoration: AppTheme.glassCard(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          onChanged: (v) {
                            _debouncer.run(() => ref.read(productsProvider.notifier).setSearch(v));
                          },
                          decoration: InputDecoration(
                            hintText:
                                'Buscar por nome, código de barras ou categoria (Ctrl+F)...',
                            prefixIcon:
                                const Icon(Icons.search_rounded, size: 20),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      ref.read(productsProvider.notifier).setSearch('');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () =>
                            ref.read(productsProvider.notifier).refresh(),
                        icon: const Icon(Icons.refresh_rounded),
                        tooltip: 'Atualizar',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Filtro de Categoria
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                        ),
                        child: ref.watch(categoriesProvider).response.when(
                          data: (paginated) {
                            final productsState = ref.watch(productsProvider);
                            return DropdownButtonHideUnderline(
                              child: DropdownButton<int?>(
                                value: productsState.categoriaId,
                                hint: const Text('Categoria', style: TextStyle(fontSize: 13, color: Colors.white70)),
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.primaryColor),
                                dropdownColor: const Color(0xFF1C2039),
                                style: const TextStyle(fontSize: 13, color: Colors.white),
                                onChanged: (id) => ref.read(productsProvider.notifier).setCategoria(id),
                                items: [
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('Todas Categorias'),
                                  ),
                                  ...paginated.data.map((cat) => DropdownMenuItem(
                                    value: cat.idCategoria,
                                    child: Text(cat.nome),
                                  )),
                                ],
                              ),
                            );
                          },
                          loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                          error: (_, __) => const Icon(Icons.error_outline, size: 18, color: Colors.red),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilterChip(
                        label: const Text('Estoque Baixo'),
                        selected: ref.watch(productsProvider).onlyLowStock,
                        onSelected: (v) => ref.read(productsProvider.notifier).setFilterLowStock(v),
                        selectedColor: AppTheme.accentOrange.withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.accentOrange,
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Products table
            Expanded(
              child: Container(
                decoration: AppTheme.glassCard(),
                clipBehavior: Clip.antiAlias,
                child: productsAsync.response.when(
                  loading: () => const LoadingOverlay(
                      message: 'Carregando produtos...'),
                  error: (e, _) => EmptyState(
                    icon: Icons.error_outline,
                    title: 'Erro ao carregar',
                    subtitle: e.toString(),
                    action: ElevatedButton(
                      onPressed: () =>
                          ref.read(productsProvider.notifier).refresh(),
                      child: const Text('Tentar novamente'),
                    ),
                  ),
                  data: (paginated) {
                    final products = paginated.data;
                    if (products.isEmpty) {
                      return const EmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: 'Nenhum produto encontrado',
                        subtitle:
                            'Cadastre produtos ou ajuste o filtro de busca',
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            controller: _verticalController,
                            child: SingleChildScrollView(
                              controller: _verticalController,
                              scrollDirection: Axis.vertical,
                              child: Scrollbar(
                                controller: _horizontalController,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: _horizontalController,
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('CÓDIGO')),
                                      DataColumn(label: Text('NOME')),
                                      DataColumn(label: Text('CATEGORIA')),
                                      DataColumn(label: Text('UNIDADE')),
                                      DataColumn(label: Text('ESTOQUE'), numeric: true),
                                      DataColumn(label: Text('PREÇO CUSTO'), numeric: true),
                                      DataColumn(label: Text('PREÇO VENDA'), numeric: true),
                                      DataColumn(label: Text('LOCAL')),
                                      DataColumn(label: Text('VALIDADE')),
                                      DataColumn(label: Text('STATUS')),
                                      DataColumn(label: Text('AÇÕES')),
                                    ],
                                    rows: products
                                        .map((p) => _buildProductRow(p, theme))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total: ${paginated.total} produtos',
                                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Página ${paginated.page} de ${(paginated.total / paginated.limit).ceil() == 0 ? 1 : (paginated.total / paginated.limit).ceil()}',
                                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: paginated.hasPreviousPage
                                        ? () => ref.read(productsProvider.notifier).setPage(paginated.page - 1)
                                        : null,
                                    icon: const Icon(Icons.chevron_left, size: 20),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    onPressed: paginated.hasNextPage
                                        ? () => ref.read(productsProvider.notifier).setPage(paginated.page + 1)
                                        : null,
                                    icon: const Icon(Icons.chevron_right, size: 20),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            if (_selectedIds.isNotEmpty)
              productsAsync.response.when(
                data: (paginated) {
                  final selectedProducts = paginated.data
                      .where((p) => _selectedIds.contains(p.idProduto))
                      .toList();
                  return ProductBulkActionsBar(
                    selectedCount: _selectedIds.length,
                    onClearSelection: () => setState(() => _selectedIds.clear()),
                    onPrintLabels: () =>
                        _showBulkPrintLabels(context, selectedProducts),
                    onEditPrices: () =>
                        _showBatchPriceEdit(context, selectedProducts),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
          ],
        ),
      ),
    );
  }

  DataRow _buildProductRow(Produto p, ThemeData theme) {
    return DataRow(
      cells: [
        DataCell(Text(
          p.codigoBarras ?? p.codigoInterno ?? '#${p.idProduto}',
          style: theme.textTheme.bodySmall,
        )),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 32,
                  height: 32,
                  color: Colors.white.withValues(alpha: 0.05),
                  child: p.fotoPrincipalUrl != null
                      ? Image.network(
                          '${ref.read(apiServiceProvider).baseUrl}${p.fotoPrincipalUrl}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 16, color: Colors.white24),
                        )
                      : const Icon(Icons.image_outlined, size: 16, color: Colors.white24),
                ),
              ),
              const SizedBox(width: 10),
              if (p.estoqueBaixo)
                const Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(Icons.warning_amber,
                      size: 14, color: AppTheme.accentOrange),
                ),
              Flexible(
                  child: Text(p.nome, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
        DataCell(Text(p.categoriaNome ?? 'Sem categoria')),
        DataCell(Text(p.unidadeVenda)),
        DataCell(
          Text(
            Formatters.quantity(p.estoqueAtual),
            style: TextStyle(
              color: p.estoqueBaixo ? AppTheme.accentRed : null,
              fontWeight: p.estoqueBaixo ? FontWeight.w600 : null,
            ),
          ),
        ),
        DataCell(Text(Formatters.currency(p.precoCusto))),
        DataCell(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Formatters.currency(p.precoVenda),
                  style: theme.textTheme.bodyLarge),
              if (p.emPromocao)
                Text(
                  Formatters.currency(p.precoPromocional!),
                  style: const TextStyle(
                    color: AppTheme.accentGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        DataCell(Text(p.localizacao ?? '-')),
        DataCell(_buildVencimentoCell(p.dataVencimento)),
        DataCell(StatusChip.fromStatus(p.ativo ? 'ativo' : 'inativo')),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.layers_outlined, size: 18, color: Colors.blueAccent),
                onPressed: () => _showLotes(p),
                tooltip: 'Ver Lotes',
              ),
              IconButton(
                icon: const Icon(Icons.print_outlined, size: 18, color: Colors.white70),
                onPressed: () => _showPrintLabels(context, p),
                tooltip: 'Imprimir Etiqueta',
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.amber),
                onPressed: () => _duplicateProduct(p),
                tooltip: 'Duplicar Produto',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPrintLabels(BuildContext context, Produto product) {
    showDialog(
      context: context,
      builder: (context) => PrintLabelsDialog(product: product),
    );
  }

  void _showBulkPrintLabels(BuildContext context, List<Produto> products) {
    showDialog(
      context: context,
      builder: (context) => BulkPrintLabelsDialog(products: products),
    );
  }

  void _showBatchPriceEdit(BuildContext context, List<Produto> products) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BatchPriceEditDialog(products: products),
    );
  }

  void _showProductForm(BuildContext context, {Produto? produto}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ProductFormDialog(
        produto: produto,
        onResult: (success, message) {
          _showFeedback(message, success);
        },
      ),
    );
  }

  void _showLotes(Produto product) {
    showDialog(
      context: context,
      builder: (context) => LotesProdutoDialog(product: product),
    );
  }

  void _duplicateProduct(Produto p) {
    // Abrir formulário mas sem ID, códigos exclusivos e com nome alterado
    final duplicated = Produto(
      idProduto: 0, // Reset ID
      empresaId: p.empresaId,
      nome: '${p.nome} (Cópia)',
      categoriaId: p.categoriaId,
      categoriaNome: p.categoriaNome,
      unidadeVenda: p.unidadeVenda,
      precoCusto: p.precoCusto,
      precoVenda: p.precoVenda,
      precoPromocional: p.precoPromocional,
      dataInicioPromocao: p.dataInicioPromocao,
      dataFimPromocao: p.dataFimPromocao,
      margemLucro: p.margemLucro,
      estoqueMinimo: p.estoqueMinimo,
      controlarEstoque: p.controlarEstoque,
      marca: p.marca,
      localizacao: p.localizacao,
      descricao: p.descricao,
      fotoPrincipalUrl: p.fotoPrincipalUrl,
      dataCadastro: DateTime.now(),
      ativo: true,
    );

    _showProductForm(context, produto: duplicated);
  }
}
