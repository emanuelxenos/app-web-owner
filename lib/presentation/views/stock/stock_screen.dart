import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:unifytechxenoswebowner/services/file_export_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/stock_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/product_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/domain/models/stock_movement.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';
import 'package:unifytechxenoswebowner/presentation/providers/report_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/category_provider.dart';
import 'package:unifytechxenoswebowner/core/utils/debouncer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:unifytechxenoswebowner/data/repositories/report_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:unifytechxenoswebowner/data/repositories/stock_repository.dart';
import 'package:unifytechxenoswebowner/presentation/views/stock/widgets/stock_kpi_card.dart';
import 'package:unifytechxenoswebowner/presentation/views/stock/widgets/stock_bulk_actions_bar.dart';
import 'package:unifytechxenoswebowner/presentation/views/stock/widgets/ajuste_estoque_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared/lotes_produto_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/stock/widgets/novo_inventario_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/stock/widgets/performance_produto_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/stock/widgets/sugestao_compra_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/stock/widgets/stock_help_dialog.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

class StockScreen extends ConsumerStatefulWidget {
  const StockScreen({super.key});
  @override
  ConsumerState<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends ConsumerState<StockScreen> {
  final _searchController = TextEditingController();
  final _horizontalController = ScrollController();
  final _verticalController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 500);
  bool _showStats = true; // Toggle for KPI cards
  bool _isExporting = false;
  final _searchFocus = FocusNode();
  final Set<int> _selectedIds = {};
  
  // Filtros de Inventário
  DateTime? _invInicio;
  DateTime? _invFim;
  bool _filterToday = false;

