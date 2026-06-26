import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/auth_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/finance_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/presentation/views/finance/widgets/receipt_dialog.dart';

class ContasPagarTab extends ConsumerWidget {
  final ScrollController controller;
  const ContasPagarTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contasAsync = ref.watch(accountsPayableProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      clipBehavior: Clip.antiAlias,
      child: contasAsync.when(
        loading: () => const LoadingOverlay(message: 'Carregando...'),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Erro',
          subtitle: '$e',
        ),
        data: (paginated) {
          final contas = paginated.data;
          if (contas.isEmpty) {
            return const EmptyState(
              icon: Icons.check_circle_outline,
              title: 'Sem contas no período',
            );
          }
          return Column(
            children: [
              Expanded(
                child: Scrollbar(
                  controller: controller,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('DESCRIÇÃO')),
                        DataColumn(label: Text('CATEGORIA')),
                        DataColumn(label: Text('VENCIMENTO')),
                        DataColumn(label: Text('VALOR'), numeric: true),
                        DataColumn(label: Text('STATUS')),
                      ],
                      rows: contas.map((c) {
                        final role = ref.watch(authProvider).role;
                        final bool canManage =
                            role == 'admin' ||
                            role == 'gerente';

                        return DataRow(
                          cells: [
                            DataCell(Text(c.descricao)),
                            DataCell(
                              StatusChip(
                                label: c.categoria.toUpperCase(),
                                color: c.categoria == 'fornecedor'
                                    ? Colors.blue
                                    : Colors.purple,
                              ),
                            ),
                            DataCell(
                              Text(
                                Formatters.date(c.dataVencimento),
                                style: TextStyle(
                                  color: c.isVencida
                                      ? AppTheme.accentRed
                                      : null,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                Formatters.currency(c.valorOriginal),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataCell(StatusChip.fromStatus(c.status)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ContasReceberTab extends ConsumerWidget {
  final ScrollController controller;
  const ContasReceberTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contasAsync = ref.watch(accountsReceivableProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      clipBehavior: Clip.antiAlias,
      child: contasAsync.when(
        loading: () => const LoadingOverlay(message: 'Carregando...'),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Erro',
          subtitle: '$e',
        ),
        data: (paginated) {
          final contas = paginated.data;
          if (contas.isEmpty) {
            return const EmptyState(
              icon: Icons.check_circle_outline,
              title: 'Sem contas no período',
            );
          }
          return Column(
            children: [
              Expanded(
                child: Scrollbar(
                  controller: controller,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('DESCRIÇÃO')),
                        DataColumn(label: Text('CLIENTE')),
                        DataColumn(label: Text('VENCIMENTO')),
                        DataColumn(label: Text('VALOR'), numeric: true),
                        DataColumn(label: Text('STATUS')),
                      ],
                      rows: contas.map((c) {
                        final role = ref.watch(authProvider).role;
                        final bool canManage =
                            role == 'admin' ||
                            role == 'gerente';

                        return DataRow(
                          cells: [
                            DataCell(Text(c.descricao)),
                            DataCell(
                              Text(
                                c.clienteNome ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                Formatters.date(c.dataVencimento),
                                style: TextStyle(
                                  color: c.isVencida
                                      ? AppTheme.accentRed
                                      : null,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                Formatters.currency(c.valorOriginal),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataCell(StatusChip.fromStatus(c.status)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FluxoCaixaTab extends ConsumerWidget {
  final ScrollController controller;
  const FluxoCaixaTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fluxoAsync = ref.watch(cashFlowProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      clipBehavior: Clip.antiAlias,
      child: fluxoAsync.when(
        loading: () => const LoadingOverlay(message: 'Gerando extrato...'),
        error: (e, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Erro',
          subtitle: '$e',
        ),
        data: (paginated) {
          if (paginated.data.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long,
              title: 'Sem movimentações',
            );
          }
          final items = paginated.data.first.items;
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long,
              title: 'Sem movimentações',
            );
          }
          return Column(
            children: [
              Expanded(
                child: Scrollbar(
                  controller: controller,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('DATA')),
                        DataColumn(label: Text('TIPO')),
                        DataColumn(label: Text('CATEGORIA')),
                        DataColumn(label: Text('DESCRIÇÃO')),
                        DataColumn(label: Text('VALOR'), numeric: true),
                      ],
                      rows: items.map((item) {
                        final isEntrada = item.valor >= 0;
                        return DataRow(
                          cells: [
                            DataCell(Text(Formatters.date(item.data))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (isEntrada ? AppTheme.accentGreen : AppTheme.accentRed).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: (isEntrada ? AppTheme.accentGreen : AppTheme.accentRed).withOpacity(0.5),
                                  ),
                                ),
                                child: Text(
                                  item.tipo.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isEntrada ? Colors.greenAccent : Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(item.categoria.toUpperCase())),
                            DataCell(Text(item.descricao)),
                            DataCell(
                              Text(
                                '${isEntrada ? "+" : "-"} ${Formatters.currency(item.valor.abs())}',
                                style: TextStyle(
                                  color: isEntrada
                                      ? AppTheme.accentGreen
                                      : AppTheme.accentRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
