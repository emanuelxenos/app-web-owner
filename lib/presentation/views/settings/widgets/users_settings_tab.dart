import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/models/user.dart';
import '../../../providers/user_management_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/shared_widgets.dart';
import 'user_management_dialogs.dart';

class UsersSettingsTab extends ConsumerWidget {
  final ScrollController controller;
  const UsersSettingsTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Usuários do Sistema', style: theme.textTheme.titleLarge),
              ElevatedButton.icon(
                onPressed: () => showUserDialog(context, ref),
                icon: const Icon(Icons.person_add_rounded, size: 18),
                label: const Text('Novo Usuário'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ref.watch(userManagementProvider).when(
              data: (users) {
                if (users.isEmpty) {
                  return const EmptyState(icon: Icons.people_outline, title: 'Nenhum usuário');
                }
                return Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Scrollbar(
                      controller: controller,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('NOME')),
                            DataColumn(label: Text('LOGIN')),
                            DataColumn(label: Text('PERFIL')),
                            DataColumn(label: Text('STATUS')),
                            DataColumn(label: Text('AÇÕES')),
                          ],
                          rows: users.map((u) => DataRow(cells: [
                            DataCell(
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                    child: Text(
                                      u.nome.isNotEmpty ? u.nome[0].toUpperCase() : '?',
                                      style: const TextStyle(fontSize: 12, color: AppTheme.primaryColor),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(u.nome),
                                ],
                              ),
                            ),
                            DataCell(Text(u.login)),
                            DataCell(StatusChip(label: u.perfil.toUpperCase(), color: AppTheme.primaryColor)),
                            DataCell(StatusChip.fromStatus(u.ativo ? 'ativo' : 'inativo')),
                            DataCell(Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20, color: AppTheme.primaryColor),
                                  onPressed: () => showUserDialog(context, ref, usuario: u),
                                  tooltip: 'Editar Usuário',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppTheme.accentRed),
                                  onPressed: () => confirmInactivateUser(context, ref, u),
                                  tooltip: 'Inativar Usuário',
                                ),
                              ],
                            )),
                          ])).toList(),
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => const LoadingOverlay(message: 'Carregando usuários...'),
              error: (err, stack) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: err.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
