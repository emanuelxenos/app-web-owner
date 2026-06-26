import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/domain/models/account_payable.dart';
import 'package:unifytechxenoswebowner/domain/models/account_receivable.dart';
import 'package:unifytechxenoswebowner/presentation/providers/finance_provider.dart';

class PaymentDialog extends StatefulWidget {
  final ContaPagar conta;
  const PaymentDialog({super.key, required this.conta});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _valorController.text = widget.conta.valorOriginal.toStringAsFixed(2);
    _dataController.text = DateTime.now().toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1C2039),
      title: const Text(
        'Confirmar Pagamento',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Deseja registrar o pagamento de: ${widget.conta.descricao}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _valorController,
            decoration: const InputDecoration(
              labelText: r'Valor Pago (R$)',
              prefixText: r'R$ ',
            ),
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dataController,
            decoration: const InputDecoration(
              labelText: 'Data do Pagamento',
              suffixIcon: Icon(Icons.calendar_today),
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
                _dataController.text = date.toString().split(' ')[0];
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            return ElevatedButton(
              onPressed: () async {
                final valor =
                    double.tryParse(
                      _valorController.text.replaceAll(',', '.'),
                    ) ??
                    0;
                final ok = await ref
                    .read(accountsPayableProvider.notifier)
                    .pagar(
                      widget.conta.idContaPagar,
                      PagarContaRequest(
                        valorPago: valor,
                        dataPagamento: _dataController.text,
                      ),
                    );
                if (mounted && ok) {
                  ref.read(cashFlowProvider.notifier).refresh();
                  Navigator.pop(context);
                }
              },
              child: const Text('Confirmar'),
            );
          },
        ),
      ],
    );
  }
}

class ReceiptDialog extends StatefulWidget {
  final ContaReceber conta;
  const ReceiptDialog({super.key, required this.conta});

  @override
  State<ReceiptDialog> createState() => _ReceiptDialogState();
}

class _ReceiptDialogState extends State<ReceiptDialog> {
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _valorController.text = widget.conta.valorOriginal.toStringAsFixed(2);
    _dataController.text = DateTime.now().toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1C2039),
      title: const Text(
        'Confirmar Recebimento',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Deseja registrar o recebimento de: ${widget.conta.descricao}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _valorController,
            decoration: const InputDecoration(
              labelText: r'Valor Recebido (R$)',
              prefixText: r'R$ ',
            ),
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dataController,
            decoration: const InputDecoration(
              labelText: 'Data do Recebimento',
              suffixIcon: Icon(Icons.calendar_today),
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
                _dataController.text = date.toString().split(' ')[0];
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            return ElevatedButton(
              onPressed: () async {
                final valor =
                    double.tryParse(
                      _valorController.text.replaceAll(',', '.'),
                    ) ??
                    0;
                final ok = await ref
                    .read(accountsReceivableProvider.notifier)
                    .receber(
                      widget.conta.idContaReceber,
                      ReceberContaRequest(
                        valorRecebido: valor,
                        dataRecebimento: _dataController.text,
                      ),
                    );
                if (mounted && ok) {
                  ref.read(cashFlowProvider.notifier).refresh();
                  Navigator.pop(context);
                }
              },
              child: const Text('Confirmar'),
            );
          },
        ),
      ],
    );
  }
}
