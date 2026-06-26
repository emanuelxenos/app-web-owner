import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/caixa_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/presentation/views/sales/widgets/sales_shared_widgets.dart';

class CaixaMovementsView extends ConsumerStatefulWidget {
  const CaixaMovementsView({super.key});
  @override
  ConsumerState<CaixaMovementsView> createState() => _CaixaMovementsViewState();
}

class _CaixaMovementsViewState extends ConsumerState<CaixaMovementsView> {
  DateTime _inicio = DateTime.now();
  DateTime _fim = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final movsAsync = ref.watch(caixaMovementsProvider(
      inicio: _inicio.toString().split(' ')[0],
      fim: _fim.toString().split(' ')[0],
    ));

    return Column(
      children: [
        buildViewHeader(
          title: 'Sangrias & Suprimentos',
          icon: Icons.account_balance_wallet_rounded,
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
              onPressed: () => ref.read(caixaMovementsProvider(
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
            child: movsAsync.when(
              loading: () => const LoadingOverlay(message: 'Buscando movimentações...'),
              error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
              data: (movs) {
                if (movs.isEmpty) {
                  return const EmptyState(icon: Icons.swap_vert_rounded, title: 'Nenhuma sangria ou suprimento');
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: movs.length,
                  itemBuilder: (context, index) {
                    final m = movs[index];
                    final isSangria = m.tipo == 'sangria';
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          isSangria ? Icons.remove_circle_outline : Icons.add_circle_outline,
                          color: isSangria ? Colors.red : Colors.green,
                        ),
                        title: Text(Formatters.currency(m.valor), style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${m.tipo.toUpperCase()} - ${m.motivo ?? "Sem motivo"}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(Formatters.dateTime(m.dataMovimentacao), style: const TextStyle(fontSize: 12)),
                            Text(m.usuarioNome ?? "Desconhecido", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
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
}
