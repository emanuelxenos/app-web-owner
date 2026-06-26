import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/presentation/providers/auth_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/domain/models/user.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:unifytechxenoswebowner/presentation/views/settings/company_settings_screen.dart';
import 'widgets/users_settings_tab.dart';
import 'package:unifytechxenoswebowner/presentation/providers/user_management_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/backup_provider.dart';
import 'dart:io';
import 'package:unifytechxenoswebowner/domain/models/report.dart';
import 'package:unifytechxenoswebowner/data/repositories/user_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/company.dart';
import 'package:unifytechxenoswebowner/presentation/views/settings/server_settings_tab.dart';
import 'package:unifytechxenoswebowner/presentation/views/settings/fiscal_settings_tab.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _userTableController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userTableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Configurações', style: theme.textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text('Gerenciamento do sistema', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(12)),
                labelColor: Colors.white,
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                tabs: const [
                  Tab(text: 'Servidor'),
                  Tab(text: 'Empresa'),
                  Tab(text: 'Usuários'),
                  Tab(text: 'Backup'),
                  Tab(text: 'Fiscal'),
                  Tab(text: 'Sistema'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const ServerSettingsTab(),
                  const CompanySettingsScreen(),
                  UsersSettingsTab(controller: _userTableController),
                  const _BackupSettingsTab(),
                  const FiscalSettingsTab(),
                  _SystemSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _SystemSettingsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Sistema', style: theme.textTheme.titleLarge),
          const SizedBox(height: 20),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.info_outline, color: AppTheme.primaryColor),
            ),
            title: const Text('Versão do Sistema'),
            subtitle: const Text('v1.0.0'),
          ),
          const Divider(),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentRed.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout_rounded, color: AppTheme.accentRed),
            ),
            title: const Text('Sair do Sistema'),
            subtitle: const Text('Desconectar e voltar para a tela de login'),
            trailing: ElevatedButton(
              onPressed: () => ref.read(authProvider.notifier).logout(),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentRed),
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackupSettingsTab extends ConsumerStatefulWidget {
  const _BackupSettingsTab();
  @override
  ConsumerState<_BackupSettingsTab> createState() => _BackupSettingsTabState();
}

