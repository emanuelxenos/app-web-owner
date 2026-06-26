import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/purchase_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';

class PurchaseDetailDialog extends ConsumerWidget {
  final int compraId;
  const PurchaseDetailDialog({super.key, required this.compraId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final detailAsync = ref.watch(purchaseDetailProvider(compraId));

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Detalhes da Compra'),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      content: SizedBox(
        width: 800,
        height: 500,
        child: detailAsync.when(
          loading: () => const LoadingOverlay(message: 'Carregando detalhes...'),
          error: (e, _) => Center(child: Text('Erro: $e')),
          data: (compra) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildInfoColumn('Nota Fiscal', compra.numeroNotaFiscal ?? '-'),
                    const VerticalDivider(width: 32),
                    _buildInfoColumn('Fornecedor', compra.fornecedorNome ?? 'Não informado'),
                    const VerticalDivider(width: 32),
                    _buildInfoColumn('Data Entrada', Formatters.date(compra.dataEntrada)),
                    const Spacer(),
                    StatusChip.fromStatus(compra.status),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Itens da Compra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              // Items Table
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowHeight: 40,
                      columns: const [
                        DataColumn(label: Text('Seq.')),
                        DataColumn(label: Text('Produto')),
                        DataColumn(label: Text('Qtd.'), numeric: true),
                        DataColumn(label: Text('Recebida'), numeric: true),
                        DataColumn(label: Text('Preço Un.'), numeric: true),
                        DataColumn(label: Text('Total'), numeric: true),
                      ],
                      rows: (compra.itens).map((item) => DataRow(
                        cells: [
                          DataCell(Text(item.sequencia.toString())),
                          DataCell(Text(item.produtoNome ?? 'Produto ${item.produtoId}')),
                          DataCell(Text(Formatters.quantity(item.quantidade))),
                          DataCell(
                            Text(
                              (item.quantidadeRecebida > 0 || compra.status == 'recebida') ? 'Recebida' : 'Pendente',
                              style: TextStyle(
                                color: (item.quantidadeRecebida > 0 || compra.status == 'recebida') ? AppTheme.accentGreen : AppTheme.accentOrange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          DataCell(Text(Formatters.currency(item.precoUnitario))),
                          DataCell(Text(
                            Formatters.currency(item.valorTotal),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ],
                      )).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Summary
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Valor Total dos Produtos: ${Formatters.currency(compra.valorProdutos)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'VALOR TOTAL: ${Formatters.currency(compra.valorTotal)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
