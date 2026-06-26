import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/supplier_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/purchase_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/domain/models/supplier.dart';
import 'package:unifytechxenoswebowner/domain/models/purchase.dart';
import 'package:unifytechxenoswebowner/presentation/views/purchases/widgets/purchase_detail_dialog.dart';

class SupplierAnalyticsTab extends ConsumerStatefulWidget {
  const SupplierAnalyticsTab({super.key});

  @override
  ConsumerState<SupplierAnalyticsTab> createState() => _SupplierAnalyticsTabState();
}

class _SupplierAnalyticsTabState extends ConsumerState<SupplierAnalyticsTab> {
  late final SearchController _searchController;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _searchController = SearchController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suppliersAsync = ref.watch(suppliersProvider);
    final selectedSupplierId = ref.watch(selectedSupplierAnalyticsProvider);

    // Keep SearchController text synchronized with the Riverpod provider state
    if (selectedSupplierId == null) {
      _isCollapsed = false;
      if (_searchController.text.isNotEmpty) {
        _searchController.text = '';
      }
    } else {
      final suppliers = suppliersAsync.valueOrNull ?? [];
      final supplier = suppliers.any((s) => s.idFornecedor == selectedSupplierId)
          ? suppliers.firstWhere((s) => s.idFornecedor == selectedSupplierId)
          : null;
      if (supplier != null && _searchController.text != supplier.razaoSocial) {
        _searchController.text = supplier.razaoSocial;
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selector
        if (_isCollapsed)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: AppTheme.glassCard(),
              child: Row(
                children: [
                  const Icon(Icons.analytics_outlined, color: AppTheme.primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Análise: ${_searchController.text}',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    tooltip: 'Mostrar painel de busca e indicadores',
                    onPressed: () {
                      setState(() {
                        _isCollapsed = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.glassCard(),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selecionar Fornecedor',
                          style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 8),
                        suppliersAsync.when(
                          data: (suppliers) => SearchAnchor(
                            searchController: _searchController,
                            builder: (context, controller) {
                              final selectedSupplier = suppliers.any((s) => s.idFornecedor == selectedSupplierId)
                                  ? suppliers.firstWhere((s) => s.idFornecedor == selectedSupplierId)
                                  : null;

                              return SearchBar(
                                controller: controller,
                                hintText: selectedSupplier?.razaoSocial ?? 'Pesquisar fornecedor...',
                                padding: const WidgetStatePropertyAll<EdgeInsets>(
                                  EdgeInsets.symmetric(horizontal: 16.0),
                                ),
                                onTap: () => controller.openView(),
                                onChanged: (_) => controller.openView(),
                                leading: const Icon(Icons.search),
                                trailing: selectedSupplier != null ? [
                                  IconButton(
                                    onPressed: () => ref.read(selectedSupplierAnalyticsProvider.notifier).select(null),
                                    icon: const Icon(Icons.clear),
                                  ),
                                ] : null,
                              );
                            },
                            suggestionsBuilder: (context, controller) {
                              final query = controller.text.toLowerCase();
                              final filtered = suppliers.where((s) =>
                                  s.razaoSocial.toLowerCase().contains(query) ||
                                  (s.cnpj?.contains(query) ?? false)).toList();

                              return filtered.map((s) => ListTile(
                                    title: Text(s.razaoSocial),
                                    subtitle: Text(s.cnpj ?? 'Sem CNPJ'),
                                    onTap: () {
                                      ref.read(selectedSupplierAnalyticsProvider.notifier).select(s.idFornecedor);
                                      controller.closeView(s.razaoSocial);
                                    },
                                  ));
                            },
                          ),
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => Text('Erro ao carregar fornecedores: $e'),
                        ),
                      ],
                    ),
                  ),
                  if (selectedSupplierId != null) ...[
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_up_rounded),
                      tooltip: 'Ocultar painel de busca e indicadores',
                      onPressed: () {
                        setState(() {
                          _isCollapsed = true;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

        // Results
        if (selectedSupplierId == null)
          const Expanded(
            child: EmptyState(
              icon: Icons.analytics_outlined,
              title: 'Análise de Fornecedor',
              subtitle: 'Selecione um fornecedor acima para visualizar o histórico de compras e indicadores.',
            ),
          )
        else
          Expanded(
            child: _buildSupplierData(context, ref, selectedSupplierId, _isCollapsed),
          ),
      ],
    );
  }

  Widget _buildSupplierData(BuildContext context, WidgetRef ref, int supplierId, bool isCollapsed) {
    final theme = Theme.of(context);
    final historyAsync = ref.watch(paginatedSupplierHistoryProvider(supplierId));
    final allHistoryAsync = ref.watch(supplierHistoryProvider(supplierId));
    final historyFilters = ref.watch(supplierHistoryStateProvider(supplierId));

    return historyAsync.when(
      loading: () => const LoadingOverlay(message: 'Carregando histórico...'),
      error: (e, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Erro ao carregar dados',
        subtitle: e.toString(),
        action: ElevatedButton(
          onPressed: () {
            ref.invalidate(paginatedSupplierHistoryProvider(supplierId));
            ref.invalidate(supplierHistoryProvider(supplierId));
          },
          child: const Text('Tentar novamente'),
        ),
      ),
      data: (paginated) {
        final purchases = paginated.data;
        if (purchases.isEmpty) {
          return const EmptyState(
            icon: Icons.history_rounded,
            title: 'Nenhuma compra encontrada',
            subtitle: 'Este fornecedor ainda não possui registros de compras no sistema.',
          );
        }

        // Calculate stats
        final allPurchases = allHistoryAsync.valueOrNull ?? purchases;
        final totalValue = allPurchases.fold(0.0, (sum, c) => sum + c.valorTotal);
        final lastPurchase = allPurchases.first; // Already sorted by date DESC in backend

        return Column(
          children: [
            // KPI Bar
            if (!isCollapsed) ...[
              Row(
                children: [
                  Expanded(
                    child: KpiCard(
                      title: 'Total em Compras',
                      value: Formatters.currency(totalValue),
                      icon: Icons.account_balance_wallet_outlined,
                      color: AppTheme.accentBlue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: KpiCard(
                      title: 'Qtd. de Compras',
                      value: allPurchases.length.toString(),
                      icon: Icons.shopping_bag_outlined,
                      color: AppTheme.accentOrange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: KpiCard(
                      title: 'Última Compra',
                      value: Formatters.date(lastPurchase.dataEntrada),
                      subtitle: 'NF: ${lastPurchase.numeroNotaFiscal ?? '-'}',
                      icon: Icons.event_note_outlined,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
            // History Table
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: AppTheme.glassCard(),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: DataTable(
                          showCheckboxColumn: false,
                          columns: const [
                            DataColumn(label: Text('DATA')),
                            DataColumn(label: Text('NF')),
                            DataColumn(label: Text('VALOR PRODUTOS'), numeric: true),
                            DataColumn(label: Text('VALOR TOTAL'), numeric: true),
                            DataColumn(label: Text('STATUS')),
                            DataColumn(label: Text('AÇÕES')),
                          ],
                          rows: purchases.map((c) => DataRow(
                            cells: [
                              DataCell(Text(Formatters.date(c.dataEntrada))),
                              DataCell(Text(c.numeroNotaFiscal ?? '-')),
                              DataCell(Text(Formatters.currency(c.valorProdutos))),
                              DataCell(Text(
                                Formatters.currency(c.valorTotal),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              )),
                              DataCell(StatusChip.fromStatus(c.status)),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.visibility_outlined, size: 18),
                                      tooltip: 'Ver Detalhes',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => PurchaseDetailDialog(compraId: c.idCompra),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )).toList(),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Itens por página:', style: theme.textTheme.bodyMedium),
                              const SizedBox(width: 8),
                              DropdownButton<int>(
                                value: historyFilters.limit,
                                underline: const SizedBox(),
                                items: [5, 10, 20, 50].map((limit) => DropdownMenuItem(
                                  value: limit,
                                  child: Text('$limit'),
                                )).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    ref.read(supplierHistoryStateProvider(supplierId).notifier).setLimit(val);
                                  }
                                },
                              ),
                            ],
                          ),
                          Text(
                            'Mostrando ${purchases.isEmpty ? 0 : (historyFilters.page - 1) * historyFilters.limit + 1} - '
                            '${(historyFilters.page - 1) * historyFilters.limit + purchases.length} de '
                            '${paginated.total}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left_rounded),
                                onPressed: paginated.hasPreviousPage
                                    ? () => ref.read(supplierHistoryStateProvider(supplierId).notifier).setPage(historyFilters.page - 1)
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pág. ${historyFilters.page}',
                                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.chevron_right_rounded),
                                onPressed: paginated.hasNextPage
                                    ? () => ref.read(supplierHistoryStateProvider(supplierId).notifier).setPage(historyFilters.page + 1)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
