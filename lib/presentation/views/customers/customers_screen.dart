import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/debouncer.dart';
import 'package:unifytechxenoswebowner/domain/models/customer.dart';
import 'package:unifytechxenoswebowner/presentation/providers/auth_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/customer_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/presentation/views/customers/widgets/customers_help_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/customers/widgets/filter_chip_btn.dart';
import 'package:unifytechxenoswebowner/presentation/views/customers/widgets/export_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/customers/widgets/customer_details_drawer.dart';
import 'package:unifytechxenoswebowner/presentation/views/customers/widgets/customer_form_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/customers/widgets/customer_history_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/customers/widgets/bulk_limit_adjustment_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/customers/utils/customer_utils.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _debouncer = Debouncer(milliseconds: 300);
  final _searchController = TextEditingController();
  bool _showKPIs = true;
  bool _showFilterPanel = false;
  final Set<int> _selectedIds = {};

  // Local controllers for filter panel
  final _limiteMinCtrl = TextEditingController();
  final _limiteMaxCtrl = TextEditingController();

  void _onSort(String field) {
    final currentField = ref.read(customerSortFieldProvider);
    final currentAsc = ref.read(customerSortAscendingProvider);
    if (currentField == field) {
      ref.read(customerSortAscendingProvider.notifier).state = !currentAsc;
    } else {
      ref.read(customerSortFieldProvider.notifier).state = field;
      ref.read(customerSortAscendingProvider.notifier).state = true;
    }
    ref.read(customerPageProvider.notifier).state = 0;
  }

  int? _getSortColumnIndex(String? field) {
    switch (field) {
      case 'nome':
        return 0;
      case 'tipo_pessoa':
        return 1;
      case 'limite_credito':
        return 4;
      case 'saldo_devedor':
        return 5;
      case 'data_cadastro':
        return 6;
      default:
        return null;
    }
  }

  bool get _hasActiveFilters {
    return ref.read(customerFilterTipoPessoaProvider) != null ||
        ref.read(customerFilterLimiteMinProvider) != null ||
        ref.read(customerFilterLimiteMaxProvider) != null ||
        ref.read(customerFilterInadimplenteProvider);
  }

  void _clearFilters() {
    ref.read(customerFilterTipoPessoaProvider.notifier).state = null;
    ref.read(customerFilterLimiteMinProvider.notifier).state = null;
    ref.read(customerFilterLimiteMaxProvider.notifier).state = null;
    ref.read(customerFilterInadimplenteProvider.notifier).state = false;
    _limiteMinCtrl.clear();
    _limiteMaxCtrl.clear();
    ref.read(customerPageProvider.notifier).state = 0;
  }

  void _applyFilters() {
    final minText = _limiteMinCtrl.text.trim().replaceAll(',', '.');
    final maxText = _limiteMaxCtrl.text.trim().replaceAll(',', '.');
    ref.read(customerFilterLimiteMinProvider.notifier).state =
        minText.isNotEmpty ? double.tryParse(minText) : null;
    ref.read(customerFilterLimiteMaxProvider.notifier).state =
        maxText.isNotEmpty ? double.tryParse(maxText) : null;
    ref.read(customerPageProvider.notifier).state = 0;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchController.text = ref.read(customerSearchProvider);
      }
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _searchController.dispose();
    _limiteMinCtrl.dispose();
    _limiteMaxCtrl.dispose();
    super.dispose();
  }

  Widget _buildKPIRow(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(customerStatsNotifierProvider);
    return statsAsync.when(
      loading: () => const SizedBox(
          height: 80, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => const SizedBox.shrink(),
      data: (stats) {
        return Row(
          children: [
            Expanded(
              child: _buildKPICard(context,
                  title: 'Clientes Ativos',
                  value: '${stats.totalClientes}',
                  icon: Icons.people_rounded,
                  color: Colors.blueAccent),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(context,
                  title: 'Saldo Devedor Total',
                  value: 'R\$ ${stats.saldoDevedorTotal.toStringAsFixed(2)}',
                  icon: Icons.money_off_rounded,
                  color: AppTheme.accentRed),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(context,
                  title: 'Limite de Crédito Total',
                  value: 'R\$ ${stats.limiteCreditoTotal.toStringAsFixed(2)}',
                  icon: Icons.credit_card_rounded,
                  color: Colors.green),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildKPICard(context,
                  title: 'Clientes Inadimplentes',
                  value: '${stats.totalInadimplentes}',
                  icon: Icons.warning_amber_rounded,
                  color: Colors.orange),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKPICard(BuildContext context,
      {required String title,
      required String value,
      required IconData icon,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: AppTheme.glassCard().copyWith(
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            radius: 18,
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Advanced Filter Panel ────────────────────────────────────────────────
  Widget _buildFilterPanel() {
    final tipoPessoa = ref.watch(customerFilterTipoPessoaProvider);
    final inadimplente = ref.watch(customerFilterInadimplenteProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: _showFilterPanel ? 280 : 0,
      child: _showFilterPanel
          ? Container(
              margin: const EdgeInsets.only(left: 12),
              decoration: AppTheme.glassCard().copyWith(
                border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.4),
                    width: 1.2),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filtros Avançados',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        if (_hasActiveFilters)
                          TextButton(
                            onPressed: _clearFilters,
                            child: const Text('Limpar',
                                style: TextStyle(
                                    color: AppTheme.accentRed, fontSize: 12)),
                          ),
                      ],
                    ),
                    const Divider(color: Colors.white12, height: 20),

                    // Tipo de Pessoa
                    const Text('Tipo de Pessoa',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        FilterChipBtn(
                          label: 'Todos',
                          selected: tipoPessoa == null,
                          onTap: () {
                            ref
                                .read(
                                    customerFilterTipoPessoaProvider.notifier)
                                .state = null;
                            ref.read(customerPageProvider.notifier).state = 0;
                          },
                        ),
                        const SizedBox(width: 6),
                        FilterChipBtn(
                          label: 'Física',
                          selected: tipoPessoa == 'F',
                          onTap: () {
                            ref
                                .read(
                                    customerFilterTipoPessoaProvider.notifier)
                                .state = 'F';
                            ref.read(customerPageProvider.notifier).state = 0;
                          },
                        ),
                        const SizedBox(width: 6),
                        FilterChipBtn(
                          label: 'Jurídica',
                          selected: tipoPessoa == 'J',
                          onTap: () {
                            ref
                                .read(
                                    customerFilterTipoPessoaProvider.notifier)
                                .state = 'J';
                            ref.read(customerPageProvider.notifier).state = 0;
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Faixa de Limite de Crédito
                    const Text('Faixa de Limite (R\$)',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _limiteMinCtrl,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                            decoration: const InputDecoration(
                              hintText: 'Mín',
                              hintStyle: TextStyle(
                                  color: Colors.white38, fontSize: 12),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              isDense: true,
                            ),
                            onSubmitted: (_) => _applyFilters(),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text('—',
                              style: TextStyle(color: Colors.white54)),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _limiteMaxCtrl,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                            decoration: const InputDecoration(
                              hintText: 'Máx',
                              hintStyle: TextStyle(
                                  color: Colors.white38, fontSize: 12),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              isDense: true,
                            ),
                            onSubmitted: (_) => _applyFilters(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _applyFilters,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: AppTheme.primaryColor.withValues(
                                  alpha: 0.6)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 6),
                        ),
                        child: const Text('Aplicar Faixa',
                            style: TextStyle(
                                color: AppTheme.primaryColor, fontSize: 12)),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Inadimplência
                    const Text('Inadimplência',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Apenas inadimplentes',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12)),
                      value: inadimplente,
                      activeColor: AppTheme.accentRed,
                      onChanged: (v) {
                        ref
                            .read(customerFilterInadimplenteProvider.notifier)
                            .state = v;
                        ref.read(customerPageProvider.notifier).state = 0;
                      },
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // ─── Bulk Actions Bar ─────────────────────────────────────────────────────
  Widget _buildBulkActionsBar(BuildContext context) {
    return Container(
      decoration: AppTheme.glassCard().copyWith(
        color: const Color(0xFF1F2244).withValues(alpha: 0.95),
        border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle),
              child: const Icon(Icons.check_box_outlined,
                  color: AppTheme.primaryColor, size: 18),
            ),
            const SizedBox(width: 12),
            Text('${_selectedIds.length} selecionado(s)',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ]),
          Row(children: [
            TextButton.icon(
              icon: const Icon(Icons.edit_outlined,
                  size: 14, color: Colors.blueAccent),
              label: const Text('Reajustar Limite',
                  style:
                      TextStyle(color: Colors.blueAccent, fontSize: 13)),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => BulkLimitAdjustmentDialog(
                    ids: _selectedIds.toList(),
                    onSuccess: () =>
                        setState(() => _selectedIds.clear()),
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            TextButton.icon(
              icon: const Icon(Icons.person_off_outlined,
                  size: 14, color: AppTheme.accentRed),
              label: const Text('Inativar Selecionados',
                  style:
                      TextStyle(color: AppTheme.accentRed, fontSize: 13)),
              onPressed: () => _confirmBulkInactivate(context),
            ),
            const SizedBox(width: 16),
            const SizedBox(
                height: 24,
                child: VerticalDivider(
                    color: Colors.white24, width: 1, thickness: 1)),
            const SizedBox(width: 16),
            IconButton(
              icon:
                  const Icon(Icons.close, color: Colors.white54, size: 18),
              tooltip: 'Limpar seleção',
              onPressed: () => setState(() => _selectedIds.clear()),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> _confirmBulkInactivate(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C2039),
        title: const Text('Inativar Clientes em Lote',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Deseja inativar os ${_selectedIds.length} clientes selecionados?\nEles não aparecerão mais nas novas vendas.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar',
                  style: TextStyle(color: Colors.white70))),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentRed),
              child: const Text('Inativar Todos',
                  style: TextStyle(color: Colors.white))),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final (success, message) = await ref
          .read(customersProvider.notifier)
          .inativarEmLote(_selectedIds.toList());
      if (context.mounted) {
        if (success) {
          AppNotifications.showSuccess(context, message);
          setState(() => _selectedIds.clear());
        } else {
          AppNotifications.showError(context, message);
        }
      }
    }
  }

  // ─── Export dialog ────────────────────────────────────────────────────────
  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ExportDialog(
        activeSearch: ref.read(customerSearchProvider),
        activeTipoPessoa: ref.read(customerFilterTipoPessoaProvider),
        activeLimiteMin: ref.read(customerFilterLimiteMinProvider),
        activeLimiteMax: ref.read(customerFilterLimiteMaxProvider),
        activeInadimplente: ref.read(customerFilterInadimplenteProvider),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customersAsync = ref.watch(customersProvider);
    final filtered = ref.watch(filteredCustomersProvider);
    final page = ref.watch(customerPageProvider);
    final itemsPerPage = ref.watch(customerItemsPerPageProvider);
    final hasActiveFilters = ref.watch(customerFilterTipoPessoaProvider) != null ||
        ref.watch(customerFilterLimiteMinProvider) != null ||
        ref.watch(customerFilterLimiteMaxProvider) != null ||
        ref.watch(customerFilterInadimplenteProvider);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Text('Clientes',
                        style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded,
                          color: Colors.white70),
                      tooltip: 'Recarregar Dados',
                      onPressed: () =>
                          ref.read(customersProvider.notifier).refresh(),
                    ),
                    IconButton(
                      icon: Icon(
                          _showKPIs
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white70),
                      onPressed: () =>
                          setState(() => _showKPIs = !_showKPIs),
                      tooltip: _showKPIs
                          ? 'Ocultar Indicadores'
                          : 'Mostrar Indicadores',
                    ),
                  ]),
                  Row(children: [
                    // Help button
                    IconButton(
                      icon: const Icon(Icons.help_outline_rounded, color: Colors.blueAccent),
                      tooltip: 'Central de Ajuda',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const CustomersHelpDialog(),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    // Filter toggle button
                    Tooltip(
                      message: 'Filtros Avançados',
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: _showFilterPanel || hasActiveFilters
                              ? AppTheme.primaryColor.withValues(alpha: 0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _showFilterPanel || hasActiveFilters
                                ? AppTheme.primaryColor
                                : Colors.white24,
                          ),
                        ),
                        child: IconButton(
                          icon: Badge(
                            isLabelVisible: hasActiveFilters,
                            backgroundColor: AppTheme.accentRed,
                            child: const Icon(Icons.tune_rounded,
                                color: Colors.white70),
                          ),
                          onPressed: () => setState(
                              () => _showFilterPanel = !_showFilterPanel),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Export button
                    OutlinedButton.icon(
                      onPressed: () => _showExportDialog(context),
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('Exportar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white24),
                      ),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 16),

              // KPI indicators with animation
              AnimatedCrossFade(
                firstChild: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildKPIRow(context, ref)),
                secondChild: const SizedBox.shrink(),
                crossFadeState: _showKPIs
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300),
              ),

              // Toolbar: Search + Inactive toggle
              Row(children: [
                Expanded(
                  child: Container(
                    decoration: AppTheme.glassCard(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) {
                        _debouncer.run(() {
                          if (mounted) {
                            ref
                                .read(customerSearchProvider.notifier)
                                .setQuery(v);
                            ref
                                .read(customerPageProvider.notifier)
                                .state = 0;
                          }
                        });
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText:
                            'Buscar cliente por nome, CPF/CNPJ ou email...',
                        hintStyle: TextStyle(color: Colors.white54),
                        prefixIcon: Icon(Icons.search_rounded,
                            color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                FilterChip(
                  label: const Text('Mostrar Inativos'),
                  selected: ref.watch(customerInactivesProvider),
                  onSelected: (v) {
                    ref.read(customerInactivesProvider.notifier).set(v);
                    ref.read(customerPageProvider.notifier).state = 0;
                  },
                  selectedColor:
                      AppTheme.primaryColor.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.primaryColor,
                ),
              ]),
              const SizedBox(height: 16),

              // Table + Filter Panel (side by side)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main table card
                    Expanded(
                      child: Container(
                        decoration: AppTheme.glassCard(),
                        clipBehavior: Clip.antiAlias,
                        child: Column(children: [
                          Expanded(
                            child: customersAsync.when(
                              loading: () => const LoadingOverlay(
                                  message: 'Carregando clientes...'),
                              error: (e, _) => EmptyState(
                                icon: Icons.error_outline,
                                title: 'Erro ao carregar',
                                subtitle: e.toString(),
                                action: ElevatedButton(
                                  onPressed: () => ref
                                      .read(customersProvider.notifier)
                                      .refresh(),
                                  child: const Text('Tentar novamente'),
                                ),
                              ),
                              data: (res) {
                                final totalPages =
                                    (res.total / itemsPerPage).ceil();
                                if (page >= totalPages && totalPages > 0) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted) {
                                      ref
                                          .read(
                                              customerPageProvider.notifier)
                                          .state = totalPages - 1;
                                    }
                                  });
                                }
                                if (filtered.isEmpty) {
                                  return const EmptyState(
                                    icon: Icons.people_alt_outlined,
                                    title: 'Nenhum cliente encontrado',
                                    subtitle:
                                        'Cadastre clientes para utilizá-los nas vendas e no crediário.',
                                  );
                                }
                                return SizedBox.expand(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      child: DataTable(
                                        showCheckboxColumn: true,
                                        headingTextStyle: const TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold),
                                        sortColumnIndex:
                                            _getSortColumnIndex(ref.watch(
                                                customerSortFieldProvider)),
                                        sortAscending: ref.watch(
                                            customerSortAscendingProvider),
                                        onSelectAll: (isSelected) {
                                          setState(() {
                                            if (isSelected == true) {
                                              for (final c in filtered) {
                                                _selectedIds
                                                    .add(c.idCliente);
                                              }
                                            } else {
                                              for (final c in filtered) {
                                                _selectedIds
                                                    .remove(c.idCliente);
                                              }
                                            }
                                          });
                                        },
                                        columns: [
                                          DataColumn(
                                              label: const Text('NOME'),
                                              onSort: (_, __) =>
                                                  _onSort('nome')),
                                          DataColumn(
                                              label: const Text('TIPO'),
                                              onSort: (_, __) =>
                                                  _onSort('tipo_pessoa')),
                                          const DataColumn(
                                              label: Text('CPF / CNPJ')),
                                          const DataColumn(
                                              label: Text('TELEFONE')),
                                          DataColumn(
                                              label: const Text(
                                                  'LIMITE CRÉDITO'),
                                              onSort: (_, __) => _onSort(
                                                  'limite_credito')),
                                          DataColumn(
                                              label: const Text(
                                                  'SALDO DEVEDOR'),
                                              onSort: (_, __) =>
                                                  _onSort('saldo_devedor')),
                                          DataColumn(
                                              label: const Text('CADASTRO'),
                                              onSort: (_, __) =>
                                                  _onSort('data_cadastro')),
                                          const DataColumn(
                                              label: Text('STATUS')),
                                        ],
                                        rows: filtered
                                            .map((c) =>
                                                _buildRow(context, ref, c))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Pagination footer
                          customersAsync.maybeWhen(
                            data: (res) {
                              if (res.total > 0) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Divider(
                                        color: Colors.white10, height: 1),
                                    _buildPaginationFooter(
                                        context, res.total),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            orElse: () => const SizedBox.shrink(),
                          ),
                        ]),
                      ),
                    ),

                    // Filter Panel (slides in from right)
                    _buildFilterPanel(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationFooter(BuildContext context, int totalItems) {
    final page = ref.watch(customerPageProvider);
    final itemsPerPage = ref.watch(customerItemsPerPageProvider);
    final totalPages = (totalItems / itemsPerPage).ceil();
    final startItem = page * itemsPerPage + 1;
    final endItem = math.min((page + 1) * itemsPerPage, totalItems);

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Text('Itens por página:',
                style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(width: 8),
            Theme(
              data: Theme.of(context)
                  .copyWith(canvasColor: const Color(0xFF1C2039)),
              child: DropdownButton<int>(
                value: itemsPerPage,
                dropdownColor: const Color(0xFF1C2039),
                style: const TextStyle(color: Colors.white, fontSize: 13),
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down,
                    color: Colors.white54),
                items: [5, 10, 15, 25, 50].map((int value) {
                  return DropdownMenuItem<int>(
                      value: value, child: Text('$value'));
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    ref
                        .read(customerItemsPerPageProvider.notifier)
                        .state = newValue;
                    ref.read(customerPageProvider.notifier).state = 0;
                  }
                },
              ),
            ),
          ]),
          Row(children: [
            Text('Exibindo $startItem-$endItem de $totalItems',
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13)),
            const SizedBox(width: 24),
            IconButton(
                icon: const Icon(Icons.first_page_rounded,
                    color: Colors.white70),
                tooltip: 'Primeira Página',
                onPressed: page > 0
                    ? () =>
                        ref.read(customerPageProvider.notifier).state = 0
                    : null),
            IconButton(
                icon: const Icon(Icons.chevron_left_rounded,
                    color: Colors.white70),
                tooltip: 'Página Anterior',
                onPressed: page > 0
                    ? () => ref.read(customerPageProvider.notifier).state =
                        page - 1
                    : null),
            Text('${page + 1} / $totalPages',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            IconButton(
                icon: const Icon(Icons.chevron_right_rounded,
                    color: Colors.white70),
                tooltip: 'Próxima Página',
                onPressed: page < totalPages - 1
                    ? () => ref.read(customerPageProvider.notifier).state =
                        page + 1
                    : null),
            IconButton(
                icon: const Icon(Icons.last_page_rounded,
                    color: Colors.white70),
                tooltip: 'Última Página',
                onPressed: page < totalPages - 1
                    ? () => ref.read(customerPageProvider.notifier).state =
                        totalPages - 1
                    : null),
          ]),
        ],
      ),
    );
  }

  DataRow _buildRow(BuildContext context, WidgetRef ref, Cliente c) {
    final podeEditarLimite = false;

    return DataRow(
      cells: [
        DataCell(
          GestureDetector(
            onDoubleTap: () => _showCustomerDetails(context, ref, c),
            child: Text(c.nome,
                style: const TextStyle(color: Colors.white)),
          ),
        ),
        DataCell(Text(
            c.tipoPessoa == 'J' ? 'Pessoa Jurídica' : 'Pessoa Física',
            style: const TextStyle(color: Colors.white70))),
        DataCell(Text(formatDocumento(c.tipoPessoa, c.cpfCnpj),
            style: const TextStyle(color: Colors.white70))),
        DataCell(Text(c.telefone ?? '-',
            style: const TextStyle(color: Colors.white70))),
        DataCell(
            _LimiteBadge(valor: c.limiteCredito, canEdit: podeEditarLimite)),
        DataCell(_SaldoDevedorBadge(valor: c.saldoDevedor)),
        DataCell(Text(
          c.dataCadastro != null
              ? '${c.dataCadastro!.day.toString().padLeft(2, '0')}/${c.dataCadastro!.month.toString().padLeft(2, '0')}/${c.dataCadastro!.year}'
              : '-',
          style: const TextStyle(color: Colors.white70),
        )),
        DataCell(StatusChip.fromStatus(c.ativo ? 'ativo' : 'inativo')),
      ],
    );
  }

  void _showCustomerHistory(
      BuildContext context, WidgetRef ref, Cliente c) {
    showDialog(
      context: context,
      builder: (context) => CustomerHistoryDialog(cliente: c),
    );
  }

  // Quick details drawer
  void _showCustomerDetails(
      BuildContext context, WidgetRef ref, Cliente c) {
    showDialog(
      context: context,
      builder: (context) => CustomerDetailsDrawer(cliente: c),
    );
  }
}

// ─── Badges ──────────────────────────────────────────────────────────
class _LimiteBadge extends StatelessWidget {
  final double valor;
  final bool canEdit;
  const _LimiteBadge({required this.valor, required this.canEdit});

  @override
  Widget build(BuildContext context) {
    return Text('R\$ ${valor.toStringAsFixed(2)}',
        style: TextStyle(
            color: canEdit ? Colors.white : Colors.white54,
            fontWeight:
                canEdit ? FontWeight.w600 : FontWeight.normal));
  }
}

class _SaldoDevedorBadge extends StatelessWidget {
  final double valor;
  const _SaldoDevedorBadge({required this.valor});

  @override
  Widget build(BuildContext context) {
    final color = valor > 0 ? AppTheme.accentRed : Colors.white54;
    return Text('R\$ ${valor.toStringAsFixed(2)}',
        style: TextStyle(
            color: color,
            fontWeight: valor > 0 ? FontWeight.w700 : FontWeight.normal));
  }
}
