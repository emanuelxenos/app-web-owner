import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/validators.dart';
import 'package:unifytechxenoswebowner/data/local/local_config.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

class ServerSettingsTab extends ConsumerStatefulWidget {
  const ServerSettingsTab({super.key});

  @override
  ConsumerState<ServerSettingsTab> createState() => _ServerSettingsTabState();
}

class _ServerSettingsTabState extends ConsumerState<ServerSettingsTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  final _hostCtrl = TextEditingController();
  final _portCtrl = TextEditingController();
  bool _isEditing = false;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    final config = ref.read(localConfigProvider);
    _hostCtrl.text = config.serverHost;
    _portCtrl.text = config.serverPort.toString();
  }

  @override
  void dispose() {
    _hostCtrl.dispose();
    _portCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    final messenger = ScaffoldMessenger.of(context);
    try {
      final config = ref.read(localConfigProvider);
      await config.setServer(
        _hostCtrl.text.trim(),
        int.parse(_portCtrl.text.trim()),
      );
      
      setState(() => _isEditing = false);
      if (mounted) {
        AppNotifications.showSuccessWithMessenger(messenger, 'Configurações do servidor salvas com sucesso!');
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showErrorWithMessenger(messenger, 'Erro ao salvar: $e');
      }
    }
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _testing = true);

    final messenger = ScaffoldMessenger.of(context);
    try {
      // Temporarily use the values from controllers to test
      final config = ref.read(localConfigProvider);
      final oldHost = config.serverHost;
      final oldPort = config.serverPort;

      await config.setServer(
        _hostCtrl.text.trim(),
        int.parse(_portCtrl.text.trim()),
      );

      final api = ref.read(apiServiceProvider);
      final success = await api.testConnection();
      
      if (mounted) {
        if (success) {
          AppNotifications.showSuccessWithMessenger(messenger, 'Conexão estabelecida com sucesso!');
        } else {
          AppNotifications.showErrorWithMessenger(messenger, 'Não foi possível conectar ao servidor');
        }
      }
      
      // If failed, revert to old config
      if (!success) {
         await config.setServer(oldHost, oldPort);
      }

    } catch (e) {
      if (mounted) {
        AppNotifications.showErrorWithMessenger(messenger, 'Erro: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _testing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final config = ref.watch(localConfigProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Configuração do Servidor', style: theme.textTheme.titleLarge),
                if (!_isEditing)
                  TextButton.icon(
                    onPressed: () => setState(() => _isEditing = true),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('Editar'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (!_isEditing) ...[
              _settingRow('Host', config.serverHost, theme),
              _settingRow('Porta', '${config.serverPort}', theme),
              _settingRow('URL Base', 'http://${config.serverHost}:${config.serverPort}', theme),
              const SizedBox(height: 32),
              const Text(
                'Nota: Alterações no servidor podem exigir que você faça login novamente.',
                style: TextStyle(color: Colors.white38, fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ] else ...[
              TextFormField(
                controller: _hostCtrl,
                decoration: const InputDecoration(
                  labelText: 'Host / IP',
                  hintText: 'ex: localhost ou 192.168.1.100',
                  prefixIcon: Icon(Icons.computer_rounded),
                ),
                style: const TextStyle(color: Colors.white),
                validator: Validators.ipAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _portCtrl,
                decoration: const InputDecoration(
                  labelText: 'Porta',
                  hintText: 'ex: 8080',
                  prefixIcon: Icon(Icons.settings_ethernet_rounded),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: Validators.port,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _testing ? null : _testConnection,
                      icon: _testing
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.wifi_find_rounded, size: 18),
                      label: Text(_testing ? 'Testando...' : 'Testar Conexão'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_rounded, size: 18),
                      label: const Text('Salvar Alterações'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      _hostCtrl.text = config.serverHost;
                      _portCtrl.text = config.serverPort.toString();
                    });
                  },
                  child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _settingRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70))),
          Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
        ],
      ),
    );
  }
}
