import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/presentation/providers/finance_provider.dart';
import 'package:unifytechxenoswebowner/domain/models/account_payable.dart';
import 'package:unifytechxenoswebowner/domain/models/account_receivable.dart';

class ManualEntryDialog extends ConsumerStatefulWidget {
  final bool isPagar;
  const ManualEntryDialog({super.key, required this.isPagar});

  @override
  ConsumerState<ManualEntryDialog> createState() => _ManualEntryDialogState();
}

class _ManualEntryDialogState extends ConsumerState<ManualEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();
  final _dataCtrl = TextEditingController();
  final _catCtrl = TextEditingController(text: 'Administrativo');
  bool _saving = false;

  final List<String> _categorias = [
    'Fornecedor',
    'Impostos',
    'Folha de Pagamento',
    'Aluguel',
    'Água/Luz/Telefone',
    'Marketing',
    'Equipamentos',
    'Serviços',
    'Administrativo',
    'Venda',
    'Rendimento',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    _dataCtrl.text = DateTime.now().toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1C2039),
      title: Text(
        widget.isPagar ? 'Nova Despesa Manual' : 'Nova Entrada Manual',
        style: const TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descricaoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descrição (Ex: Aluguel, Luz, etc)',
                ),
                style: const TextStyle(color: Colors.white),
                validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _valorCtrl,
                      decoration: const InputDecoration(
                        labelText: r'Valor (R$)',
                        prefixText: r'R$ ',
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Autocomplete<String>(
                      initialValue: TextEditingValue(text: _catCtrl.text),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) return _categorias;
                        return _categorias.where(
                          (c) => c.toLowerCase().contains(textEditingValue.text.toLowerCase()),
                        );
                      },
                      onSelected: (v) => _catCtrl.text = v,
                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                        controller.addListener(() => _catCtrl.text = controller.text);
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Categoria (Livre)',
                          ),
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            color: const Color(0xFF1C2039),
                            elevation: 4,
                            child: SizedBox(
                              width: 180,
                              height: 200,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: options.map(
                                  (e) => ListTile(
                                    title: Text(e, style: const TextStyle(color: Colors.white)),
                                    onTap: () => onSelected(e),
                                  ),
                                ).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dataCtrl,
                decoration: const InputDecoration(
                  labelText: 'Data de Vencimento',
                  suffixIcon: Icon(Icons.calendar_today, size: 18),
                ),
                style: const TextStyle(color: Colors.white),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    _dataCtrl.text = date.toString().split(' ')[0];
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: _saving
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => _saving = true);
                    final valor = double.tryParse(_valorCtrl.text.replaceAll(',', '.')) ?? 0.0;

                    bool ok = false;
                    if (widget.isPagar) {
                      ok = await ref.read(accountsPayableProvider.notifier).criar(
                        CriarContaPagarRequest(
                          descricao: _descricaoCtrl.text,
                          valorOriginal: valor,
                          dataVencimento: _dataCtrl.text,
                          categoria: _catCtrl.text,
                        ),
                      );
                    } else {
                      ok = await ref.read(accountsReceivableProvider.notifier).criar(
                        CriarContaReceberRequest(
                          descricao: _descricaoCtrl.text,
                          valorOriginal: valor,
                          dataVencimento: _dataCtrl.text,
                          categoria: _catCtrl.text,
                        ),
                      );
                    }

                    if (mounted) {
                      setState(() => _saving = false);
                      if (ok) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao salvar conta manual')),
                        );
                      }
                    }
                  }
                },
          child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Salvar'),
        ),
      ],
    );
  }
}
