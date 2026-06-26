import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/domain/models/customer.dart';
import 'package:unifytechxenoswebowner/presentation/providers/auth_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/customer_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';

class CustomerFormDialog extends ConsumerStatefulWidget {
  final Cliente? cliente;
  const CustomerFormDialog({super.key, this.cliente});

  @override
  ConsumerState<CustomerFormDialog> createState() =>
      _CustomerFormDialogState();
}

class _CustomerFormDialogState
    extends ConsumerState<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _cpfCnpjCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _limiteCreditoCtrl = TextEditingController();

  final _phoneFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {'#': RegExp(r'[0-9]')});
  final _cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {'#': RegExp(r'[0-9]')});
  final _cnpjFormatter = MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: {'#': RegExp(r'[0-9A-Za-z]')});

  String _tipoPessoa = 'F';
  bool _saving = false;

  MaskTextInputFormatter get _docFormatter =>
      _tipoPessoa == 'F' ? _cpfFormatter : _cnpjFormatter;

  @override
  void initState() {
    super.initState();
    final c = widget.cliente;
    if (c != null) {
      _nomeCtrl.text = c.nome;
      _tipoPessoa = c.tipoPessoa;
      _cpfCnpjCtrl.text = c.cpfCnpj ?? '';
      _telefoneCtrl.text = _phoneFormatter
          .maskText(c.telefone?.replaceAll(RegExp(r'[^0-9]'), '') ?? '');
      _emailCtrl.text = c.email ?? '';
      _limiteCreditoCtrl.text = c.limiteCredito.toStringAsFixed(2);
    } else {
      _limiteCreditoCtrl.text = '0.00';
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _cpfCnpjCtrl.dispose();
    _telefoneCtrl.dispose();
    _emailCtrl.dispose();
    _limiteCreditoCtrl.dispose();
    super.dispose();
  }

  bool get _canEditLimite {
    final authState = ref.watch(authProvider);
    final role = authState.role ?? '';
    return role == 'admin' || role == 'gerente';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cliente != null;
    return AlertDialog(
      backgroundColor: const Color(0xFF1C2039),
      title: Text(
        isEditing ? 'Editar Cliente' : 'Novo Cliente',
        style: const TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tipo de Pessoa',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(
                    child: _TipoButton(
                      label: 'Pessoa Física',
                      selected: _tipoPessoa == 'F',
                      onTap: () => setState(() {
                        _tipoPessoa = 'F';
                        _cpfCnpjCtrl.clear();
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TipoButton(
                      label: 'Pessoa Jurídica',
                      selected: _tipoPessoa == 'J',
                      onTap: () => setState(() {
                        _tipoPessoa = 'J';
                        _cpfCnpjCtrl.clear();
                      }),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nomeCtrl,
                  decoration: InputDecoration(
                    labelText: _tipoPessoa == 'J'
                        ? 'Razão Social *'
                        : 'Nome Completo *',
                    labelStyle:
                        const TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Obrigatório'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cpfCnpjCtrl,
                  decoration: InputDecoration(
                    labelText:
                        _tipoPessoa == 'F' ? 'CPF' : 'CNPJ',
                    hintText: _tipoPessoa == 'F'
                        ? '000.000.000-00'
                        : '00.000.000/0000-00',
                    labelStyle:
                        const TextStyle(color: Colors.white70),
                    hintStyle:
                        const TextStyle(color: Colors.white38),
                  ),
                  style: const TextStyle(color: Colors.white),
                  inputFormatters: [_docFormatter],
                  key: ValueKey(_tipoPessoa),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: TextFormField(
                      controller: _telefoneCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        hintText: '(00) 00000-0000',
                        labelStyle:
                            TextStyle(color: Colors.white70),
                        hintStyle:
                            TextStyle(color: Colors.white38),
                      ),
                      style: const TextStyle(color: Colors.white),
                      inputFormatters: [_phoneFormatter],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle:
                            TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _limiteCreditoCtrl,
                  enabled: _canEditLimite,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                          decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Limite de Crédito (R\$)',
                    labelStyle:
                        const TextStyle(color: Colors.white70),
                    helperText: _canEditLimite
                        ? null
                        : 'Apenas gerentes e admins podem alterar o limite',
                    helperStyle: const TextStyle(
                        color: Colors.white38, fontSize: 11),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Obrigatório';
                    if (double.tryParse(
                            v.replaceAll(',', '.')) ==
                        null) {
                      return 'Valor inválido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar',
              style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child:
                      CircularProgressIndicator(strokeWidth: 2))
              : Text(isEditing ? 'Salvar' : 'Cadastrar'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final limite =
        double.tryParse(_limiteCreditoCtrl.text.trim().replaceAll(',', '.')) ??
            0.0;
    final cpfCnpjRaw =
        _cpfCnpjCtrl.text.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
    final telefoneRaw =
        _telefoneCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');

    final req = CriarClienteRequest(
      nome: _nomeCtrl.text.trim(),
      tipoPessoa: _tipoPessoa,
      cpfCnpj: cpfCnpjRaw.isEmpty ? null : cpfCnpjRaw,
      telefone: telefoneRaw.isEmpty ? null : telefoneRaw,
      email: _emailCtrl.text.trim().isEmpty
          ? null
          : _emailCtrl.text.trim(),
      limiteCredito: limite,
    );

    final bool success;
    final String message;

    if (widget.cliente != null) {
      final result = await ref
          .read(customersProvider.notifier)
          .atualizar(widget.cliente!.idCliente, req);
      success = result.$1;
      message = result.$2;
    } else {
      final result =
          await ref.read(customersProvider.notifier).criar(req);
      success = result.$1;
      message = result.$2;
    }

    if (mounted) {
      setState(() => _saving = false);
      Navigator.pop(context);
      if (success) {
        AppNotifications.showSuccess(context, message);
      } else {
        AppNotifications.showError(context, message);
      }
    }
  }
}

class _TipoButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TipoButton(
      {required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryColor.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? AppTheme.primaryColor
                : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: selected
                    ? AppTheme.primaryColor
                    : Colors.white70,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w400,
                fontSize: 13)),
      ),
    );
  }
}
