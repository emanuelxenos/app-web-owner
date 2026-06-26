import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unifytechxenoswebowner/data/repositories/report_repository.dart';

class SugestaoCompraDialog extends ConsumerWidget {
  const SugestaoCompraDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.shopping_cart_checkout_rounded, color: Colors.blueAccent),
          SizedBox(width: 12),
          Text('Sugestão de Compra'),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: 400,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: ref.read(reportRepositoryProvider).sugestaoCompra(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma sugestão no momento.'));
            }

            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  title: Text(item['nome'] ?? ''),
                  subtitle: Text('Estoque Atual: ${item['estoque_atual']} | Mín: ${item['estoque_minimo']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Sugerido', style: TextStyle(fontSize: 11, color: Colors.blueAccent)),
                      Text(
                        '${item['sugestao_quantidade']}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.go('/compras');
          },
          child: const Text('Ir para Compras'),
        ),
      ],
    );
  }
}
