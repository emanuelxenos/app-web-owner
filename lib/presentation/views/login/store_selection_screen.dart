import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unifytechxenoswebowner/data/local/local_config.dart';
import 'package:unifytechxenoswebowner/presentation/providers/auth_provider.dart';

class StoreSelectionScreen extends ConsumerWidget {
  const StoreSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final stores = authState.stores;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade900,
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFF1E1E2C),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.storefront,
                      size: 64,
                      color: Colors.purpleAccent,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Selecione uma Loja',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bem-vindo! Qual loja você deseja gerenciar agora?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    if (authState.role == 'super_admin') ...[
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => context.go('/super-admin'),
                          icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
                          label: const Text(
                            'Acessar Painel UnifyTech (Super Admin)',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 24),
                    ],
                    if (stores.isEmpty)
                      const Text(
                        'Nenhuma loja vinculada à sua conta.',
                        style: TextStyle(color: Colors.redAccent),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: stores.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final store = stores[index];
                          return ListTile(
                            tileColor: Colors.deepPurple.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                color: Colors.deepPurple.withOpacity(0.3),
                              ),
                            ),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.purpleAccent,
                              child: Icon(Icons.business, color: Colors.white),
                            ),
                            title: Text(
                              store.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'CNPJ: ${store.cnpj}',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                            onTap: () async {
                              // Save the selected CNPJ in local config
                              await ref
                                  .read(localConfigProvider)
                                  .setSelectedStoreCnpj(store.cnpj);

                              if (context.mounted) {
                                // Navigate to the dashboard
                                context.go('/');
                              }
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
