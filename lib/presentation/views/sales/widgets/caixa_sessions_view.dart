import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/domain/models/caixa.dart';
import 'package:unifytechxenoswebowner/presentation/providers/caixa_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/presentation/views/sales/widgets/sales_shared_widgets.dart';

class CaixaSessionsView extends ConsumerStatefulWidget {
  const CaixaSessionsView({super.key});
  @override
  ConsumerState<CaixaSessionsView> createState() => _CaixaSessionsViewState();
}

class _CaixaSessionsViewState extends ConsumerState<CaixaSessionsView> {
  DateTime _inicio = DateTime.now().subtract(const Duration(days: 7));
  DateTime _fim = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(caixaSessionsProvider(
      inicio: _inicio.toString().split(' ')[0],
      fim: _fim.toString().split(' ')[0],
    ));

    return Column(
      children: [
        buildViewHeader(
          title: 'Histórico de Sessões',
          icon: Icons.point_of_sale_rounded,
          actions: [
            DateRangeButton(
              inicio: _inicio,
              fim: _fim,
              onChanged: (start, end) => setState(() {
                _inicio = start;
                _fim = end;
              }),
            ),
            const SizedBox(width: 12),
            IconButton.outlined(
              onPressed: () => ref.read(caixaSessionsProvider(
                inicio: _inicio.toString().split(' ')[0],
                fim: _fim.toString().split(' ')[0],
              ).notifier).refresh(),
              icon: const Icon(Icons.refresh, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: AppTheme.glassCard(),
            clipBehavior: Clip.antiAlias,
            child: sessionsAsync.when(
              loading: () => const LoadingOverlay(message: 'Buscando sessões...'),
              error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
              data: (sessoes) {
                if (sessoes.isEmpty) {
                  return const EmptyState(icon: Icons.history_rounded, title: 'Nenhuma sessão aberta/fechada no período');
                }
                
                final totalVendas = sessoes.fold(0.0, (s, e) => s + e.totalVendas);
                final totalDiferenca = sessoes.fold(0.0, (s, e) => s + e.diferenca);
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          MiniKpi(title: 'Qtd Sessões', value: '${sessoes.length}', color: AppTheme.primaryColor),
                          MiniKpi(title: 'Vendas (Sessões)', value: Formatters.currency(totalVendas), color: AppTheme.accentGreen),
                          MiniKpi(title: 'Diferenças Acumuladas', value: Formatters.currency(totalDiferenca), color: totalDiferenca < 0 ? AppTheme.accentRed : Colors.blueGrey),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: sessoes.length,
                        separatorBuilder: (_, __) => const Divider(height: 32),
                        itemBuilder: (context, index) {
                          final s = sessoes[index];
                          return InkWell(
                            onTap: () => _showSessionInfo(context, s),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: (s.status == 'fechado' ? Colors.blueGrey : Colors.green).withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      s.status == 'fechado' ? Icons.lock_outline : Icons.lock_open_rounded,
                                      color: s.status == 'fechado' ? Colors.blueGrey : Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sessão #${s.codigoSessao}',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Text(
                                          'Abertura: ${Formatters.dateTime(s.dataAbertura)}\nOperador: ${s.usuarioNome ?? "Desconhecido"}',
                                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        Formatters.currency(s.totalVendas),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      if (s.status == 'fechado') ...[
                                        const StatusChip(label: 'FECHADO', color: Colors.blueGrey),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Final: ${Formatters.currency(s.saldoFinal)}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[400],
                                            fontStyle: FontStyle.italic,
                                          ),
                                        )
                                      ] else
                                        const StatusChip(label: 'ABERTO', color: AppTheme.accentGreen),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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

  void _showSessionInfo(BuildContext context, SessaoCaixa s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sessão ${s.codigoSessao}'),
            StatusChip.fromStatus(s.status),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            infoRow('Saldo Inicial', Formatters.currency(s.saldoInicial)),
            infoRow('Total Vendas', Formatters.currency(s.totalVendas)),
            infoRow('Total Sangrias', Formatters.currency(s.totalSangrias)),
            infoRow('Total Suprimentos', Formatters.currency(s.totalSuprimentos)),
            const Divider(),
            infoRow('Saldo Esperado', Formatters.currency(s.saldoFinalEsperado)),
            infoRow('Saldo Informado', Formatters.currency(s.saldoFinal)),
            infoRow('Diferença', Formatters.currency(s.diferenca)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
        ],
      ),
    );
  }
}
