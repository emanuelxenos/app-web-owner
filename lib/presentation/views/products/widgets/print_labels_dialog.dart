import 'package:flutter/material.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';
import 'package:unifytechxenoswebowner/core/services/label_service.dart';

class PrintLabelsDialog extends StatefulWidget {
  final Produto product;

  const PrintLabelsDialog({super.key, required this.product});

  @override
  State<PrintLabelsDialog> createState() => _PrintLabelsDialogState();
}

class _PrintLabelsDialogState extends State<PrintLabelsDialog> {
  final _qtyCtrl = TextEditingController(text: '1');
  bool _isPrinting = false;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _handlePrint() async {
    final qty = int.tryParse(_qtyCtrl.text) ?? 1;
    if (qty <= 0) return;

    setState(() => _isPrinting = true);
    try {
      await LabelService.printProductLabels(
        product: widget.product,
        quantity: qty,
      );
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
        width: 350,
        padding: const EdgeInsets.all(24),
        decoration: AppTheme.glassCard(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.print, color: AppTheme.accentBlue),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Imprimir Etiquetas',
                    style: TextStyle(
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
            const SizedBox(height: 24),
            Text(
              widget.product.nome,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quantidade de etiquetas:',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _qtyCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Ex: 10',
                suffixText: 'unidades',
                suffixStyle: TextStyle(color: Colors.white38),
                prefixIcon: Icon(Icons.numbers_rounded, color: Colors.white54),
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
                    : const Text('GERAR E IMPRIMIR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
