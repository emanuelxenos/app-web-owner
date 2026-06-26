import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/presentation/providers/customer_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';

class BulkLimitAdjustmentDialog extends StatefulWidget {
  final List<int> ids;
  final VoidCallback onSuccess;
  const BulkLimitAdjustmentDialog({
    super.key,
    required this.ids,
    required this.onSuccess,
  });

  @override
  State<BulkLimitAdjustmentDialog> createState() =>
      _BulkLimitAdjustmentDialogState();
}

class _BulkLimitAdjustmentDialogState
    extends State<BulkLimitAdjustmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _porcentagemCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();
  bool _saving = false;
  String _tipoReajuste = 'porcentagem';

  @override
  void dispose() {
    _porcentagemCtrl.dispose();
    _valorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return AlertDialog(
        backgroundColor: const Color(0xFF1C2039),
        title: Text('Ajustar Limites (${widget.ids.length} selecionados)',
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        content: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selecione a forma de reajuste:',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 12),
                RadioListTile<String>(
                  title: const Text('Percentual (%)',
                      style: TextStyle(
                          color: Colors.white, fontSize: 14)),
                  subtitle: const Text(
                      'Ex: 10 para aumentar 10%, -5 para diminuir 5%',
                      style: TextStyle(
                          color: Colors.white54, fontSize: 11)),
                  value: 'porcentagem',
                  groupValue: _tipoReajuste,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _tipoReajuste = val;
                        _valorCtrl.clear();
                      });
                    }
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Valor em Reais (R\$)',
                      style: TextStyle(
                          color: Colors.white, fontSize: 14)),
                  subtitle: const Text(
                      'Ex: 100 para aumentar R\$ 100, -50 para diminuir',
                      style: TextStyle(
                          color: Colors.white54, fontSize: 11)),
                  value: 'valor',
                  groupValue: _tipoReajuste,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _tipoReajuste = val;
                        _porcentagemCtrl.clear();
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                if (_tipoReajuste == 'porcentagem')
                  TextFormField(
                    controller: _porcentagemCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                    decoration: const InputDecoration(
                      labelText: 'Ajuste Percentual (%)',
                      labelStyle:
                          TextStyle(color: Colors.white70),
                      hintText: 'Ex: 10 ou -5',
                      hintStyle:
                          TextStyle(color: Colors.white38),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Obrigatório';
                      if (double.tryParse(
                              v.replaceAll(',', '.')) ==
                          null) return 'Valor inválido';
                      return null;
                    },
                  ),
                if (_tipoReajuste == 'valor')
                  TextFormField(
                    controller: _valorCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                    decoration: const InputDecoration(
                      labelText: 'Ajuste de Valor (R\$)',
                      labelStyle:
                          TextStyle(color: Colors.white70),
                      hintText: 'Ex: 150 ou -50',
                      hintStyle:
                          TextStyle(color: Colors.white38),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Obrigatório';
                      if (double.tryParse(
                              v.replaceAll(',', '.')) ==
                          null) return 'Valor inválido';
                      return null;
                    },
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed:
                  _saving ? null : () => Navigator.pop(context),
              child: const Text('Cancelar',
                  style: TextStyle(color: Colors.white70))),
          ElevatedButton(
            onPressed: _saving ? null : () => _submit(ref),
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2))
                : const Text('Aplicar Reajuste'),
          ),
        ],
      );
    });
  }

  Future<void> _submit(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final String valStr = _tipoReajuste == 'porcentagem'
        ? _porcentagemCtrl.text
        : _valorCtrl.text;
    final double valor =
        double.tryParse(valStr.trim().replaceAll(',', '.')) ?? 0.0;
    final (success, message) = await ref
        .read(customersProvider.notifier)
        .ajustarLimitesEmLote(widget.ids, _tipoReajuste, valor);
    if (mounted) {
      setState(() => _saving = false);
      if (success) {
        AppNotifications.showSuccess(context, message);
        Navigator.pop(context);
        widget.onSuccess();
      } else {
        AppNotifications.showError(context, message);
      }
    }
  }
}
