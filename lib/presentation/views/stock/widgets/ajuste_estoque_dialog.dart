import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/stock_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/product_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/report_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/domain/models/stock_movement.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';

class AjusteEstoqueDialog extends ConsumerStatefulWidget {
  final Produto? initialProduct;

  const AjusteEstoqueDialog({super.key, this.initialProduct});

  @override
  ConsumerState<AjusteEstoqueDialog> createState() => _AjusteEstoqueDialogState();
}

class _AjusteEstoqueDialogState extends ConsumerState<AjusteEstoqueDialog> {
  late final TextEditingController produtoIdCtrl;
  final quantidadeCtrl = TextEditingController();
  final motivoCtrl = TextEditingController();
  final loteFabCtrl = TextEditingController();
  final dataVencCtrl = TextEditingController();
  DateTime? selectedVenc;
  String tipo = 'entrada';
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    produtoIdCtrl = TextEditingController(text: widget.initialProduct?.idProduto.toString() ?? '');
  }

  @override
  void dispose() {
    produtoIdCtrl.dispose();
    quantidadeCtrl.dispose();
    motivoCtrl.dispose();
    loteFabCtrl.dispose();
    dataVencCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialProduct = widget.initialProduct;
    
    return AlertDialog(
      title: Text(initialProduct != null ? 'Ajustar: ${initialProduct.nome}' : 'Ajustar Estoque'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (initialProduct != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Código: ${initialProduct.codigoBarras ?? initialProduct.idProduto}',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              TextFormField(
                controller: produtoIdCtrl,
                decoration: const InputDecoration(labelText: 'ID do Produto *'),
                keyboardType: TextInputType.number,
                enabled: initialProduct == null,
                validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: tipo,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: const [
                  DropdownMenuItem(value: 'entrada', child: Text('Entrada')),
                  DropdownMenuItem(value: 'saida', child: Text('Saída')),
                  DropdownMenuItem(value: 'ajuste', child: Text('Ajuste')),
                  DropdownMenuItem(value: 'perda', child: Text('Perda')),
                ],
                onChanged: (v) => setState(() => tipo = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: quantidadeCtrl,
                decoration: const InputDecoration(labelText: 'Quantidade *'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: motivoCtrl,
                decoration: const InputDecoration(labelText: 'Motivo *'),
                validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
              ),
              if (tipo == 'entrada') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: loteFabCtrl,
                  decoration: const InputDecoration(labelText: 'Lote do Fabricante (Opcional)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: dataVencCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Data de Vencimento *',
                    suffixIcon: Icon(Icons.calendar_today, size: 18),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 90)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      selectedVenc = picked;
                      dataVencCtrl.text = Formatters.date(picked);
                    }
                  },
                  validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório para entrada' : null,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            final (success, msg) = await ref.read(stockActionsProvider.notifier).ajustar(
              AjusteEstoqueRequest(
                produtoId: int.parse(produtoIdCtrl.text),
                quantidade: double.parse(quantidadeCtrl.text),
                tipo: tipo,
                motivo: motivoCtrl.text,
                loteFabricante: loteFabCtrl.text.isEmpty ? null : loteFabCtrl.text,
                dataVencimento: selectedVenc,
              ),
            );
            if (context.mounted) {
              Navigator.pop(context);
              ref.invalidate(inventoriesProvider);
              ref.invalidate(productsProvider);
              ref.invalidate(stockReportProvider);
              ref.invalidate(stockMovementsProvider);
              
              if (success) {
                AppNotifications.showSuccess(context, msg);
              } else {
                AppNotifications.showError(context, msg);
              }
            }
          },
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
