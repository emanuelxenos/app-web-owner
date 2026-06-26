import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/presentation/providers/system_parameters_provider.dart';
import 'package:unifytechxenoswebowner/domain/models/system_parameters.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';

class SystemParametersScreen extends ConsumerStatefulWidget {
  const SystemParametersScreen({super.key});

  @override
  ConsumerState<SystemParametersScreen> createState() => _SystemParametersScreenState();
}

class _SystemParametersScreenState extends ConsumerState<SystemParametersScreen> {
  final _comissaoController = TextEditingController();
  final _ticketAlvoController = TextEditingController();
  bool _hasChanges = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _comissaoController.dispose();
    _ticketAlvoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(systemParametersStateProvider);
    final theme = Theme.of(context);

    // Sincronizar controladores quando os dados mudarem no servidor (após o build inicial)
    ref.listen(systemParametersStateProvider, (previous, next) {
      next.whenData((params) {
        if (!_hasChanges) {
          setState(() {
            _comissaoController.text = params.comissaoPadrao.toStringAsFixed(2);
            _ticketAlvoController.text = params.ticketMedioAlvo.toStringAsFixed(2);
          });
        }
      });
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Parâmetros do Sistema'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_hasChanges)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_rounded),
                label: const Text('Salvar Alterações'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppTheme.accentRed, size: 48),
              const SizedBox(height: 16),
              Text('Erro ao carregar parâmetros: $err', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(systemParametersStateProvider),
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
        data: (params) {
          if (!_isInitialized) {
            _comissaoController.text = params.comissaoPadrao.toStringAsFixed(2);
            _ticketAlvoController.text = params.ticketMedioAlvo.toStringAsFixed(2);
            _isInitialized = true;
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Vendas e Comissões'),
                const SizedBox(height: 16),
                Container(
                  decoration: AppTheme.glassCard(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildInput(
                        label: 'Comissão Padrão Operador (%)',
                        controller: _comissaoController,
                        icon: Icons.percent_rounded,
                        hint: 'Ex: 1.00',
                        onChanged: (_) => setState(() => _hasChanges = true),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.info_outline, size: 14, color: Colors.white54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Percentual padrão para cálculo de comissões nos relatórios.',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Metas Financeiras (BI)'),
                const SizedBox(height: 16),
                Container(
                  decoration: AppTheme.glassCard(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildInput(
                        label: 'Meta de Ticket Médio (R\$)',
                        controller: _ticketAlvoController,
                        icon: Icons.track_changes_rounded,
                        hint: 'Ex: 50.00',
                        onChanged: (_) => setState(() => _hasChanges = true),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.info_outline, size: 14, color: Colors.white54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Valor usado como meta de desempenho no Dashboard.',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final comissaoText = _comissaoController.text.replaceAll(',', '.');
    final ticketText = _ticketAlvoController.text.replaceAll(',', '.');

    final comissao = double.tryParse(comissaoText) ?? 0.0;
    final ticket = double.tryParse(ticketText) ?? 0.0;

    final newParams = SystemParameters(
      comissaoPadrao: comissao,
      ticketMedioAlvo: ticket,
    );

    try {
      await ref.read(systemParametersStateProvider.notifier).updateParameters(newParams);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Parâmetros salvos com sucesso!'),
            backgroundColor: AppTheme.accentGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() => _hasChanges = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
