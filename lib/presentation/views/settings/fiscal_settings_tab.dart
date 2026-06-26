import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/presentation/providers/empresa_provider.dart';
import 'package:unifytechxenoswebowner/domain/models/company.dart';

class FiscalSettingsTab extends ConsumerStatefulWidget {
  const FiscalSettingsTab({super.key});

  @override
  ConsumerState<FiscalSettingsTab> createState() => _FiscalSettingsTabState();
}

class _FiscalSettingsTabState extends ConsumerState<FiscalSettingsTab> {
  final _formKey = GlobalKey<FormState>();
  
  final _inscricaoMunicipalController = TextEditingController();
  final _inscricaoEstadualController = TextEditingController();
  final _cscTokenController = TextEditingController();
  final _cscIdController = TextEditingController();
  final _certificadoSenhaController = TextEditingController();
  
  int _crt = 1; 
  int _ambiente = 2; 
  String _ufEmissao = 'PE';
  String? _certificadoNome;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _inscricaoMunicipalController.dispose();
    _inscricaoEstadualController.dispose();
    _cscTokenController.dispose();
    _cscIdController.dispose();
    _certificadoSenhaController.dispose();
    super.dispose();
  }


  Future<void> _pickCertificado() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pfx', 'p12'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _certificadoNome = result.files.single.name;
          _isLoading = true;
        });
        
        await ref.read(empresaStateProvider.notifier).uploadCertificado(result.files.single.path!);
        
        if (mounted) {
          AppNotifications.showSuccess(context, 'Certificado enviado com sucesso!');
        }
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, 'Erro ao selecionar certificado: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveFiscalConfigs() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final fiscalData = {
        'inscricao_municipal': _inscricaoMunicipalController.text,
        'inscricao_estadual': _inscricaoEstadualController.text,
        'crt': _crt,
        'csc_token': _cscTokenController.text,
        'csc_id': _cscIdController.text,
        'uf_emissao': _ufEmissao,
        'certificado_senha': _certificadoSenhaController.text,
        'ambiente': _ambiente,
      };

      await ref.read(empresaStateProvider.notifier).atualizarFiscal(fiscalData);
      
      if (mounted) {
        AppNotifications.showSuccess(context, 'Configurações fiscais salvas com sucesso!');
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, 'Erro ao salvar: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final empresaAsync = ref.watch(empresaStateProvider);

    // Escutar mudanças no estado da empresa para preencher os controllers
    ref.listen<AsyncValue<Empresa>>(empresaStateProvider, (previous, next) {
      next.whenData((empresa) {
        if (_inscricaoMunicipalController.text.isEmpty) {
          _inscricaoMunicipalController.text = empresa.inscricaoMunicipal ?? '';
        }
        if (_inscricaoEstadualController.text.isEmpty) {
          _inscricaoEstadualController.text = empresa.inscricaoEstadual ?? '';
        }
        if (_cscTokenController.text.isEmpty) {
          _cscTokenController.text = empresa.cscToken ?? '';
        }
        if (_cscIdController.text.isEmpty) {
          _cscIdController.text = empresa.cscId ?? '';
        }
        if (_certificadoSenhaController.text.isEmpty) {
          _certificadoSenhaController.text = empresa.certificadoSenha ?? '';
        }
        
        setState(() {
          _crt = empresa.crt;
          _ambiente = empresa.ambiente;
          _ufEmissao = empresa.ufEmissao;
        });
      });
    });

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Configuração de Emissão Fiscal', style: theme.textTheme.titleLarge),
                  if (_isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _saveFiscalConfigs,
                      icon: const Icon(Icons.save_rounded, size: 18),
                      label: const Text('Salvar Alterações'),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _ambiente,
                      decoration: const InputDecoration(
                        labelText: 'Ambiente de Emissão',
                        prefixIcon: Icon(Icons.cloud_queue_rounded),
                      ),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('Produção (Notas Reais)')),
                        DropdownMenuItem(value: 2, child: Text('Homologação (Testes)')),
                      ],
                      onChanged: (v) => setState(() => _ambiente = v!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _crt,
                      decoration: const InputDecoration(
                        labelText: 'Regime Tributário (CRT)',
                        prefixIcon: Icon(Icons.gavel_rounded),
                      ),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('1 - Simples Nacional')),
                        DropdownMenuItem(value: 2, child: Text('2 - Simples Nacional (Excesso)')),
                        DropdownMenuItem(value: 3, child: Text('3 - Regime Normal')),
                      ],
                      onChanged: (v) => setState(() => _crt = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _ufEmissao,
                decoration: const InputDecoration(
                  labelText: 'UF de Emissão (Estado)',
                  prefixIcon: Icon(Icons.map_rounded),
                ),
                items: const [
                  DropdownMenuItem(value: 'AC', child: Text('AC - Acre')),
                  DropdownMenuItem(value: 'AL', child: Text('AL - Alagoas')),
                  DropdownMenuItem(value: 'AM', child: Text('AM - Amazonas')),
                  DropdownMenuItem(value: 'AP', child: Text('AP - Amapá')),
                  DropdownMenuItem(value: 'BA', child: Text('BA - Bahia')),
                  DropdownMenuItem(value: 'CE', child: Text('CE - Ceará')),
                  DropdownMenuItem(value: 'DF', child: Text('DF - Distrito Federal')),
                  DropdownMenuItem(value: 'ES', child: Text('ES - Espírito Santo')),
                  DropdownMenuItem(value: 'GO', child: Text('GO - Goiás')),
                  DropdownMenuItem(value: 'MA', child: Text('MA - Maranhão')),
                  DropdownMenuItem(value: 'MG', child: Text('MG - Minas Gerais')),
                  DropdownMenuItem(value: 'MS', child: Text('MS - Mato Grosso do Sul')),
                  DropdownMenuItem(value: 'MT', child: Text('MT - Mato Grosso')),
                  DropdownMenuItem(value: 'PA', child: Text('PA - Pará')),
                  DropdownMenuItem(value: 'PB', child: Text('PB - Paraíba')),
                  DropdownMenuItem(value: 'PE', child: Text('PE - Pernambuco')),
                  DropdownMenuItem(value: 'PI', child: Text('PI - Piauí')),
                  DropdownMenuItem(value: 'PR', child: Text('PR - Paraná')),
                  DropdownMenuItem(value: 'RJ', child: Text('RJ - Rio de Janeiro')),
                  DropdownMenuItem(value: 'RN', child: Text('RN - Rio Grande do Norte')),
                  DropdownMenuItem(value: 'RO', child: Text('RO - Rondônia')),
                  DropdownMenuItem(value: 'RR', child: Text('RR - Roraima')),
                  DropdownMenuItem(value: 'RS', child: Text('RS - Rio Grande do Sul')),
                  DropdownMenuItem(value: 'SC', child: Text('SC - Santa Catarina')),
                  DropdownMenuItem(value: 'SE', child: Text('SE - Sergipe')),
                  DropdownMenuItem(value: 'SP', child: Text('SP - São Paulo')),
                  DropdownMenuItem(value: 'TO', child: Text('TO - Tocantins')),
                ],
                onChanged: (v) => setState(() => _ufEmissao = v!),
              ),
              
              const SizedBox(height: 24),
              Text('Certificado Digital', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.badge_rounded, color: AppTheme.primaryColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _certificadoNome ?? 'Nenhum certificado selecionado (.pfx)',
                              style: TextStyle(
                                color: _certificadoNome != null ? Colors.white : Colors.white38,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _pickCertificado,
                            icon: const Icon(Icons.file_upload_outlined),
                            label: const Text('Selecionar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _certificadoSenhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha do Certificado',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              Text('Configurações de NFC-e (Cupom Fiscal)', style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _cscIdController,
                      decoration: const InputDecoration(
                        labelText: 'ID do Token CSC',
                        hintText: 'Ex: 000001',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _cscTokenController,
                      decoration: const InputDecoration(
                        labelText: 'Código do Token CSC',
                        hintText: 'Ex: 1A2B3C4D-5E6F...',
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _inscricaoEstadualController,
                      label: 'Inscrição Estadual',
                      icon: Icons.business_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _inscricaoMunicipalController,
                      label: 'Inscrição Municipal',
                      icon: Icons.location_city_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
