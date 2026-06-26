import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/presentation/providers/supplier_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/domain/models/supplier.dart';

class SuppliersTab extends ConsumerWidget {
  const SuppliersTab({super.key});

  void _showFeedback(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? AppTheme.accentGreen : AppTheme.accentRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final suppliersAsync = ref.watch(suppliersProvider);
    final filtered = ref.watch(filteredSuppliersProvider);
    final paginatedFiltered = ref.watch(paginatedFilteredSuppliersProvider);
    final pagination = ref.watch(supplierPaginationStateProvider);

    return Column(
      children: [
        // Toolbar
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) {
                    ref.read(supplierSearchProvider.notifier).setQuery(v);
                    ref.read(supplierPaginationStateProvider.notifier).setPage(1);
                  },
                  decoration: const InputDecoration(
                    hintText: 'Buscar fornecedor por nome ou CNPJ...',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              FilterChip(
                label: const Text('Mostrar Inativos'),
                selected: ref.watch(supplierInactivesProvider),
                onSelected: (v) {
                  ref.read(supplierInactivesProvider.notifier).set(v);
                  ref.read(supplierPaginationStateProvider.notifier).setPage(1);
                },
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                checkmarkColor: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
        // Table
        Expanded(
          child: Container(
            decoration: AppTheme.glassCard(),
            clipBehavior: Clip.antiAlias,
            child: suppliersAsync.when(
              loading: () => const LoadingOverlay(message: 'Carregando fornecedores...'),
              error: (e, _) => EmptyState(
                icon: Icons.error_outline,
                title: 'Erro ao carregar',
                subtitle: e.toString(),
                action: ElevatedButton(
                  onPressed: () => ref.read(suppliersProvider.notifier).refresh(),
                  child: const Text('Tentar novamente'),
                ),
              ),
              data: (_) {
                if (filtered.isEmpty) {
                  return const EmptyState(
                    icon: Icons.local_shipping_outlined,
                    title: 'Nenhum fornecedor encontrado',
                    subtitle: 'Cadastre fornecedores para registrar compras.',
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: DataTable(
                          showCheckboxColumn: false,
                          columns: const [
                            DataColumn(label: Text('RAZÃO SOCIAL')),
                            DataColumn(label: Text('CNPJ')),
                            DataColumn(label: Text('TELEFONE')),
                            DataColumn(label: Text('CIDADE')),
                            DataColumn(label: Text('STATUS')),
                          ],
                          rows: paginatedFiltered.map((s) => DataRow(
                            cells: [
                              DataCell(Text(s.razaoSocial)),
                              DataCell(Text(s.cnpj ?? '-')),
                              DataCell(Text(s.telefone ?? '-')),
                              DataCell(Text(s.cidade ?? '-')),
                              DataCell(StatusChip.fromStatus(s.ativo ? 'ativo' : 'inativo')),
                            ],
                          )).toList(),
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Itens por página:', style: theme.textTheme.bodyMedium),
                              const SizedBox(width: 8),
                              DropdownButton<int>(
                                value: pagination.limit,
                                underline: const SizedBox(),
                                items: [5, 10, 20, 50].map((limit) => DropdownMenuItem(
                                  value: limit,
                                  child: Text('$limit'),
                                )).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    ref.read(supplierPaginationStateProvider.notifier).setLimit(val);
                                  }
                                },
                              ),
                            ],
                          ),
                          Text(
                            'Mostrando ${filtered.isEmpty ? 0 : (pagination.page - 1) * pagination.limit + 1} - '
                            '${(pagination.page - 1) * pagination.limit + paginatedFiltered.length} de '
                            '${filtered.length}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left_rounded),
                                onPressed: pagination.page > 1
                                    ? () => ref.read(supplierPaginationStateProvider.notifier).setPage(pagination.page - 1)
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pág. ${pagination.page}',
                                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.chevron_right_rounded),
                                onPressed: filtered.length > pagination.page * pagination.limit
                                    ? () => ref.read(supplierPaginationStateProvider.notifier).setPage(pagination.page + 1)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showSupplierForm(BuildContext context, {Fornecedor? supplier}) {
    showDialog(
      context: context,
      builder: (context) => _SupplierFormDialog(supplier: supplier),
    );
  }

  void _showSupplierDetails(BuildContext context, Fornecedor supplier) {
    showDialog(
      context: context,
      builder: (context) => _SupplierDetailsDialog(supplier: supplier),
    );
  }

  Future<void> _confirmInactivate(BuildContext context, WidgetRef ref, Fornecedor supplier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inativar Fornecedor'),
        content: Text('Deseja inativar o fornecedor "${supplier.razaoSocial}"?\nEle não aparecerá mais para novas compras.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentRed),
            child: const Text('Inativar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final (success, message) = await ref.read(suppliersProvider.notifier).inativar(supplier.idFornecedor);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: success ? AppTheme.accentGreen : AppTheme.accentRed),
        );
      }
    }
  }
}

class _SupplierFormDialog extends ConsumerStatefulWidget {
  final Fornecedor? supplier;
  const _SupplierFormDialog({this.supplier});

  @override
  ConsumerState<_SupplierFormDialog> createState() => _SupplierFormDialogState();
}

class _SupplierFormDialogState extends ConsumerState<_SupplierFormDialog> {
  final _formKey = GlobalKey<FormState>();
  
  final _razaoSocialCtrl = TextEditingController();
  final _nomeFantasiaCtrl = TextEditingController();
  final _cnpjCtrl = TextEditingController();
  final _ieCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _telefone2Ctrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cepCtrl = TextEditingController();
  final _logradouroCtrl = TextEditingController();
  final _numeroCtrl = TextEditingController();
  final _bairroCtrl = TextEditingController();
  final _cidadeCtrl = TextEditingController();
  final _estadoCtrl = TextEditingController();
  final _nomeContatoCtrl = TextEditingController();
  final _telefoneContatoCtrl = TextEditingController();
  final _prazoEntregaCtrl = TextEditingController(text: '7');
  final _prazoPagamentoCtrl = TextEditingController(text: '30');
  final _limiteCreditoCtrl = TextEditingController(text: '0,00');
  final _observacoesCtrl = TextEditingController();
  final _cnpjFormatter = MaskTextInputFormatter(mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9A-Za-z]')});
  final _phoneFormatter1 = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final _phoneFormatter2 = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final _phoneFormatterContato = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final _cepFormatter = MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
  
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      final s = widget.supplier!;
      _razaoSocialCtrl.text = s.razaoSocial;
      _nomeFantasiaCtrl.text = s.nomeFantasia ?? '';
      _cnpjCtrl.text = _cnpjFormatter.maskText(s.cnpj?.replaceAll(RegExp(r'[^0-9A-Za-z]'), '') ?? '');
      _ieCtrl.text = s.inscricaoEstadual ?? '';
      _telefoneCtrl.text = _phoneFormatter1.maskText(s.telefone?.replaceAll(RegExp(r'[^0-9]'), '') ?? '');
      _telefone2Ctrl.text = _phoneFormatter2.maskText(s.telefone2?.replaceAll(RegExp(r'[^0-9]'), '') ?? '');
      _emailCtrl.text = s.email ?? '';
      _cepCtrl.text = _cepFormatter.maskText(s.cep?.replaceAll(RegExp(r'[^0-9]'), '') ?? '');
      _logradouroCtrl.text = s.logradouro ?? '';
      _numeroCtrl.text = s.numero ?? '';
      _bairroCtrl.text = s.bairro ?? '';
      _cidadeCtrl.text = s.cidade ?? '';
      _estadoCtrl.text = s.estado ?? '';
      _nomeContatoCtrl.text = s.nomeContato ?? '';
      _telefoneContatoCtrl.text = _phoneFormatterContato.maskText(s.telefoneContato?.replaceAll(RegExp(r'[^0-9]'), '') ?? '');
      _prazoEntregaCtrl.text = s.prazoEntrega.toString();
      _prazoPagamentoCtrl.text = s.prazoPagamento.toString();
      _limiteCreditoCtrl.text = NumberFormat.simpleCurrency(locale: 'pt_BR', name: '').format(s.limiteCredito).trim();
      _observacoesCtrl.text = s.observacoes ?? '';
    }
  }
  @override
  void dispose() {
    _razaoSocialCtrl.dispose();
    _nomeFantasiaCtrl.dispose();
    _cnpjCtrl.dispose();
    _ieCtrl.dispose();
    _telefoneCtrl.dispose();
    _telefone2Ctrl.dispose();
    _emailCtrl.dispose();
    _cepCtrl.dispose();
    _logradouroCtrl.dispose();
    _numeroCtrl.dispose();
    _bairroCtrl.dispose();
    _cidadeCtrl.dispose();
    _estadoCtrl.dispose();
    _nomeContatoCtrl.dispose();
    _telefoneContatoCtrl.dispose();
    _prazoEntregaCtrl.dispose();
    _prazoPagamentoCtrl.dispose();
    _limiteCreditoCtrl.dispose();
    _observacoesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.supplier != null;
    return DefaultTabController(
      length: 3,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              isEditing ? Icons.edit_outlined : Icons.add_business_rounded,
              color: AppTheme.primaryColor,
              size: 26,
            ),
            const SizedBox(width: 12),
            Text(
              isEditing ? 'Editar Fornecedor' : 'Novo Fornecedor',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: 650,
          height: 480,
          child: Column(
            children: [
              TabBar(
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: theme.hintColor,
                indicatorColor: AppTheme.primaryColor,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Dados Básicos'),
                  Tab(text: 'Contato & Endereço'),
                  Tab(text: 'Financeiro & Outros'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TabBarView(
                    children: [
                      // Tab 1: Dados Básicos
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _razaoSocialCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Razão Social *',
                                prefixIcon: Icon(Icons.business_rounded, size: 20),
                                hintText: 'Ex: UnifyTech Distribuidores Ltda',
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'A Razão Social é obrigatória';
                                if (v.trim().length < 3) return 'Deve ter pelo menos 3 caracteres';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nomeFantasiaCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Nome Fantasia',
                                prefixIcon: Icon(Icons.store_rounded, size: 20),
                                hintText: 'Ex: UnifyTech',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _cnpjCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'CNPJ',
                                      prefixIcon: Icon(Icons.badge_rounded, size: 20),
                                      hintText: '00.000.000/0000-00',
                                    ),
                                    inputFormatters: [_cnpjFormatter],
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) return null;
                                      final clean = _cnpjFormatter.getUnmaskedText();
                                      if (clean.length != 14) return 'CNPJ incompleto';
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _ieCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Inscrição Estadual',
                                      prefixIcon: Icon(Icons.description_rounded, size: 20),
                                      hintText: 'Ex: Isento ou número',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Tab 2: Contato & Endereço
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _telefoneCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Telefone Principal',
                                      prefixIcon: Icon(Icons.phone_rounded, size: 20),
                                      hintText: '(00) 00000-0000',
                                    ),
                                    inputFormatters: [_phoneFormatter1],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _telefone2Ctrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Telefone Secundário',
                                      prefixIcon: Icon(Icons.phone_rounded, size: 20),
                                      hintText: '(00) 00000-0000',
                                    ),
                                    inputFormatters: [_phoneFormatter2],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_rounded, size: 20),
                                hintText: 'contato@fornecedor.com',
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return null;
                                final email = v.trim();
                                if (!email.contains('@') || !email.contains('.')) return 'Email inválido';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _cepCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'CEP',
                                      prefixIcon: Icon(Icons.map_rounded, size: 20),
                                      hintText: '00000-000',
                                    ),
                                    inputFormatters: [_cepFormatter],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _logradouroCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Logradouro',
                                      prefixIcon: Icon(Icons.home_rounded, size: 20),
                                      hintText: 'Ex: Rua das Flores',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _numeroCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Número',
                                      hintText: 'Ex: 123',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _bairroCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Bairro',
                                      hintText: 'Ex: Centro',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _cidadeCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Cidade',
                                      hintText: 'Ex: São Paulo',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _estadoCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Estado (UF)',
                                      hintText: 'Ex: SP',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Tab 3: Financeiro & Outros
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _nomeContatoCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Nome do Contato',
                                      prefixIcon: Icon(Icons.person_rounded, size: 20),
                                      hintText: 'Ex: João da Silva',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _telefoneContatoCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Telefone Contato',
                                      prefixIcon: Icon(Icons.contact_phone_rounded, size: 20),
                                      hintText: '(00) 00000-0000',
                                    ),
                                    inputFormatters: [_phoneFormatterContato],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _prazoEntregaCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Prazo Entrega (dias)',
                                      prefixIcon: Icon(Icons.local_shipping_rounded, size: 20),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) return 'Obrigatório';
                                      if (int.tryParse(v) == null) return 'Apenas números';
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _prazoPagamentoCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Prazo Pagam. (dias)',
                                      prefixIcon: Icon(Icons.payment_rounded, size: 20),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) return 'Obrigatório';
                                      if (int.tryParse(v) == null) return 'Apenas números';
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextFormField(
                                    controller: _limiteCreditoCtrl,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [CurrencyInputFormatter()],
                                    decoration: const InputDecoration(
                                      labelText: r'Lim. Crédito (R$)',
                                      prefixIcon: Icon(Icons.monetization_on_rounded, size: 20),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) return 'Obrigatório';
                                      final clean = v.trim().replaceAll('.', '').replaceAll(',', '.');
                                      if (double.tryParse(clean) == null) return 'Formato inválido';
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _observacoesCtrl,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Observações Gerais',
                                prefixIcon: Icon(Icons.notes_rounded, size: 20),
                                hintText: 'Insira observações, termos, detalhes...',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(isEditing ? 'Salvar' : 'Cadastrar'),
          ),
        ],
      ),
    );
  }
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    String? _unmask(String text, {bool keepAlpha = false}) {
      final clean = text.replaceAll(RegExp(keepAlpha ? r'[^0-9A-Za-z]' : r'[^0-9]'), '');
      return clean.isEmpty ? null : clean;
    }

    double? _parseBrazilianDouble(String v) {
      var clean = v.trim();
      if (clean.isEmpty) return null;
      if (clean.contains(',') && clean.contains('.')) {
        clean = clean.replaceAll('.', '').replaceAll(',', '.');
      } else if (clean.contains(',')) {
        clean = clean.replaceAll(',', '.');
      }
      return double.tryParse(clean);
    }

    final req = CriarFornecedorRequest(
      razaoSocial: _razaoSocialCtrl.text.trim(),
      nomeFantasia: _nomeFantasiaCtrl.text.trim().isEmpty ? null : _nomeFantasiaCtrl.text.trim(),
      cnpj: _unmask(_cnpjCtrl.text, keepAlpha: true),
      inscricaoEstadual: _ieCtrl.text.trim().isEmpty ? null : _ieCtrl.text.trim(),
      telefone: _unmask(_telefoneCtrl.text),
      telefone2: _unmask(_telefone2Ctrl.text),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      cep: _unmask(_cepCtrl.text),
      logradouro: _logradouroCtrl.text.trim().isEmpty ? null : _logradouroCtrl.text.trim(),
      numero: _numeroCtrl.text.trim().isEmpty ? null : _numeroCtrl.text.trim(),
      bairro: _bairroCtrl.text.trim().isEmpty ? null : _bairroCtrl.text.trim(),
      cidade: _cidadeCtrl.text.trim().isEmpty ? null : _cidadeCtrl.text.trim(),
      estado: _estadoCtrl.text.trim().isEmpty ? null : _estadoCtrl.text.trim(),
      nomeContato: _nomeContatoCtrl.text.trim().isEmpty ? null : _nomeContatoCtrl.text.trim(),
      telefoneContato: _unmask(_telefoneContatoCtrl.text),
      prazoEntrega: int.tryParse(_prazoEntregaCtrl.text),
      prazoPagamento: int.tryParse(_prazoPagamentoCtrl.text),
      limiteCredito: _parseBrazilianDouble(_limiteCreditoCtrl.text),
      observacoes: _observacoesCtrl.text.trim().isEmpty ? null : _observacoesCtrl.text.trim(),
    );

    final bool success;
    final String message;

    try {
      if (widget.supplier != null) {
        final result = await ref.read(suppliersProvider.notifier).atualizar(widget.supplier!.idFornecedor, req);
        success = result.$1;
        message = result.$2;
      } else {
        final result = await ref.read(suppliersProvider.notifier).criar(req);
        success = result.$1;
        message = result.$2;
      }
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: success ? AppTheme.accentGreen : AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class _SupplierDetailsDialog extends StatelessWidget {
  final Fornecedor supplier;
  const _SupplierDetailsDialog({required this.supplier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget _buildDetailRow(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: AppTheme.primaryColor.withOpacity(0.8)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value.isNotEmpty ? value : 'Não informado',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(
              Icons.local_shipping_rounded,
              color: AppTheme.primaryColor,
              size: 26,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supplier.razaoSocial,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (supplier.nomeFantasia != null && supplier.nomeFantasia!.isNotEmpty)
                    Text(
                      supplier.nomeFantasia!,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            StatusChip.fromStatus(supplier.ativo ? 'ativo' : 'inativo'),
          ],
        ),
        content: SizedBox(
          width: 650,
          height: 480,
          child: Column(
            children: [
              TabBar(
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: theme.hintColor,
                indicatorColor: AppTheme.primaryColor,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Dados Básicos'),
                  Tab(text: 'Contato & Endereço'),
                  Tab(text: 'Financeiro & Outros'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: Dados Básicos
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Column(
                        children: [
                          _buildDetailRow(Icons.business_rounded, 'Razão Social', supplier.razaoSocial),
                          _buildDetailRow(Icons.store_rounded, 'Nome Fantasia', supplier.nomeFantasia ?? ''),
                          _buildDetailRow(Icons.badge_rounded, 'CNPJ', supplier.cnpj ?? ''),
                          _buildDetailRow(Icons.description_rounded, 'Inscrição Estadual', supplier.inscricaoEstadual ?? ''),
                        ],
                      ),
                    ),
                    // Tab 2: Contato & Endereço
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildDetailRow(Icons.phone_rounded, 'Telefone Principal', supplier.telefone ?? '')),
                              Expanded(child: _buildDetailRow(Icons.phone_rounded, 'Telefone Secundário', supplier.telefone2 ?? '')),
                            ],
                          ),
                          _buildDetailRow(Icons.email_rounded, 'E-mail', supplier.email ?? ''),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: _buildDetailRow(Icons.map_rounded, 'CEP', supplier.cep ?? '')),
                              Expanded(flex: 3, child: _buildDetailRow(Icons.home_rounded, 'Logradouro', supplier.logradouro ?? '')),
                              Expanded(flex: 2, child: _buildDetailRow(Icons.pin_drop_rounded, 'Número', supplier.numero ?? '')),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildDetailRow(Icons.location_city_rounded, 'Bairro', supplier.bairro ?? '')),
                              Expanded(child: _buildDetailRow(Icons.location_city_rounded, 'Cidade', supplier.cidade ?? '')),
                              Expanded(child: _buildDetailRow(Icons.flag_rounded, 'Estado (UF)', supplier.estado ?? '')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Tab 3: Financeiro & Outros
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildDetailRow(Icons.person_rounded, 'Nome do Contato', supplier.nomeContato ?? '')),
                              Expanded(child: _buildDetailRow(Icons.contact_phone_rounded, 'Telefone do Contato', supplier.telefoneContato ?? '')),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildDetailRow(Icons.local_shipping_rounded, 'Prazo de Entrega', '${supplier.prazoEntrega} dias')),
                              Expanded(child: _buildDetailRow(Icons.payment_rounded, 'Prazo de Pagamento', '${supplier.prazoPagamento} dias')),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildDetailRow(Icons.monetization_on_rounded, 'Limite de Crédito', supplier.limiteCredito > 0 ? 'R\$ ${supplier.limiteCredito.toStringAsFixed(2)}' : 'Não definido')),
                              Expanded(child: _buildDetailRow(Icons.shopping_bag_rounded, 'Total em Compras', 'R\$ ${supplier.totalCompras.toStringAsFixed(2)}')),
                            ],
                          ),
                          _buildDetailRow(Icons.notes_rounded, 'Observações', supplier.observacoes ?? ''),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.simpleCurrency(locale: 'pt_BR', name: '');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) {
      return newValue.copyWith(text: '0,00', selection: const TextSelection.collapsed(offset: 4));
    }

    double value = double.parse(cleanText) / 100;
    String newText = _formatter.format(value).trim();

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
