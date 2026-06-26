import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/purchase_provider.dart';
import 'package:unifytechxenoswebowner/data/repositories/purchase_repository.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/domain/models/purchase.dart';
import 'package:unifytechxenoswebowner/presentation/views/purchases/widgets/purchase_detail_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/purchases/widgets/receive_purchase_dialog.dart';

import 'package:unifytechxenoswebowner/presentation/providers/supplier_provider.dart';

class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final purchasesAsync = ref.watch(purchasesProvider);
    final filters = ref.watch(purchaseFilterStateProvider);
    final suppliersAsync = ref.watch(suppliersProvider);

    return Column(
      children: [
        // Toolbar
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              // Search NF
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: (v) => ref.read(purchaseFilterStateProvider.notifier).setNotaFiscal(v),
                  decoration: const InputDecoration(
                    hintText: 'Buscar por nota fiscal...',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Supplier Filter
              Expanded(
                flex: 3,
                child: suppliersAsync.when(
                  data: (suppliers) => DropdownButtonFormField<int?>(
                    value: filters.fornecedorId,
                    decoration: const InputDecoration(labelText: 'Fornecedor'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todos os Fornecedores')),
                      ...suppliers.map((s) => DropdownMenuItem(
                        value: s.idFornecedor,
                        child: Text(s.razaoSocial, overflow: TextOverflow.ellipsis),
                      )),
                    ],
                    onChanged: (v) => ref.read(purchaseFilterStateProvider.notifier).setFornecedorId(v),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Erro ao carregar'),
                ),
              ),
              const SizedBox(width: 12),
              // Status Filter
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String?>(
                  value: filters.status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todos os Status')),
                    ...['pendente', 'recebida', 'cancelada'].map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(Formatters.statusCompra(s)),
                    )),
                  ],
                  onChanged: (v) => ref.read(purchaseFilterStateProvider.notifier).setStatus(v),
                ),
              ),
              const SizedBox(width: 12),
              // Date Range
              OutlinedButton.icon(
                onPressed: () async {
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    initialDateRange: filters.dataInicio != null && filters.dataFim != null
                      ? DateTimeRange(start: filters.dataInicio!, end: filters.dataFim!)
                      : null,
                    builder: (context, child) => Theme(
                      data: theme.copyWith(
                        colorScheme: theme.colorScheme.copyWith(
                          primary: AppTheme.primaryColor,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  ref.read(purchaseFilterStateProvider.notifier).setRange(range);
                },
                icon: const Icon(Icons.calendar_today_rounded, size: 18),
                label: Text(
                  filters.dataInicio == null 
                    ? 'Período' 
                    : '${Formatters.date(filters.dataInicio)} - ${Formatters.date(filters.dataFim)}'
                ),
              ),
              const SizedBox(width: 8),
              if (filters.status != null || filters.notaFiscal != null || filters.dataInicio != null || filters.fornecedorId != null)
                IconButton(
                  onPressed: () => ref.read(purchaseFilterStateProvider.notifier).clear(),
                  icon: const Icon(Icons.filter_list_off_rounded, color: AppTheme.accentRed),
                  tooltip: 'Limpar filtros',
                ),
            ],
          ),
        ),
        // List
        Expanded(
          child: Container(
            decoration: AppTheme.glassCard(),
            clipBehavior: Clip.antiAlias,
            child: purchasesAsync.when(
              loading: () => const LoadingOverlay(message: 'Carregando compras...'),
              error: (e, _) => EmptyState(
                icon: Icons.error_outline,
                title: 'Erro ao carregar compras',
                subtitle: e.toString(),
                action: ElevatedButton(
                  onPressed: () => ref.refresh(purchasesProvider),
                  child: const Text('Tentar novamente'),
                ),
              ),
              data: (paginated) {
                final purchases = paginated.data;
                if (purchases.isEmpty) {
                  return const EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'Nenhuma compra encontrada',
                    subtitle: 'Ajuste os filtros ou registre novas compras.',
                  );
                }
                return SingleChildScrollView(
                  child: DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text('DATA')),
                      DataColumn(label: Text('NF')),
                      DataColumn(label: Text('FORNECEDOR')),
                      DataColumn(label: Text('VALOR TOTAL'), numeric: true),
                      DataColumn(label: Text('STATUS')),
                      DataColumn(label: Text('AÇÕES')),
                    ],
                    rows: purchases.map((c) => DataRow(
                      cells: [
                        DataCell(Text(Formatters.date(c.dataEntrada))),
                        DataCell(Text(c.numeroNotaFiscal ?? '-')),
                        DataCell(Text(c.fornecedorNome ?? 'Não informado')),
                        DataCell(Text(Formatters.currency(c.valorTotal), style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(StatusChip.fromStatus(c.status)),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (c.status == 'pendente')
                                IconButton(
                                  icon: const Icon(Icons.check_circle_outline, color: AppTheme.accentGreen),
                                  tooltip: 'Marcar como Recebida',
                                  onPressed: () => _confirmReceive(context, ref, c),
                                ),
                              IconButton(
                                icon: const Icon(Icons.visibility_outlined, size: 18),
                                tooltip: 'Ver Detalhes',
                                onPressed: () => _showDetails(context, c),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )).toList(),
                  ),
                );
              },
            ),
          ),
        ),
        // Pagination Bar
        if (purchasesAsync.valueOrNull != null) ...[
          const SizedBox(height: 16),
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
                      value: filters.limit,
                      underline: const SizedBox(),
                      items: [10, 20, 50, 100].map((limit) => DropdownMenuItem(
                        value: limit,
                        child: Text('$limit'),
                      )).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(purchaseFilterStateProvider.notifier).setLimit(val);
                        }
                      },
                    ),
                  ],
                ),
                Text(
                  'Mostrando ${purchasesAsync.value!.data.isEmpty ? 0 : (filters.page - 1) * filters.limit + 1} - '
                  '${(filters.page - 1) * filters.limit + purchasesAsync.value!.data.length} de '
                  '${purchasesAsync.value!.total}',
                  style: theme.textTheme.bodyMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left_rounded),
                      onPressed: purchasesAsync.value!.hasPreviousPage
                          ? () => ref.read(purchaseFilterStateProvider.notifier).setPage(filters.page - 1)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Pág. ${filters.page}',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded),
                      onPressed: purchasesAsync.value!.hasNextPage
                          ? () => ref.read(purchaseFilterStateProvider.notifier).setPage(filters.page + 1)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showDetails(BuildContext context, Compra compra) {
    showDialog(
      context: context,
      builder: (context) => PurchaseDetailDialog(compraId: compra.idCompra),
    );
  }

  Future<void> _confirmReceive(BuildContext context, WidgetRef ref, Compra compra) async {
    try {
      // 1. Carregar detalhes completos da compra (garantir que itens existam)
      final fullCompra = await ref.read(purchaseRepositoryProvider).buscarPorID(compra.idCompra);
      
      if (!context.mounted) return;

      // 2. Abrir diálogo com a compra completa
      final request = await showDialog<ReceberCompraRequest>(
        context: context,
        barrierDismissible: false,
        builder: (context) => ReceivePurchaseDialog(compra: fullCompra),
      );

      if (request != null) {
        final (success, message) = await ref.read(purchaseActionsProvider.notifier).receber(compra.idCompra, request);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: success ? AppTheme.accentGreen : AppTheme.accentRed),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar itens da compra: $e'), backgroundColor: AppTheme.accentRed),
        );
      }
    }
  }
}
