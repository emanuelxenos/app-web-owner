import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';
import 'package:unifytechxenoswebowner/presentation/providers/product_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/category_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

class ProductFormDialog extends ConsumerStatefulWidget {
  final Produto? produto;
  final void Function(bool success, String message) onResult;

  const ProductFormDialog({super.key, this.produto, required this.onResult});

  @override
  ConsumerState<ProductFormDialog> createState() =>
      _ProductFormDialogState();
}

class _ProductFormDialogState extends ConsumerState<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  // Controllers
  late TextEditingController _nomeCtrl;
  late TextEditingController _descricaoCtrl;
  late TextEditingController _codigoBarrasCtrl;
  late TextEditingController _codigoInternoCtrl;
  late TextEditingController _marcaCtrl;
  late TextEditingController _precoVendaCtrl;
  late TextEditingController _precoCustoCtrl;
  late TextEditingController _precoPromocionalCtrl;
  late TextEditingController _estoqueMinCtrl;
  late TextEditingController _localizacaoCtrl;
  
  // Fiscal Controllers
  late TextEditingController _ncmCtrl;
  late TextEditingController _cestCtrl;
  late TextEditingController _cfopPadraoCtrl;
  late TextEditingController _csosnPadraoCtrl;
  late TextEditingController _cstPadraoCtrl;
  late TextEditingController _icmsAliquotaCtrl;
  late TextEditingController _pisAliquotaCtrl;
  late TextEditingController _cofinsAliquotaCtrl;
  
  DateTime? _dataVencimento;
  DateTime? _dataInicioPromocao;
  DateTime? _dataFimPromocao;

  // State
  int? _selectedCategoriaId;
  String _unidadeVenda = 'UN';
  bool _controlarEstoque = true;
  int _origem = 0; // 0-Nacional
  String? _fotoUrl;
  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _uploading = false;
  bool _lookingUp = false;

  // Intelligence
  double _margemLucro = 0;
  double _markup = 0;

  bool get isEdit => widget.produto != null && widget.produto!.idProduto != 0;

  @override
  void initState() {
    super.initState();
    final p = widget.produto;
    _nomeCtrl = TextEditingController(text: p?.nome ?? '');
    _descricaoCtrl = TextEditingController(text: p?.descricao ?? '');
    _codigoBarrasCtrl = TextEditingController(text: p?.codigoBarras ?? '');
    _codigoInternoCtrl =
        TextEditingController(text: p?.codigoInterno ?? '');
    _marcaCtrl = TextEditingController(text: p?.marca ?? '');
    _precoVendaCtrl =
        TextEditingController(text: p != null ? p.precoVenda.toString() : '');
    _precoCustoCtrl =
        TextEditingController(text: p != null ? p.precoCusto.toString() : '0');
    _precoPromocionalCtrl = TextEditingController(
        text: p?.precoPromocional != null ? p!.precoPromocional.toString() : '');
    _estoqueMinCtrl = TextEditingController(
        text: p != null ? p.estoqueMinimo.toString() : '0');
    _localizacaoCtrl = TextEditingController(text: p?.localizacao ?? '');
    
    _dataVencimento = p?.dataVencimento;
    _dataInicioPromocao = p?.dataInicioPromocao;
    _dataFimPromocao = p?.dataFimPromocao;
    _selectedCategoriaId = p?.categoriaId;
    _unidadeVenda = p?.unidadeVenda ?? 'UN';
    _controlarEstoque = p?.controlarEstoque ?? true;
    _origem = p?.origem ?? 0;
    _fotoUrl = p?.fotoPrincipalUrl;

    // Fiscal Init
    _ncmCtrl = TextEditingController(text: p?.ncm ?? '');
    _cestCtrl = TextEditingController(text: p?.cest ?? '');
    _cfopPadraoCtrl = TextEditingController(text: p?.cfopPadrao ?? '5102');
    _csosnPadraoCtrl = TextEditingController(text: p?.csosnPadrao ?? '102');
    _cstPadraoCtrl = TextEditingController(text: p?.cstPadrao ?? '00');
    _icmsAliquotaCtrl = TextEditingController(text: p?.icmsAliquota?.toString() ?? '0');
    _pisAliquotaCtrl = TextEditingController(text: p?.pisAliquota?.toString() ?? '0');
    _cofinsAliquotaCtrl = TextEditingController(text: p?.cofinsAliquota?.toString() ?? '0');

    _calculateIntelligence();

    // Listeners for real-time calculation
    _precoVendaCtrl.addListener(_calculateIntelligence);
    _precoCustoCtrl.addListener(_calculateIntelligence);
  }

  void _calculateIntelligence() {
    final custo = double.tryParse(_precoCustoCtrl.text) ?? 0;
    final venda = double.tryParse(_precoVendaCtrl.text) ?? 0;

    setState(() {
      if (venda > 0) {
        _margemLucro = ((venda - custo) / venda) * 100;
      } else {
        _margemLucro = 0;
      }

      if (custo > 0) {
        _markup = ((venda - custo) / custo) * 100;
      } else {
        _markup = 0;
      }
    });
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _descricaoCtrl.dispose();
    _codigoBarrasCtrl.dispose();
    _codigoInternoCtrl.dispose();
    _marcaCtrl.dispose();
    _precoVendaCtrl.dispose();
    _precoCustoCtrl.dispose();
    _precoPromocionalCtrl.dispose();
    _estoqueMinCtrl.dispose();
    _localizacaoCtrl.dispose();
    _ncmCtrl.dispose();
    _cestCtrl.dispose();
    _cfopPadraoCtrl.dispose();
    _csosnPadraoCtrl.dispose();
    _cstPadraoCtrl.dispose();
    _icmsAliquotaCtrl.dispose();
    _pisAliquotaCtrl.dispose();
    _cofinsAliquotaCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      withData: true,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return;

    setState(() => _uploading = true);

    final file = result.files.first;
    setState(() {
      _selectedImageBytes = file.bytes;
      _selectedImageName = file.name;
      _uploading = false;
    });
  }

  CriarProdutoRequest _buildRequest() {
    return CriarProdutoRequest(
      nome: _nomeCtrl.text.trim(),
      descricao: _descricaoCtrl.text.trim().isEmpty ? null : _descricaoCtrl.text.trim(),
      codigoBarras: _codigoBarrasCtrl.text.trim().isEmpty ? null : _codigoBarrasCtrl.text.trim(),
      codigoInterno: _codigoInternoCtrl.text.trim().isEmpty ? null : _codigoInternoCtrl.text.trim(),
      categoriaId: _selectedCategoriaId,
      unidadeVenda: _unidadeVenda,
      controlarEstoque: _controlarEstoque,
      estoqueMinimo: double.tryParse(_estoqueMinCtrl.text) ?? 0,
      precoCusto: double.tryParse(_precoCustoCtrl.text) ?? 0,
      precoVenda: double.tryParse(_precoVendaCtrl.text) ?? 0,
      precoPromocional: double.tryParse(_precoPromocionalCtrl.text),
      dataInicioPromocao: _dataInicioPromocao,
      dataFimPromocao: _dataFimPromocao,
      margemLucro: _margemLucro,
      marca: _marcaCtrl.text.trim().isEmpty ? null : _marcaCtrl.text.trim(),
      localizacao: _localizacaoCtrl.text.trim().isEmpty ? null : _localizacaoCtrl.text.trim(),
      dataVencimento: _dataVencimento,
      fotoPrincipalUrl: _fotoUrl,
      ncm: _ncmCtrl.text.trim().isEmpty ? null : _ncmCtrl.text.trim(),
      origem: _origem,
      cest: _cestCtrl.text.trim().isEmpty ? null : _cestCtrl.text.trim(),
      cfopPadrao: _cfopPadraoCtrl.text.trim().isEmpty ? null : _cfopPadraoCtrl.text.trim(),
      csosnPadrao: _csosnPadraoCtrl.text.trim().isEmpty ? null : _csosnPadraoCtrl.text.trim(),
      cstPadrao: _cstPadraoCtrl.text.trim().isEmpty ? null : _cstPadraoCtrl.text.trim(),
      icmsAliquota: double.tryParse(_icmsAliquotaCtrl.text) ?? 0,
      pisAliquota: double.tryParse(_pisAliquotaCtrl.text) ?? 0,
      cofinsAliquota: double.tryParse(_cofinsAliquotaCtrl.text) ?? 0,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    String? finalFotoUrl = _fotoUrl;

    // Se houver uma nova imagem selecionada, faz o upload agora
    if (_selectedImageBytes != null && _selectedImageName != null) {
      final (success, message, url) = await ref
          .read(productsProvider.notifier)
          .uploadFoto(_selectedImageBytes!, _selectedImageName!);
      
      if (!success) {
        setState(() => _saving = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro no upload da foto: $message')),
          );
        }
        return;
      }
      finalFotoUrl = url;
    }

    final (success, message) = isEdit
        ? await ref
            .read(productsProvider.notifier)
            .atualizar(widget.produto!.idProduto, _buildRequest().copyWith(fotoPrincipalUrl: finalFotoUrl))
        : await ref.read(productsProvider.notifier).criar(_buildRequest().copyWith(fotoPrincipalUrl: finalFotoUrl));

    setState(() => _saving = false);

    if (mounted) {
      Navigator.pop(context);
      widget.onResult(success, message);
    }
  }

  Future<void> _lookupExternal() async {
    final ean = _codigoBarrasCtrl.text.trim();
    if (ean.isEmpty) return;

    setState(() => _lookingUp = true);

    try {
      final res = await ref.read(productsProvider.notifier).lookupExternal(ean);
      if (res != null) {
        setState(() {
          if (_nomeCtrl.text.isEmpty && res.nome.isNotEmpty) _nomeCtrl.text = res.nome;
          if (_marcaCtrl.text.isEmpty && res.marca.isNotEmpty) _marcaCtrl.text = res.marca;
          if (_ncmCtrl.text.isEmpty && res.ncm.isNotEmpty) _ncmCtrl.text = res.ncm;
          if (_cestCtrl.text.isEmpty && res.cest.isNotEmpty) _cestCtrl.text = res.cest;
          if (_fotoUrl == null && res.fotoUrl.isNotEmpty) {
            _fotoUrl = res.fotoUrl;
          }
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dados importados via ${res.fonte}!'),
              backgroundColor: AppTheme.accentGreen,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produto não encontrado em bases externas.'),
              backgroundColor: AppTheme.accentOrange,
            ),
          );
        }
      }
    } catch (e) {
       // Silent error
    } finally {
      if (mounted) setState(() => _lookingUp = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriasAsync = ref.watch(categoriesProvider);

    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isEdit ? Icons.edit : Icons.add_box_rounded,
              color: AppTheme.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(isEdit ? 'Editar Produto' : 'Novo Produto'),
        ],
      ),
      content: SizedBox(
        width: 650,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Foto do Produto ───
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _uploading ? null : _pickImage,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppTheme.primaryColor.withValues(alpha: 0.3),
                              width: 2,
                            ),
                            image: _selectedImageBytes != null
                                ? DecorationImage(
                                    image: MemoryImage(_selectedImageBytes!),
                                    fit: BoxFit.cover,
                                  )
                                : (_fotoUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          _fotoUrl!.startsWith('http') 
                                              ? _fotoUrl! 
                                              : '${ref.read(apiServiceProvider).baseUrl}$_fotoUrl'
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null),
                          ),
                          child: _selectedImageBytes == null && _fotoUrl == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _uploading ? Icons.cloud_upload_rounded : Icons.add_a_photo_rounded,
                                      size: 40,
                                      color: AppTheme.primaryColor.withValues(alpha: 0.5),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _uploading ? 'Enviando...' : 'Adicionar Foto',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.primaryColor.withValues(alpha: 0.5),
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      ),
                      if (_selectedImageBytes != null || _fotoUrl != null)
                        TextButton.icon(
                          onPressed: () => setState(() {
                            _selectedImageBytes = null;
                            _selectedImageName = null;
                            _fotoUrl = null;
                          }),
                          icon: const Icon(Icons.delete_outline_rounded, size: 16),
                          label: const Text('Remover Foto'),
                          style: TextButton.styleFrom(foregroundColor: AppTheme.accentRed),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // ─── Informações Básicas ───
                Text('Informações Básicas',
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nomeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Produto *',
                    prefixIcon: Icon(Icons.label_rounded),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Nome é obrigatório' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descricaoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    prefixIcon: Icon(Icons.description_rounded),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _marcaCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Marca',
                          prefixIcon: Icon(Icons.branding_watermark_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: categoriasAsync.response.when(
                        loading: () => const LinearProgressIndicator(),
                        error: (_, _) => DropdownButtonFormField<int>(
                          value: _selectedCategoriaId,
                          decoration: const InputDecoration(
                            labelText: 'Categoria',
                            prefixIcon: Icon(Icons.category_rounded),
                          ),
                          items: const [],
                          onChanged: (v) =>
                              setState(() => _selectedCategoriaId = v),
                          hint: const Text('Sem categorias'),
                        ),
                        data: (categorias) {
                          return DropdownButtonFormField<int?>(
                            value: _selectedCategoriaId,
                            decoration: const InputDecoration(
                              labelText: 'Categoria',
                              prefixIcon: Icon(Icons.category_rounded),
                            ),
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text('Sem categoria'),
                              ),
                              ...categorias.data.map((c) => DropdownMenuItem<int?>(
                                    value: c.idCategoria,
                                    child: Text(c.nome),
                                  )),
                            ],
                            onChanged: (v) =>
                                setState(() => _selectedCategoriaId = v),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // ─── Preços e Inteligência ───
                Row(
                  children: [
                    Text('Preços e Inteligência',
                        style: theme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _margemLucro >= 30 ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _margemLucro >= 30 ? Colors.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Margem: ${_margemLucro.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _margemLucro >= 30 ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Markup: ${_markup.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _precoCustoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Preço de Custo',
                          prefixIcon: Icon(Icons.money_off_rounded),
                          prefixText: 'R\$ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _precoVendaCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Preço de Venda *',
                          prefixIcon: Icon(Icons.attach_money_rounded),
                          prefixText: 'R\$ ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Obrigatório';
                          final val = double.tryParse(v);
                          if (val == null || val <= 0) return 'Preço inválido';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // ─── Promoção ───
                Row(
                  children: [
                    const Icon(Icons.campaign_rounded, color: AppTheme.accentOrange, size: 20),
                    const SizedBox(width: 8),
                    Text('Promoção',
                        style: theme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.accentOrange,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _precoPromocionalCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Preço Promocional',
                          prefixIcon: Icon(Icons.local_offer_rounded),
                          prefixText: 'R\$ ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final range = await showDateRangePicker(
                            context: context,
                            initialDateRange: _dataInicioPromocao != null && _dataFimPromocao != null
                                ? DateTimeRange(start: _dataInicioPromocao!, end: _dataFimPromocao!)
                                : null,
                            firstDate: DateTime.now().subtract(const Duration(days: 30)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            builder: (context, child) {
                              return Theme(
                                data: theme.copyWith(
                                  colorScheme: theme.colorScheme.copyWith(
                                    primary: AppTheme.accentOrange,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (range != null) {
                            setState(() {
                              _dataInicioPromocao = range.start;
                              _dataFimPromocao = range.end;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Vigência Promoção',
                            prefixIcon: Icon(Icons.date_range_rounded),
                          ),
                          child: Text(
                            _dataInicioPromocao != null && _dataFimPromocao != null
                                ? '${Formatters.date(_dataInicioPromocao!)} - ${Formatters.date(_dataFimPromocao!)}'
                                : 'Selecionar período',
                            style: TextStyle(
                              fontSize: 12,
                              color: _dataInicioPromocao != null ? Colors.white : Colors.white38,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // ─── Códigos ───
                Text('Códigos',
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _codigoBarrasCtrl,
                        decoration: InputDecoration(
                          labelText: 'Código de Barras',
                          prefixIcon: const Icon(Icons.qr_code_rounded),
                          suffixIcon: _lookingUp 
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                              )
                            : IconButton(
                                icon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
                                tooltip: 'Consultar base externa',
                                onPressed: _lookupExternal,
                              ),
                        ),
                        onFieldSubmitted: (_) => _lookupExternal(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _codigoInternoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Código Interno',
                          prefixIcon: Icon(Icons.tag_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // ─── Estoque e Unidade ───
                Text('Estoque e Unidade',
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _unidadeVenda,
                        decoration: const InputDecoration(
                          labelText: 'Unidade de Venda',
                          prefixIcon: Icon(Icons.straighten_rounded),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'UN', child: Text('UN - Unidade')),
                          DropdownMenuItem(value: 'KG', child: Text('KG - Quilograma')),
                          DropdownMenuItem(value: 'LT', child: Text('LT - Litro')),
                          DropdownMenuItem(value: 'MT', child: Text('MT - Metro')),
                          DropdownMenuItem(value: 'CX', child: Text('CX - Caixa')),
                          DropdownMenuItem(value: 'PC', child: Text('PC - Peça')),
                          DropdownMenuItem(value: 'FD', child: Text('FD - Fardo')),
                          DropdownMenuItem(value: 'PT', child: Text('PT - Pacote')),
                        ],
                        onChanged: (v) =>
                            setState(() => _unidadeVenda = v ?? 'UN'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _estoqueMinCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Estoque Mínimo',
                          prefixIcon: Icon(Icons.inventory_2_rounded),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // ─── Varejo e Validade ───
                Text('Varejo e Validade',
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _localizacaoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Localização (Aisle/Shelf)',
                          prefixIcon: Icon(Icons.location_on_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _dataVencimento ?? DateTime.now(),
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now().add(const Duration(days: 3650)),
                          );
                          if (date != null) {
                            setState(() => _dataVencimento = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Data de Vencimento',
                            prefixIcon: Icon(Icons.event_note_rounded),
                          ),
                          child: Text(
                            _dataVencimento != null
                                ? Formatters.date(_dataVencimento!)
                                : 'Selecionar data',
                            style: TextStyle(
                              color: _dataVencimento != null ? Colors.white : Colors.white38,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Controlar Estoque'),
                  subtitle: const Text(
                      'Ativar o controle de estoque para este produto'),
                  value: _controlarEstoque,
                  onChanged: (v) =>
                      setState(() => _controlarEstoque = v),
                  activeColor: AppTheme.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 24),
                // ─── Informações Fiscais ───
                Row(
                  children: [
                    const Icon(Icons.gavel_rounded, color: AppTheme.primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text('Informações Fiscais',
                        style: theme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _ncmCtrl,
                        decoration: const InputDecoration(
                          labelText: 'NCM (8 dígitos)',
                          hintText: 'Ex: 02013000',
                          prefixIcon: Icon(Icons.description_outlined),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _cestCtrl,
                        decoration: const InputDecoration(
                          labelText: 'CEST',
                          hintText: 'Ex: 1700100',
                          prefixIcon: Icon(Icons.inventory_rounded),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _origem,
                  decoration: const InputDecoration(
                    labelText: 'Origem da Mercadoria',
                    prefixIcon: Icon(Icons.language_rounded),
                  ),
                  items: const [
                    DropdownMenuItem(value: 0, child: Text('0 - Nacional')),
                    DropdownMenuItem(value: 1, child: Text('1 - Estrangeira - Importação direta')),
                    DropdownMenuItem(value: 2, child: Text('2 - Estrangeira - Adquirida no mercado interno')),
                  ],
                  onChanged: (v) => setState(() => _origem = v!),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cfopPadraoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'CFOP Padrão',
                          hintText: 'Ex: 5102',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _csosnPadraoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'CSOSN Padrão',
                          hintText: 'Ex: 102',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _cstPadraoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'CST Padrão',
                          hintText: 'Ex: 00',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Alíquotas Padrão (%)', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _icmsAliquotaCtrl,
                        decoration: const InputDecoration(labelText: 'ICMS'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _pisAliquotaCtrl,
                        decoration: const InputDecoration(labelText: 'PIS'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _cofinsAliquotaCtrl,
                        decoration: const InputDecoration(labelText: 'COFINS'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child:
                      CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Icon(isEdit ? Icons.save_rounded : Icons.add_rounded,
                  size: 18),
          label: Text(_saving
              ? 'Salvando...'
              : isEdit
                  ? 'Salvar Alterações'
                  : 'Cadastrar Produto'),
        ),
      ],
    );
  }
}
