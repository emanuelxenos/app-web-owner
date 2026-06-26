import 'package:flutter/material.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';
import 'package:unifytechxenoswebowner/core/services/label_service.dart';

class BulkPrintLabelsDialog extends StatefulWidget {
  final List<Produto> products;

  const BulkPrintLabelsDialog({super.key, required this.products});

  @override
  State<BulkPrintLabelsDialog> createState() => _BulkPrintLabelsDialogState();
}

class _BulkPrintLabelsDialogState extends State<BulkPrintLabelsDialog> {
  final Map<int, TextEditingController> _controllers = {};
  bool _isPrinting = false;

  @override
  void initState() {
    super.initState();
    for (final p in widget.products) {
      _controllers[p.idProduto] = TextEditingController(text: '1');
    }
  }

  @override
  void dispose() {
    for (final ctrl in _controllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  Future<void> _handlePrint() async {
    setState(() => _isPrinting = true);
    try {
      final List<MapEntry<Produto, int>> selection = [];
      for (final p in widget.products) {
        final qty = int.tryParse(_controllers[p.idProduto]!.text) ?? 0;
        if (qty > 0) {
          selection.add(MapEntry(p, qty));
        }
      }

      if (selection.isEmpty) return;

      await LabelService.printMultipleProductLabels(productQuantities: selection);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao imprimir: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.glassCard(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.print_outlined, color: AppTheme.accentBlue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Imprimir Etiquetas em Massa (${widget.products.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Ajuste a quantidade para cada produto selecionado:',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.products.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white10),
                itemBuilder: (context, index) {
                  final p = widget.products[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.nome,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                p.codigoBarras ?? '#${p.idProduto}',
                                style: const TextStyle(color: Colors.white38, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _controllers[p.idProduto],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              isDense: true,
                              hintText: 'Qtd',
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isPrinting ? null : _handlePrint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: _isPrinting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text('GERAR TODAS AS ETIQUETAS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
