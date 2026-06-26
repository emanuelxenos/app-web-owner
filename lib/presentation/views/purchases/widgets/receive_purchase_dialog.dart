import 'package:flutter/material.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/domain/models/purchase.dart';

class ReceivePurchaseDialog extends StatefulWidget {
  final Compra compra;

  const ReceivePurchaseDialog({super.key, required this.compra});

  @override
  State<ReceivePurchaseDialog> createState() => _ReceivePurchaseDialogState();
}

class _ReceivePurchaseDialogState extends State<ReceivePurchaseDialog> {
  late List<Map<String, dynamic>> _items;
  late TextEditingController _nfController;

  @override
  void initState() {
    super.initState();
    _nfController = TextEditingController(text: widget.compra.numeroNotaFiscal ?? '');
    _items = widget.compra.itens.map((item) => {
      'produto_id': item.produtoId,
      'produto_nome': item.produtoNome,
      'quantidade': item.quantidadeRecebida > 0 ? item.quantidadeRecebida : item.quantidade,
      'lote_controller': TextEditingController(text: item.lote ?? ''),
      'vencimento': item.dataVencimento, // Já é DateTime? no modelo novo
    }).toList();
  }

  @override
  void dispose() {
    _nfController.dispose();
    for (var item in _items) {
      (item['lote_controller'] as TextEditingController).dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Conferência de Recebimento'),
      content: SizedBox(
        width: 850, 
        height: 550, // Aumentado para o campo de NF
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nfController,
                    decoration: const InputDecoration(
                      labelText: 'Número da Nota Fiscal (NF)',
                      prefixIcon: Icon(Icons.description_outlined),
                      hintText: 'Ajuste a NF se necessário...',
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    'Fornecedor: ${widget.compra.fornecedorNome ?? 'Geral'}',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.fact_check_rounded, color: AppTheme.primaryColor, size: 20),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Confirme o lote e validade que constam na embalagem física.\nLotes vazios usarão o número da NF como padrão.',
                      style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Text('Produto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  SizedBox(width: 10),
                  Expanded(flex: 1, child: Text('Qtd', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  SizedBox(width: 10),
                  Expanded(flex: 2, child: Text('Lote Fabricante', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  SizedBox(width: 10),
                  Expanded(flex: 2, child: Text('Vencimento', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.white10),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: [
                        // Nome
                        Expanded(
                          flex: 3,
                          child: Text(
                            item['produto_nome'] ?? 'Produto ${item['produto_id']}',
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Quantidade
                        Expanded(
                          flex: 1,
                          child: Text(
                            Formatters.quantity(item['quantidade']),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Lote
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: item['lote_controller'] as TextEditingController,
                            decoration: const InputDecoration(
                              hintText: 'Lote...',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            ),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Vencimento
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: item['vencimento'] ?? DateTime.now().add(const Duration(days: 365)),
                                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                lastDate: DateTime.now().add(const Duration(days: 3650)),
                              );
                              if (date != null) {
                                setState(() => item['vencimento'] = date);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['vencimento'] != null 
                                      ? Formatters.date(item['vencimento']) 
                                      : 'Selecionar',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: item['vencimento'] == null ? Colors.orangeAccent : Colors.white,
                                    ),
                                  ),
                                  const Icon(Icons.calendar_today, size: 14, color: Colors.white54),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final requests = _items.map<ItemRecebidoRequest>((item) => ItemRecebidoRequest(
              produtoId: item['produto_id'],
              quantidadeRecebida: item['quantidade'],
              loteFabricante: (item['lote_controller'] as TextEditingController).text.trim().isEmpty 
                ? null 
                : (item['lote_controller'] as TextEditingController).text.trim(),
              dataVencimento: item['vencimento'] != null 
                ? (item['vencimento'] as DateTime).toIso8601String()
                : null,
            )).toList();
            
            Navigator.pop(context, ReceberCompraRequest(
              numeroNotaFiscal: _nfController.text.trim().isEmpty ? null : _nfController.text.trim(),
              itensRecebidos: requests,
            ));
          },
          child: const Text('Confirmar e Entrar no Estoque'),
        ),
      ],
    );
  }
}