  // Filtros de Histórico
  DateTime? _histInicio;
  DateTime? _histFim;
  bool _filterHistToday = false;
  String? _histTipo;

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
    if (isAlt && event.logicalKey == LogicalKeyboardKey.keyS) {
      _showSugestaoCompra();
      return true;
    }
    if (isAlt && event.logicalKey == LogicalKeyboardKey.keyP) {
      _imprimirEtiquetasLote();
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
    _debouncer.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _exportar(String formato) async {
    setState(() => _isExporting = true);
    final productsState = ref.read(productsProvider);
    
    try {
      final params = {
        'search': productsState.search,
        'categoria_id': productsState.categoriaId,
        'baixo_estoque': productsState.onlyLowStock,
        'vencendo': productsState.onlyExpiring,
      };

      final bytes = await ref.read(reportRepositoryProvider).exportarRelatorioBytes(
        formato, 
        'estoque_lista',
        params: params,
      );

      String fileName = 'estoque_${DateTime.now().millisecondsSinceEpoch}.$formato';
      String? outputFile = await FileExportService.exportAndSave(
        bytes: bytes,
        dialogTitle: 'Exportar Estoque',
        fileName: fileName,
        extension: formato,
      );

      if (outputFile != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Estoque exportado: $outputFile'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao exportar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _imprimirEtiqueta(int produtoId) async {
    try {
      final bytes = await ref.read(reportRepositoryProvider).imprimirEtiquetaBytes(produtoId);
      
      String? outputFile = await FileExportService.exportAndSave(
        bytes: bytes,
        dialogTitle: 'Salvar Etiqueta',
        fileName: 'etiqueta_$produtoId.pdf',
        extension: 'pdf',
      );

      if (outputFile != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Etiqueta gerada com sucesso!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao imprimir etiqueta: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showSugestaoCompra() {
    showDialog(
      context: context,
      builder: (context) => const SugestaoCompraDialog(),
    );
  }

  Future<void> _imprimirEtiquetasLote() async {
    if (_selectedIds.isEmpty) return;
    
    try {
      String fileName = 'etiquetas_lote_${DateTime.now().millisecondsSinceEpoch}.pdf';
      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Salvar Etiquetas em Lote',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (outputFile != null) {
        if (!outputFile.endsWith('.pdf')) outputFile += '.pdf';
        await ref.read(reportRepositoryProvider).imprimirEtiquetasLote(_selectedIds.toList(), outputFile);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lote de etiquetas gerado com sucesso!'), backgroundColor: Colors.green),
          );
          setState(() => _selectedIds.clear());
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao imprimir lote: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showProductPerformanceDialog(Produto product) async {
    showDialog(
      context: context,
      builder: (context) => PerformanceProdutoDialog(product: product),
    );
  }

  void _showAjuste([Produto? product]) {
    showDialog(
      context: context,
      builder: (context) => AjusteEstoqueDialog(initialProduct: product),
    );
  }

  void _showLotes(Produto product) {
    showDialog(
      context: context,
      builder: (context) => LotesProdutoDialog(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 if (_selectedIds.isNotEmpty) StockBulkActionsBar(
                   selectedCount: _selectedIds.length,
                   onPrintLabels: _imprimirEtiquetasLote,
                   onCancel: () => setState(() => _selectedIds.clear()),
                 ),
                _buildHeader(theme),
              const SizedBox(height: 20),
              _buildTabBar(),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPosicaoTab(theme),
                    _buildHistoricoTab(theme),
                    _buildInventariosTab(theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Estoque', style: theme.textTheme.headlineLarge),
              const SizedBox(height: 4),
              Text('Controle de estoque e inventário', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => context.push('/estoque/perda'),
          icon: const Icon(Icons.warning_amber_rounded, size: 18),
          label: const Text('Registrar Perda'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.orangeAccent,
            side: const BorderSide(color: Colors.orangeAccent),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(width: 16),
        if (_isExporting)

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
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
          tooltip: 'Sugestão de Compra (Alt+S)',
          icon: const Icon(Icons.shopping_cart_checkout_rounded, color: Colors.blueAccent),
          onPressed: _showSugestaoCompra,
        ),
        IconButton(
          tooltip: 'Ajuda e Tutorial da Tela',
          icon: const Icon(Icons.help_outline_rounded, color: Colors.amber),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const StockHelpDialog(),
            );
          },
        ),
        Tooltip(
          message: 'Atalhos do Teclado:\n• Ctrl + F: Buscar Produto\n• Alt + S: Sugestão de Compra\n• Alt + P: Imprimir Etiquetas (Lote)\n• Esc: Limpar busca/filtros',
          child: IconButton(
            icon: const Icon(Icons.keyboard_command_key_rounded, color: Colors.white70),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: AppTheme.primaryColor,
      unselectedLabelColor: Colors.white70,
      indicatorColor: AppTheme.primaryColor,
      tabs: const [
        Tab(text: 'POSIÇÃO ATUAL'),
        Tab(text: 'HISTÓRICO'),
        Tab(text: 'INVENTÁRIOS'),
      ],
    );
  }


  Widget _buildVencimentoCell(DateTime? data) {
    if (data == null) return const Text('N/A', style: TextStyle(color: Colors.white54));
    
    final now = DateTime.now();
    final difference = data.difference(now).inDays;
    
    Color color = Colors.white;
    if (data.isBefore(now)) {
      color = AppTheme.accentRed;
    } else if (difference <= 15) {
      color = AppTheme.accentOrange;
    } else if (difference <= 30) {
      color = Colors.yellow;
    }

    return Text(
      Formatters.date(data),
      style: TextStyle(color: color, fontWeight: color != Colors.white ? FontWeight.bold : null),
    );
  }

  Widget _buildPosicaoTab(ThemeData theme) {
    final productsState = ref.watch(productsProvider);
    final reportAsync = ref.watch(stockReportProvider);
    final productsNotifier = ref.read(productsProvider.notifier);

    return Column(
      children: [
        // KPI Cards
        // KPI Cards with Animation
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: (!_showStats || productsState.onlyLowStock || productsState.onlyExpiring || productsState.onlyReposition)
              ? const SizedBox.shrink() // Hide stats manually or when filtering
              : reportAsync.when(
                  data: (data) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                StockKpiCard(
                  title: 'Total de Itens',
                  value: data.totalProdutos.toString(),
                  icon: Icons.inventory_2_outlined,
                  color: Colors.blue,
                ),
                StockKpiCard(
                  title: 'Estoque Baixo',
                  value: data.produtosBaixos.toString(),
                  icon: Icons.warning_amber_rounded,
                  color: AppTheme.accentOrange,
                ),
                StockKpiCard(
                  title: 'Valor (Custo)',
                  value: Formatters.currency(data.valorTotalCusto),
                  icon: Icons.attach_money_rounded,
                  color: AppTheme.accentGreen,
                ),
                StockKpiCard(
                  title: 'Reposição Necessária',
                  value: Formatters.currency(data.sugestaoCompraTotal),
                  icon: Icons.shopping_cart_checkout_rounded,
                  color: Colors.purple,
                ),
                StockKpiCard(
                  title: 'Vencendo (15 dias)',
                  value: data.produtosVencendo.toString(),
                  icon: Icons.event_busy_rounded,
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
                  loading: () => const SizedBox(height: 100, child: LoadingOverlay()),
                  error: (_, __) => const SizedBox.shrink(),
                ),
        ),

        // Search & Filters
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: AppTheme.glassCard(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      onChanged: (v) {
                        _debouncer.run(() => productsNotifier.setSearch(v));
                      },
                      decoration: const InputDecoration(
                        hintText: 'Buscar produto...',
                        prefixIcon: Icon(Icons.search_rounded),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: _showStats ? 'Esconder Estatísticas' : 'Mostrar Estatísticas',
                  icon: Icon(
                    _showStats ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.primaryColor,
                  ),
                  onPressed: () => setState(() => _showStats = !_showStats),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
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
                    data: (paginated) => DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: productsState.categoriaId,
                        hint: const Text('Categoria', style: TextStyle(fontSize: 13, color: Colors.white70)),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.primaryColor),
                        dropdownColor: const Color(0xFF1C2039),
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                        onChanged: (id) => productsNotifier.setCategoria(id),
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
                    ),
                    loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    error: (_, __) => const Icon(Icons.error_outline, size: 18, color: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Estoque Baixo'),
                  selected: productsState.onlyLowStock,
                  onSelected: (v) => productsNotifier.setFilterLowStock(v),
                  selectedColor: AppTheme.accentOrange.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.accentOrange,
                ),
                FilterChip(
                  label: const Text('Vencendo (15d)'),
                  selected: productsState.onlyExpiring,
                  onSelected: (v) => productsNotifier.setFilterExpiring(v),
                  selectedColor: AppTheme.accentRed.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.accentRed,
                ),
                FilterChip(
                  label: const Text('Reposição'),
                  selected: productsState.onlyReposition,
                  onSelected: (v) => productsNotifier.setFilterReposition(v),
                  selectedColor: Colors.purple.withValues(alpha: 0.2),
                  checkmarkColor: Colors.purple,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Table
        // Table with Pagination
        Expanded(
          child: Container(
            decoration: AppTheme.glassCard(),
            clipBehavior: Clip.antiAlias,
            child: productsState.response.when(
              loading: () => const LoadingOverlay(message: 'Carregando estoque...'),
              error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
              data: (paginated) {
                final products = paginated.data;

                if (products.isEmpty) {
                  return const EmptyState(
                    icon: Icons.warehouse_outlined,
                    title: 'Nenhum item encontrado',
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _verticalController,
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          controller: _horizontalController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                                columns: [
                                  const DataColumn(label: Text('PRODUTO')),
                                  const DataColumn(label: Text('UNIDADE')),
                                  const DataColumn(label: Text('ESTOQUE ATUAL'), numeric: true),
                                  const DataColumn(label: Text('ESTOQUE MÍN'), numeric: true),
                                  const DataColumn(label: Text('LOCALIZAÇÃO')),
                                  const DataColumn(label: Text('VENCIMENTO')),
                                  const DataColumn(label: Text('STATUS')),
                                ],
                                rows: products.map((p) {
                                  final baixo = p.estoqueBaixo;
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        InkWell(
                                          onTap: () => _showProductPerformanceDialog(p),
                                          borderRadius: BorderRadius.circular(4),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                            child: Row(
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
                                                Flexible(
                                                  child: Text(
                                                    p.nome,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: AppTheme.primaryColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    DataCell(Text(p.unidadeVenda)),
                                    DataCell(Text(
                                      Formatters.quantity(p.estoqueAtual),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: baixo ? AppTheme.accentRed : null,
                                      ),
                                    )),
                                    DataCell(Text(Formatters.quantity(p.estoqueMinimo))),
                                    DataCell(Text(p.localizacao ?? 'Não Informada')),
                                    DataCell(_buildVencimentoCell(p.dataVencimento)),
                                    DataCell(StatusChip.fromStatus(baixo ? 'pendente' : 'ativo')),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                    ),
                    const Divider(height: 1, color: Colors.white10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: ${paginated.total} produtos',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          Row(
                            children: [
                              Text(
                                'Página ${paginated.page} de ${(paginated.total / paginated.limit).ceil() == 0 ? 1 : (paginated.total / paginated.limit).ceil()}',
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                onPressed: paginated.hasPreviousPage
                                    ? () => productsNotifier.setPage(paginated.page - 1)
                                    : null,
                                icon: const Icon(Icons.chevron_left),
                                color: Colors.white,
                              ),
                              IconButton(
                                onPressed: paginated.hasNextPage
                                    ? () => productsNotifier.setPage(paginated.page + 1)
                                    : null,
                                icon: const Icon(Icons.chevron_right),
                                color: Colors.white,
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
      ],
    );
  }

  Widget _buildHistoricoTab(ThemeData theme) {
    // Normalizar data para evitar loops
    final today = DateUtils.dateOnly(DateTime.now());
    
    final movementsAsync = ref.watch(stockMovementsProvider(
      produtoId: null, 
      inicio: _filterHistToday ? today : _histInicio, 
      fim: _histFim,
      tipo: _histTipo,
    ));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Hoje'),
                selected: _filterHistToday,
                onSelected: (val) {
                  setState(() {
                    _filterHistToday = val;
                    if (val) {
                      _histInicio = null;
                      _histFim = null;
                    }
                  });
                },
              ),
              const SizedBox(width: 8),
              // Filtro de Tipo de Movimentação
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _histTipo,
                    hint: const Text('Tipo', style: TextStyle(fontSize: 13, color: Colors.white70)),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.primaryColor),
                    dropdownColor: const Color(0xFF1C2039),
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                    onChanged: (val) => setState(() => _histTipo = val),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Todos Tipos')),
                      DropdownMenuItem(value: 'entrada', child: Text('Entradas')),
                      DropdownMenuItem(value: 'saida', child: Text('Saídas')),
                      DropdownMenuItem(value: 'ajuste', child: Text('Ajustes')),
                      DropdownMenuItem(value: 'inventario', child: Text('Inventário')),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: _selectHistDateRange,
                icon: const Icon(Icons.date_range_rounded, size: 18),
                label: Text(_histInicio != null ? 'Período Selecionado' : 'Selecionar Período'),
              ),
              const SizedBox(width: 8),
              if (_histInicio != null || _histFim != null || _filterHistToday)
                IconButton(
                  tooltip: 'Limpar Filtros',
                  onPressed: () {
                    setState(() {
                      _histInicio = null;
                      _histFim = null;
                      _filterHistToday = false;
                    });
                  },
                  icon: const Icon(Icons.close_rounded, color: Colors.grey),
                ),
            ],
          ),
        ),
        if (_histInicio != null && _histFim != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text(
                  'Período: ${Formatters.date(_histInicio!)} até ${Formatters.date(_histFim!)}',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.primary),
                ),
              ],
            ),
          ),
        Expanded(
          child: Container(
            decoration: AppTheme.glassCard(),
            clipBehavior: Clip.antiAlias,
            child: movementsAsync.when(
              loading: () => const LoadingOverlay(message: 'Carregando histórico...'),
              error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
              data: (movs) {
                if (movs.isEmpty) {
                  return EmptyState(
                    icon: Icons.history_rounded,
                    title: _filterHistToday || _histInicio != null 
                        ? 'Nenhuma movimentação no período' 
                        : 'Nenhuma movimentação registrada',
                  );
                }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: movs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final m = movs[i];
              final isPositive = m.tipoMovimentacao == 'entrada' || 
                                 m.tipoMovimentacao == 'compra' || 
                                 ((m.tipoMovimentacao == 'ajuste' || m.tipoMovimentacao == 'inventario') && m.quantidade > 0);
              
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppTheme.accentGreen : AppTheme.accentRed).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive ? AppTheme.accentGreen : AppTheme.accentRed,
                    size: 20,
                  ),
                ),
                title: Text(m.produtoNome ?? 'Produto [${m.produtoId}]', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${m.tipoMovimentacao.toUpperCase()} - ${m.observacao ?? 'Sem observação'}'),
                    if (m.loteFabricante != null && m.loteFabricante!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.qr_code_scanner_rounded, size: 12, color: AppTheme.primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                'LOTE: ${m.loteFabricante}',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isPositive ? '+' : ''}${Formatters.quantity(m.quantidade)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isPositive ? AppTheme.accentGreen : AppTheme.accentRed,
                      ),
                    ),
                    Text(Formatters.dateTime(m.dataMovimentacao), style: const TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
          );
        },
      ),
    ),
  ),
],
    );
  }

  Widget _buildInventariosTab(ThemeData theme) {
    // Normalizar data para evitar loops (key estável para o provider)
    final today = DateUtils.dateOnly(DateTime.now());
    
    final inventoriesAsync = ref.watch(inventoriesProvider(
      inicio: _filterToday ? today : _invInicio,
      fim: _invFim,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FilterChip(
              label: const Text('Hoje'),
              selected: _filterToday,
              onSelected: (val) {
                setState(() {
                  _filterToday = val;
                  if (val) {
                    _invInicio = null;
                    _invFim = null;
                  }
                });
              },
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: _selectInvDateRange,
              icon: const Icon(Icons.date_range_rounded, size: 18),
              label: Text(_invInicio != null ? 'Período Selecionado' : 'Selecionar Período'),
            ),
            const SizedBox(width: 8),
            if (_invInicio != null || _invFim != null || _filterToday)
              IconButton(
                tooltip: 'Limpar Filtros',
                onPressed: () {
                  setState(() {
                    _invInicio = null;
                    _invFim = null;
                    _filterToday = false;
                  });
                },
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
              ),
          ],
        ),
        if (_invInicio != null && _invFim != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Período: ${Formatters.date(_invInicio!)} até ${Formatters.date(_invFim!)}',
              style: TextStyle(fontSize: 12, color: theme.colorScheme.primary),
            ),
          ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: AppTheme.glassCard(),
            clipBehavior: Clip.antiAlias,
            child: inventoriesAsync.when(
              loading: () => const LoadingOverlay(message: 'Carregando inventários...'),
              error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
              data: (invs) {
                if (invs.isEmpty) {
                  return EmptyState(
                    icon: Icons.fact_check_outlined,
                    title: _filterToday || _invInicio != null 
                        ? 'Nenhum inventário no período' 
                        : 'Nenhum inventário planejado',
                    subtitle: 'Crie um novo inventário para iniciar a contagem física.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: invs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final inv = invs[i];
                    return ListTile(
                      onTap: () => context.push('/estoque/contagem/${inv.idInventario}'),
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                        child: Text(inv.status[0].toUpperCase(), style: const TextStyle(color: AppTheme.primaryColor)),
                      ),
                      title: Text('Inventário: ${inv.codigo}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(inv.descricao ?? 'Sem descrição'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StatusChip.fromStatus(inv.status),
                          const SizedBox(height: 4),
                          Text(Formatters.date(inv.dataInicio), style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectHistDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _histInicio != null && _histFim != null
          ? DateTimeRange(start: _histInicio!, end: _histFim!)
          : null,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      helpText: 'Selecione o período do histórico',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppTheme.primaryColor,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _histInicio = picked.start;
        _histFim = picked.end;
        _filterHistToday = false;
      });
    }
  }

  Future<void> _selectInvDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _invInicio != null && _invFim != null
          ? DateTimeRange(start: _invInicio!, end: _invFim!)
          : null,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      helpText: 'Selecione o período do inventário',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: AppTheme.primaryColor,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _invInicio = picked.start;
        _invFim = picked.end;
        _filterToday = false;
      });
    }
  }

  void _showNovoInventario() {
    showDialog(
      context: context,
      builder: (context) => const NovoInventarioDialog(),
    );
  }
}
