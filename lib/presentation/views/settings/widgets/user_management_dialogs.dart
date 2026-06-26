import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/models/user.dart';
import '../../../providers/user_management_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/shared_widgets.dart';

void confirmInactivateUser(BuildContext context, WidgetRef ref, Usuario usuario) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppTheme.accentRed),
          const SizedBox(width: 8),
          const Text('Confirmar Inativação'),
        ],
      ),
      content: Text('Deseja realmente inativar o usuário "${usuario.nome}"?\nEle não poderá mais acessar o sistema.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton.icon(
          onPressed: () async {
            try {
              await ref.read(userManagementProvider.notifier).inativarUsuario(usuario.idUsuario);
              if (context.mounted) Navigator.pop(context);
            } catch (e) {
              if (context.mounted) {
                AppNotifications.showError(context, 'Erro: $e');
              }
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentRed),
          icon: const Icon(Icons.person_off_rounded, size: 18),
          label: const Text('Inativar'),
        ),
      ],
    ),
  );
}

void showUserDialog(BuildContext context, WidgetRef ref, {Usuario? usuario}) {
  showDialog(
    context: context,
    builder: (context) => _UserDialog(usuario: usuario),
  );
}

class _UserDialog extends ConsumerStatefulWidget {
  final Usuario? usuario;

  const _UserDialog({this.usuario});

  @override
  ConsumerState<_UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends ConsumerState<_UserDialog> {
  late TextEditingController _nomeCtrl;
  late TextEditingController _loginCtrl;
  late TextEditingController _senhaCtrl;
  String _perfil = 'caixa';
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nomeCtrl = TextEditingController(text: widget.usuario?.nome);
    _loginCtrl = TextEditingController(text: widget.usuario?.login);
    _senhaCtrl = TextEditingController();
    _perfil = widget.usuario?.perfil ?? 'caixa';
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _loginCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  bool get isEditing => widget.usuario != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.cardColor,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Icon(
            isEditing ? Icons.manage_accounts_rounded : Icons.person_add_rounded,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 8),
          Text(isEditing ? 'Editar Usuário' : 'Novo Usuário'),
        ],
      ),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nomeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nome Completo *',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _loginCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nome de Usuário (Login) *',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _senhaCtrl,
                  decoration: InputDecoration(
                    labelText: isEditing ? 'Nova Senha (deixe em branco para manter)' : 'Senha *',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (v) {
                    if (!isEditing && (v == null || v.length < 4)) return 'Mínimo 4 caracteres';
                    if (isEditing && v != null && v.isNotEmpty && v.length < 4) return 'Mínimo 4 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: _perfil,
                  decoration: const InputDecoration(
                    labelText: 'Perfil de Acesso',
                    prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                  ),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'caixa', 
                      child: Text('Caixa'),
                    ),
                    DropdownMenuItem(
                      value: 'supervisor', 
                      child: Text('Supervisor'),
                    ),
                    DropdownMenuItem(
                      value: 'gerente', 
                      child: Text('Gerente'),
                    ),
                    DropdownMenuItem(
                      value: 'admin', 
                      child: Text('Administrador'),
                    ),
                  ],
                  onChanged: (v) => setState(() => _perfil = v!),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton.icon(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            try {
              final req = CriarUsuarioRequest(
                nome: _nomeCtrl.text.trim(),
                login: _loginCtrl.text.trim(),
                senha: _senhaCtrl.text,
                perfil: _perfil,
              );
              
              if (isEditing) {
                await ref.read(userManagementProvider.notifier).atualizarUsuario(widget.usuario!.idUsuario, req);
              } else {
                await ref.read(userManagementProvider.notifier).criarUsuario(req);
              }
              
              if (context.mounted) {
                AppNotifications.showSuccess(context, 'Usuário ${isEditing ? 'atualizado' : 'criado'} com sucesso!');
                Navigator.pop(context);
              }
            } catch (e) {
              if (context.mounted) {
                AppNotifications.showError(context, 'Erro: $e');
              }
            }
          },
          icon: Icon(isEditing ? Icons.save_rounded : Icons.check_circle_outline_rounded, size: 18),
          label: Text(isEditing ? 'Salvar' : 'Criar Usuário'),
        ),
      ],
    );
  }
}