class _BackupSettingsTabState extends ConsumerState<_BackupSettingsTab> with AutomaticKeepAliveClientMixin {
  final _dirController = TextEditingController();
  String _interval = 'A cada 1 hora';
  bool _automatic = true;
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadCurrentConfig();
  }

  Future<void> _loadCurrentConfig() async {
    try {
      final configs = await ref.read(userRepositoryProvider).listarConfigs();
      for (var c in configs) {
        if (c.chave == 'backup.dir' && c.valor != null && c.valor!.isNotEmpty) {
          _dirController.text = c.valor!;
        }
        if (c.chave == 'backup.interval' && c.valor != null && c.valor!.isNotEmpty) {
          _interval = c.valor!;
        }
      }
    } catch (e) {
      // Falha silenciosa, usa defaults
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _dirController.dispose();
    super.dispose();
  }

  Future<void> _pickDirectory() async {
    final result = await FilePicker.getDirectoryPath();
    if (result != null) {
      setState(() => _dirController.text = result);
    }
  }

  void _openInExplorer() {
    final path = _dirController.text.trim().isEmpty ? '.\\backups' : _dirController.text.trim();
    if (Platform.isWindows) {
      Process.run('explorer', [path]);
    }
  }

  Future<void> _saveConfigs() async {
    try {
      final req = AtualizarConfigRequest(configs: [
        ConfigItem(chave: 'backup.dir', valor: _dirController.text),
        ConfigItem(chave: 'backup.interval', valor: _interval),
      ]);
      await ref.read(userRepositoryProvider).atualizarConfigs(req);
      if (mounted) {
        AppNotifications.showSuccess(context, 'Configurações de backup salvas');
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, 'Erro ao salvar opções: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final historyAsync = ref.watch(backupHistoryProvider);
    final executorState = ref.watch(backupExecutorProvider);

    final bool isExecuting = executorState is AsyncLoading || _isLoading;

    ref.listen(backupExecutorProvider, (prev, next) {
      if (next is AsyncData && prev is AsyncLoading) {
        AppNotifications.showSuccess(context, 'Backup concluído com sucesso!');
      } else if (next is AsyncError) {
        AppNotifications.showError(context, 'Erro no backup: ${next.error}');
      }
    });

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Gerenciamento de Backup', style: theme.textTheme.titleLarge),
              ElevatedButton.icon(
                onPressed: isExecuting ? null : () => ref.read(backupExecutorProvider.notifier).executeBackup(),
                icon: isExecuting 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.play_circle_fill_rounded, size: 18),
                label: Text(isExecuting ? 'Executando...' : 'Executar Agora'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Opções de Agendamento', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _dirController,
                      decoration: InputDecoration(
                        labelText: 'Pasta de Backup (Servidor)',
                        hintText: 'Padrão: ./backups',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.folder_open),
                              tooltip: 'Escolher Pasta',
                              onPressed: _pickDirectory,
                            ),
                            IconButton(
                              icon: const Icon(Icons.open_in_new),
                              tooltip: 'Abrir no Windows Explorer',
                              onPressed: _openInExplorer,
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _interval,
                      decoration: const InputDecoration(labelText: 'Intervalo de Backup'),
                      items: const [
                        DropdownMenuItem(value: 'Somente Manual', child: Text('Somente Manual')),
                        DropdownMenuItem(value: 'A cada 5 minutos', child: Text('A cada 5 minutos')),
                        DropdownMenuItem(value: 'A cada 30 minutos', child: Text('A cada 30 minutos')),
                        DropdownMenuItem(value: 'A cada 1 hora', child: Text('A cada 1 hora')),
                        DropdownMenuItem(value: 'A cada 6 horas', child: Text('A cada 6 horas')),
                        DropdownMenuItem(value: 'Diário', child: Text('Diário')),
                      ],
                      onChanged: (v) => setState(() => _interval = v!),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Limpeza Automática'),
                      subtitle: const Text('Excluir backups com mais de 6 meses'),
                      value: _automatic,
                      onChanged: (v) => setState(() => _automatic = v),
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _saveConfigs,
                        child: const Text('Salvar Configurações'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Histórico de Execuções', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 16),
                    historyAsync.when(
                      data: (backups) {
                        if (backups.isEmpty) {
                          return const Center(child: EmptyState(icon: Icons.history, title: 'Nenhum backup realizado', subtitle: 'Clique em executar agora para iniciar o primeiro backup.'));
                        }
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.colorScheme.outlineVariant),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: SingleChildScrollView(
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(theme.colorScheme.surface),
                              columns: const [
                                DataColumn(label: Text('DATA/HORA')),
                                DataColumn(label: Text('ARQUIVO')),
                                DataColumn(label: Text('TAMANHO')),
                                DataColumn(label: Text('TIPO')),
                                DataColumn(label: Text('STATUS')),
                              ],
                              rows: backups.map((b) {
                                final format = DateFormat('dd/MM/yyyy HH:mm:ss');
                                final sizeMB = b.tamanho != null ? (b.tamanho! / (1024 * 1024)).toStringAsFixed(2) + ' MB' : '-';
                                return DataRow(cells: [
                                  DataCell(Text(format.format(b.dataBackup))),
                                  DataCell(Text(b.nomeArquivo)),
                                  DataCell(Text(sizeMB)),
                                  DataCell(Text(b.tipo.toUpperCase())),
                                  DataCell(StatusChip.fromStatus(b.status == 'sucesso' ? 'concluido' : 'erro')),
                                ]);
                              }).toList(),
                            ),
                          ),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, st) => Center(child: Text('Erro ao carregar histórico: $e')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}

