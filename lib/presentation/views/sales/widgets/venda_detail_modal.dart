import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/core/services/receipt_printer_service.dart';
import 'package:unifytechxenoswebowner/domain/models/sale.dart';
import 'package:unifytechxenoswebowner/presentation/providers/sale_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/presentation/views/sales/widgets/sales_shared_widgets.dart';

void showVendaDetail(BuildContext context, Venda vendaOriginal) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Consumer(
      builder: (context, ref, _) {
        final detailAsync = ref.watch(saleDetailProvider(vendaOriginal.idVenda));
        
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Detalhes da Venda', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: detailAsync.when(
                  loading: () => const LoadingOverlay(message: 'Carregando detalhes...'),
                  error: (err, _) => Center(child: Text('Erro ao carregar detalhes: $err')),
                  data: (vendaDetail) {
                    final venda = vendaDetail ?? vendaOriginal;
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ]
                      ),
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.storefront, size: 48, color: Colors.black87),
                            const SizedBox(height: 8),
                            const Text('UNIFY TECH XENOS', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Venda: ${venda.numeroVenda}', style: const TextStyle(color: Colors.black54)),
                            const SizedBox(height: 24),
                            receiptRow('Data', Formatters.dateTime(venda.dataVenda)),
                            receiptRow('Operador', venda.operadorNome ?? '-'),
                            receiptRow('Status', venda.status),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text('------------------------------------------------', style: TextStyle(color: Colors.black45), maxLines: 1),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('ITENS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 8),
                            ...venda.itens.map((item) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.produtoNome ?? 'Produto', style: const TextStyle(color: Colors.black87)),
                                            Text('${Formatters.quantity(item.quantidade)} ${item.unidadeVenda} x ${Formatters.currency(item.precoUnitario)}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                      Text(Formatters.currency(item.valorLiquido), style: const TextStyle(color: Colors.black87)),
                                    ],
                                  ),
                                )),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text('------------------------------------------------', style: TextStyle(color: Colors.black45), maxLines: 1),
                            ),
                            receiptRow('Subtotal', Formatters.currency(venda.valorTotalProdutos)),
                            if (venda.valorTotalDescontos > 0)
                              receiptRow('Descontos', Formatters.currency(venda.valorTotalDescontos)),
                            receiptRow('TOTAL', Formatters.currency(venda.valorTotal), isBold: true),
                            const SizedBox(height: 16),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('PAGAMENTOS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 8),
                            ...venda.pagamentos.map((p) => receiptRow(p.formaPagamentoNome ?? 'Pagamento', Formatters.currency(p.valor))),
                            if (venda.valorTroco > 0)
                              receiptRow('Troco', Formatters.currency(venda.valorTroco)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      final vendaToPrint = detailAsync.value ?? vendaOriginal;
                      ReceiptPrinterService.printReceipt(vendaToPrint);
                    },
                    icon: const Icon(Icons.print),
                    label: const Text('Imprimir'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
