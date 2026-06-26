import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/domain/models/customer.dart';
import 'package:unifytechxenoswebowner/domain/models/sale.dart';
import 'package:unifytechxenoswebowner/presentation/providers/customer_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';

class PagarVendaDialog extends ConsumerStatefulWidget {
  final Cliente cliente;
  final Venda venda;
  const PagarVendaDialog({
    super.key,
    required this.cliente,
    required this.venda,
  });

  @override
  ConsumerState<PagarVendaDialog> createState() =>
      _PagarVendaDialogState();
}

class _PagarVendaDialogState extends ConsumerState<PagarVendaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _valorCtrl = TextEditingController();
  bool _saving = false;
  late double saldoDevedor;

  @override
  void initState() {
    super.initState();
    saldoDevedor = widget.venda.valorTotal - widget.venda.valorPago;
    _valorCtrl.text = saldoDevedor.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _valorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1C2039),
      title: const Text('Pagar Venda',
          style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 320,
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Venda: ${widget.venda.numeroVenda}',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text(
              'Saldo a Pagar: R\$ ${saldoDevedor.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: AppTheme.accentRed,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valorCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor a Pagar (R\$)',
                labelStyle: TextStyle(color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Obrigatório';
                final valor =
                    double.tryParse(v.replaceAll(',', '.'));
                if (valor == null || valor <= 0)
                  return 'Valor inválido';
                if (valor > saldoDevedor)
                  return 'Não pode ser maior que o saldo da venda';
                return null;
              },
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.white70))),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green),
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child:
                      CircularProgressIndicator(strokeWidth: 2))
              : const Text('Confirmar Pagamento'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final valor =
        double.tryParse(_valorCtrl.text.trim().replaceAll(',', '.')) ??
            0.0;
    final (success, message) = await ref
        .read(customersProvider.notifier)
        .amortizarDivida(
            widget.cliente.idCliente, widget.venda.idVenda, valor);
    if (mounted) {
      setState(() => _saving = false);
      Navigator.pop(context, success);
      if (success) {
        AppNotifications.showSuccess(context, message);
        ref.invalidate(
            customerHistoryProvider(widget.cliente.idCliente));
        ref.invalidate(
            customerAmortizationsProvider(widget.cliente.idCliente));
      } else {
        AppNotifications.showError(context, message);
      }
    }
  }
}
