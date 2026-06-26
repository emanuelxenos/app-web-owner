import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/presentation/providers/stock_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/category_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/domain/models/stock_movement.dart';

class NovoInventarioDialog extends ConsumerStatefulWidget {
  const NovoInventarioDialog({super.key});

  @override
  ConsumerState<NovoInventarioDialog> createState() => _NovoInventarioDialogState();
}

class _NovoInventarioDialogState extends ConsumerState<NovoInventarioDialog> {
  final codigoCtrl = TextEditingController(text: 'INV-${DateTime.now().millisecondsSinceEpoch ~/ 10000}');
  final descCtrl = TextEditingController();
  int? selectedCategoria;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    codigoCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return AlertDialog(
      title: const Text('Novo Inventário'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: codigoCtrl,
                decoration: const InputDecoration(labelText: 'Código / Identificação *'),
                validator: (v) => (v == null || v.isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Descrição (Opcional)'),
              ),
              const SizedBox(height: 12),
              categoriesAsync.response.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Erro ao carregar categorias'),
                data: (paginated) {
                  final cats = paginated.data;
                  return DropdownButtonFormField<int?>(
                    value: selectedCategoria,
                    decoration: const InputDecoration(labelText: 'Filtrar por Categoria (Opcional)'),
                    hint: const Text('Todas as Categorias'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todas as Categorias')),
                      ...cats.map((c) => DropdownMenuItem(value: c.idCategoria, child: Text(c.nome))),
                    ],
                    onChanged: (v) => setState(() => selectedCategoria = v),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            final (success, msg) = await ref.read(stockActionsProvider.notifier).criarInventario(
              CriarInventarioRequest(
                codigo: codigoCtrl.text,
                descricao: descCtrl.text,
                dataInicio: DateTime.now().toIso8601String(),
                categoriaId: selectedCategoria,
              ),
            );
            if (context.mounted) {
              Navigator.pop(context);
              if (success) {
                AppNotifications.showSuccess(context, msg);
              } else {
                AppNotifications.showError(context, msg);
              }
            }
          },
          child: const Text('Iniciar Contagem'),
        ),
      ],
    );
  }
}
