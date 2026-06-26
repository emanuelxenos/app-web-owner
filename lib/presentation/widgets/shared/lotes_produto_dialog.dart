import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/domain/models/stock_movement.dart';
import 'package:unifytechxenoswebowner/data/repositories/stock_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';

class LotesProdutoDialog extends ConsumerWidget {
  final Produto product;

  const LotesProdutoDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detalhamento de Lotes',
              style: TextStyle(fontSize: 14, color: Colors.grey[400])),
          Text(product.nome,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: SizedBox(
        width: 650,
        height: 400,
        child: FutureBuilder<List<EstoqueLote>>(
          future: ref
              .read(stockRepositoryProvider)
              .listarLotes(product.idProduto),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Center(
                  child:
                      Text('Nenhum lote ativo encontrado para este produto.'));
            }

            final lotes = snapshot.data!;
            return SingleChildScrollView(
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(0.8),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white10))),
                    children: [
                      _headerCell('Lote Interno'),
                      _headerCell('Vencimento'),
                      _headerCell('Localização'),
                      _headerCell('Qtd Atual'),
                      _headerCell('Status'),
                    ],
                  ),
                  ...lotes.map((l) {
                    final isVencido = l.dataVencimento != null &&
                        l.dataVencimento!.isBefore(DateTime.now());
                    return TableRow(
                      children: [
                        _dataCell(l.loteInterno, size: 12),
                        _dataCell(
                            l.dataVencimento != null
                                ? Formatters.date(l.dataVencimento!)
                                : 'S/V',
                            color: isVencido ? Colors.redAccent : null),
                        _dataCell(l.localizacaoNome ?? 'Não Informada'),
                        _dataCell(Formatters.quantity(l.quantidadeAtual),
                            bold: true),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: StatusChip.fromStatus(l.status),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar')),
      ],
    );
  }

  Widget _headerCell(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 12)),
  );

  Widget _dataCell(String text, {Color? color, bool bold = false, double size = 12}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      style: TextStyle(
        color: color ?? Colors.white54,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
      ),
    ),
  );
}
