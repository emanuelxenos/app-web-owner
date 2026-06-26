import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/domain/models/category.dart';
import 'package:unifytechxenoswebowner/core/utils/debouncer.dart';
import 'package:unifytechxenoswebowner/presentation/providers/category_provider.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final _searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoriesProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorias',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Search Box
          Container(
            decoration: AppTheme.glassCard(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) {
                _debouncer.run(() => ref.read(categoriesProvider.notifier).setSearch(v));
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar categorias...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                border: InputBorder.none,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(categoriesProvider.notifier).setSearch('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: AppTheme.glassCard(),
              padding: const EdgeInsets.all(16),
              child: state.response.when(
                data: (paginated) {
                  final categories = paginated.data;
                  if (categories.isEmpty) {
                    return const Center(child: Text('Nenhuma categoria encontrada.', style: TextStyle(color: Colors.white70)));
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              headingTextStyle: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                              columns: const [
                                DataColumn(label: Text('Ícone')),
                                DataColumn(label: Text('Nome')),
                                DataColumn(label: Text('Produtos')),
                                DataColumn(label: Text('Descrição')),
                              ],
                              rows: categories.map((cat) {
                                final Color catColor = cat.corHex != null 
                                    ? Color(int.parse(cat.corHex!.replaceFirst('#', '0xFF')))
                                    : AppTheme.primaryColor;

                                return DataRow(
                                  color: WidgetStateProperty.resolveWith<Color?>(
                                    (Set<WidgetState> states) {
                                      if (cat.categoriaPaiId == null) {
                                        return Colors.white.withValues(alpha: 0.03); // Sutil destaque para o Pai
                                      }
                                      return null;
                                    },
                                  ),
                                  cells: [
                                    DataCell(
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: catColor.withValues(alpha: 0.2),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: catColor.withValues(alpha: 0.5), 
                                            width: cat.categoriaPaiId == null ? 2 : 1
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            cat.icone ?? '📁',
                                            style: TextStyle(fontSize: cat.categoriaPaiId == null ? 20 : 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          if (cat.categoriaPaiId != null) ...[
                                            const SizedBox(width: 20),
                                            Container(
                                              width: 2,
                                              height: 30,
                                              color: catColor.withValues(alpha: 0.2),
                                            ),
                                            const SizedBox(width: 12),
                                          ],
                                          Text(
                                            cat.nome, 
                                            style: TextStyle(
                                              color: Colors.white, 
                                              fontWeight: cat.categoriaPaiId == null ? FontWeight.bold : FontWeight.w400,
                                              fontSize: cat.categoriaPaiId == null ? 15 : 13,
                                              letterSpacing: cat.categoriaPaiId == null ? 0.5 : 0,
                                            )
                                          ),
                                        ],
                                      )
                                    ),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: cat.categoriaPaiId == null ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.white10,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          '${cat.totalProdutos} itens',
                                          style: TextStyle(
                                            color: cat.categoriaPaiId == null ? AppTheme.primaryColor : Colors.white70, 
                                            fontSize: 10,
                                            fontWeight: cat.categoriaPaiId == null ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(cat.descricao ?? '-', style: const TextStyle(color: Colors.white70, fontSize: 12))),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const Divider(color: Colors.white10),
                      // Pagination controls
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total: ${paginated.total} categorias',
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
                                      ? () => ref.read(categoriesProvider.notifier).setPage(paginated.page - 1)
                                      : null,
                                  icon: const Icon(Icons.chevron_left),
                                  color: Colors.white,
                                ),
                                IconButton(
                                  onPressed: paginated.hasNextPage
                                      ? () => ref.read(categoriesProvider.notifier).setPage(paginated.page + 1)
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    'Erro ao carregar categorias: $error',
                    style: const TextStyle(color: AppTheme.accentRed),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogCategoria([Categoria? categoria]) {
    showDialog(
      context: context,
      builder: (context) => _CategoriaDialog(categoria: categoria),
    );
  }

  void _confirmarInativacao(Categoria cat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C2039),
        title: const Text('Inativar Categoria', style: TextStyle(color: Colors.white)),
        content: Text('Deseja realmente inativar a categoria "${cat.nome}"?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentRed),
            onPressed: () async {
              Navigator.pop(context);
              final (success, msg) = await ref.read(categoriesProvider.notifier).inativar(cat.idCategoria);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    backgroundColor: success ? AppTheme.accentGreen : AppTheme.accentRed,
                  ),
                );
              }
            },
            child: const Text('Inativar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _CategoriaDialog extends ConsumerStatefulWidget {
  final Categoria? categoria;

  const _CategoriaDialog({this.categoria});

  @override
  ConsumerState<_CategoriaDialog> createState() => _CategoriaDialogState();
}

class _CategoriaDialogState extends ConsumerState<_CategoriaDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _iconeController;
  String _selectedColor = '#6366f1';
  int? _selectedParentId;
  bool _isLoading = false;

  final List<String> _colors = [
    '#6366f1', // Indigo
    '#ef4444', // Red
    '#22c55e', // Green
    '#eab308', // Yellow
    '#a855f7', // Purple
    '#f97316', // Orange
    '#06b6d4', // Cyan
    '#ec4899', // Pink
  ];

  final List<String> _emojis = ['📁', '🍔', '🥤', '🍕', '🍰', '🍺', '🍖', '🍎', '🥦', '🍦', '🧼', '👕', '👟', '📱', '🔋'];

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.categoria?.nome);
    _descricaoController = TextEditingController(text: widget.categoria?.descricao);
    _iconeController = TextEditingController(text: widget.categoria?.icone ?? '📁');
    _selectedColor = widget.categoria?.corHex ?? '#6366f1';
    _selectedParentId = widget.categoria?.categoriaPaiId;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _iconeController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final req = CriarCategoriaRequest(
      nome: _nomeController.text.trim(),
      descricao: _descricaoController.text.trim().isNotEmpty ? _descricaoController.text.trim() : null,
      icone: _iconeController.text.trim(),
      corHex: _selectedColor,
      ordemExibicao: widget.categoria?.ordemExibicao ?? 0,
      categoriaPaiId: _selectedParentId,
    );

    final notifier = ref.read(categoriesProvider.notifier);
    bool success;
    String msg;

    if (widget.categoria == null) {
      final res = await notifier.criar(req);
      success = res.$1;
      msg = res.$2;
    } else {
      final res = await notifier.atualizar(widget.categoria!.idCategoria, req);
      success = res.$1;
      msg = res.$2;
    }

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: success ? AppTheme.accentGreen : AppTheme.accentRed,
        ),
      );
      if (success) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.categoria != null;
    return AlertDialog(
      backgroundColor: const Color(0xFF1C2039),
      title: Text(isEditing ? 'Editar Categoria' : 'Nova Categoria',
          style: const TextStyle(color: Colors.white)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                style: const TextStyle(color: Colors.white),
                validator: (val) => val == null || val.trim().isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              // Parent Category Selector
              Consumer(
                builder: (context, ref, child) {
                  final categoriesAsync = ref.watch(categoriesProvider).response;
                  return categoriesAsync.maybeWhen(
                    data: (paginated) {
                      // Filter out current category to avoid circular reference
                      final availableParents = paginated.data
                          .where((c) => c.idCategoria != widget.categoria?.idCategoria && c.categoriaPaiId == null)
                          .toList();

                      return DropdownButtonFormField<int?>(
                        value: _selectedParentId,
                        dropdownColor: const Color(0xFF1C2039),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Categoria Pai (opcional)',
                          hintText: 'Nenhuma',
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('Nenhuma (Principal)', style: TextStyle(color: Colors.white70)),
                          ),
                          ...availableParents.map((c) => DropdownMenuItem<int?>(
                                value: c.idCategoria,
                                child: Text(c.nome),
                              )),
                        ],
                        onChanged: (val) => setState(() => _selectedParentId = val),
                      );
                    },
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição (opcional)'),
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              const Text('Escolha um Ícone / Emoji', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _emojis.map((e) => GestureDetector(
                  onTap: () => setState(() => _iconeController.text = e),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _iconeController.text == e ? AppTheme.primaryColor.withValues(alpha: 0.3) : Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _iconeController.text == e ? AppTheme.primaryColor : Colors.transparent),
                    ),
                    child: Text(e, style: const TextStyle(fontSize: 20)),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 24),
              const Text('Cor da Categoria', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: _colors.map((c) => GestureDetector(
                  onTap: () => setState(() => _selectedColor = c),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(int.parse(c.replaceFirst('#', '0xFF'))),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == c ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        if (_selectedColor == c)
                          BoxShadow(color: Color(int.parse(c.replaceFirst('#', '0xFF'))).withValues(alpha: 0.5), blurRadius: 8)
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _salvar,
          child: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Salvar'),
        ),
      ],
    );
  }
}
