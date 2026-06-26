import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';
import 'package:unifytechxenoswebowner/domain/models/purchase.dart';
import 'package:unifytechxenoswebowner/domain/models/supplier.dart';
import 'package:unifytechxenoswebowner/presentation/providers/product_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/purchase_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/supplier_provider.dart';

class PurchaseFormDialog extends ConsumerStatefulWidget {
  const PurchaseFormDialog({super.key});

  @override
  ConsumerState<PurchaseFormDialog> createState() => _PurchaseFormDialogState();
}

class _PurchaseFormDialogState extends ConsumerState<PurchaseFormDialog> {
  Fornecedor? _selectedSupplier;
  final List<_CartItem> _items = [];
  final _invoiceCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  bool _saving = false;

  double get _total => _items.fold(0, (sum, item) => sum + (item.quantity * item.costPrice));

  @override
  void dispose() {
    _invoiceCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _addProduct(Produto product) {
    setState(() {
      final index = _items.indexWhere((i) => i.product.idProduto == product.idProduto);
      if (index >= 0) {
        _items[index].quantity += 1;
      } else {
        _items.add(_CartItem(
          product: product,
          quantity: 1,
          costPrice: product.precoCusto,
          localizacao: product.localizacao ?? '',
          dataVencimento: product.dataVencimento != null ? Formatters.date(product.dataVencimento!) : '',
          lote: '',
        ));
      }
    });
  }

  Future<void> _save() async {
    if (_selectedSupplier == null || _items.isEmpty) return;
    
    setState(() => _saving = true);
    
    final request = CriarCompraRequest(
      fornecedorId: _selectedSupplier!.idFornecedor,
      numeroNotaFiscal: _invoiceCtrl.text.isEmpty ? 'SIMPLES' : _invoiceCtrl.text,
      dataEmissao: DateTime.now().toIso8601String().split('T')[0],
      itens: _items.map((i) => CriarItemCompraRequest(
        produtoId: i.product.idProduto,
        quantidade: i.quantity,
        precoUnitario: i.costPrice,
        localizacao: i.localizacao,
        dataVencimento: i.dataVencimento.isNotEmpty 
            ? Formatters.dateToIso(i.dataVencimento) 
            : null,
        lote: i.lote,
      )).toList(),
    );

    final (success, message) = await ref.read(purchaseActionsProvider.notifier).criar(request);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppTheme.accentGreen),
        );
      } else {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppTheme.accentRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suppliers = ref.watch(suppliersProvider).maybeWhen(data: (d) => d, orElse: () => <Fornecedor>[]);
    final products = ref.watch(filteredProductsProvider);

    return AlertDialog(
      title: const Text('Nova Compra'),
      content: SizedBox(
        width: 1100, // Increased width for better data entry
        height: 650,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Side: Cart & Details
            Expanded(
              flex: 4, // More space for the cart
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<Fornecedor>(
                          value: _selectedSupplier,
                          decoration: const InputDecoration(labelText: 'Fornecedor *', isDense: true),
                          items: suppliers.map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.razaoSocial),
                          )).toList(),
                          onChanged: (v) => setState(() => _selectedSupplier = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _invoiceCtrl,
                          decoration: const InputDecoration(labelText: 'Nº Nota Fiscal', isDense: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Itens da Compra', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  Expanded(
                    child: _items.isEmpty 
                      ? const Center(child: Text('Nenhum item adicionado'))
                      : ListView.separated(
                          controller: ScrollController(),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                              child: Row(
                                children: [
                                  // Product Info
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.product.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                        Text('ID: ${item.product.idProduto}', style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Inputs Row
                                  Expanded(
                                    flex: 8,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            initialValue: item.quantity.toString(),
                                            decoration: const InputDecoration(labelText: 'Qtd', isDense: true),
                                            style: const TextStyle(fontSize: 13),
                                            keyboardType: TextInputType.number,
                                            onChanged: (v) => setState(() => item.quantity = double.tryParse(v) ?? 0),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                            initialValue: item.costPrice.toString(),
                                            decoration: const InputDecoration(labelText: 'Custo Un.', prefixText: 'R\$', isDense: true),
                                            style: const TextStyle(fontSize: 13),
                                            keyboardType: TextInputType.number,
                                            onChanged: (v) => setState(() => item.costPrice = double.tryParse(v) ?? 0),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                            initialValue: item.localizacao,
                                            decoration: const InputDecoration(labelText: 'Localização', isDense: true),
                                            style: const TextStyle(fontSize: 13),
                                            onChanged: (v) => setState(() => item.localizacao = v),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                            controller: TextEditingController(text: item.dataVencimento),
                                            readOnly: true,
                                            style: const TextStyle(fontSize: 13),
                                            decoration: const InputDecoration(
                                              labelText: 'Validade',
                                              suffixIcon: Icon(Icons.calendar_today, size: 14),
                                              isDense: true,
                                            ),
                                            onTap: () async {
                                              final date = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                                lastDate: DateTime.now().add(const Duration(days: 3650)),
                                              );
                                              if (date != null) {
                                                setState(() => item.dataVencimento = Formatters.date(date));
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 3,
                                          child: TextFormField(
                                            initialValue: item.lote,
                                            decoration: const InputDecoration(labelText: 'Lote', isDense: true),
                                            style: const TextStyle(fontSize: 13),
                                            onChanged: (v) => setState(() => item.lote = v),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: AppTheme.accentRed, size: 20),
                                          onPressed: () => setState(() => _items.removeAt(index)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TOTAL DA COMPRA:', style: theme.textTheme.titleLarge),
                      Text(Formatters.currency(_total), style: theme.textTheme.headlineSmall?.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 32),
            // Right Side: Product Search
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => ref.read(productSearchProvider.notifier).setQuery(v),
                    decoration: const InputDecoration(
                      hintText: 'Pesquisar produto...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: products.when(
                      data: (items) => ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final p = items[index];
                          return ListTile(
                            title: Text(p.nome),
                            subtitle: Text('Estoque: ${p.estoqueAtual}'),
                            trailing: const Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
                            onTap: () => _addProduct(p),
                          );
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Erro: $e')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: _saving ? null : _save, 
          child: _saving ? const CircularProgressIndicator() : const Text('Finalizar Compra'),
        ),
      ],
    );
  }
}

class _CartItem {
  final Produto product;
  double quantity;
  double costPrice;
  String localizacao;
  String dataVencimento;
  String lote;

  _CartItem({
    required this.product,
    required this.quantity,
    required this.costPrice,
    this.localizacao = '',
    this.dataVencimento = '',
    this.lote = '',
  });
}
