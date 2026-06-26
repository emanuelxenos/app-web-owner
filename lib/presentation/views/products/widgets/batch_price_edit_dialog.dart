import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';
import 'package:unifytechxenoswebowner/presentation/providers/product_provider.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

class BatchPriceEditDialog extends ConsumerStatefulWidget {
  final List<Produto> products;

  const BatchPriceEditDialog({super.key, required this.products});

  @override
  ConsumerState<BatchPriceEditDialog> createState() => _BatchPriceEditDialogState();
}

class _BatchPriceEditDialogState extends ConsumerState<BatchPriceEditDialog> {
  final List<Map<String, dynamic>> _updates = [];
  final _globalValueCtrl = TextEditingController();
  String _globalTarget = 'venda'; // 'venda' ou 'custo'
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    for (var p in widget.products) {
      _updates.add({
        'id_produto': p.idProduto,
        'nome': p.nome,
        'preco_custo': p.precoCusto,
        'preco_venda': p.precoVenda,
        'custo_controller': TextEditingController(text: p.precoCusto.toStringAsFixed(2)),
        'venda_controller': TextEditingController(text: p.precoVenda.toStringAsFixed(2)),
      });
    }
  }

  @override
  void dispose() {
    for (var u in _updates) {
      u['custo_controller'].dispose();
      u['venda_controller'].dispose();
    }
    _globalValueCtrl.dispose();
    super.dispose();
  }

  void _applyGlobalAdjustment() {
    final value = double.tryParse(_globalValueCtrl.text.replaceAll(',', '.')) ?? 0;
    if (value == 0) return;

    setState(() {
      for (var u in _updates) {
        double current = _globalTarget == 'venda' ? u['preco_venda'] : u['preco_custo'];
        double newValue = current * (1 + (value / 100));
        
        if (_globalTarget == 'venda') {
          u['preco_venda'] = newValue;
          u['venda_controller'].text = newValue.toStringAsFixed(2);
        } else {
          u['preco_custo'] = newValue;
          u['custo_controller'].text = newValue.toStringAsFixed(2);
        }
      }
    });
  }

  double _calculateMargin(double cost, double sale) {
    if (sale == 0) return 0;
    return ((sale - cost) / sale) * 100;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    
    final payload = _updates.map((u) => {
      'id_produto': u['id_produto'],
      'preco_custo': u['preco_custo'],
      'preco_venda': u['preco_venda'],
    }).toList();

    final (success, message) = await ref.read(productsProvider.notifier).atualizarPrecosLote(payload);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppTheme.accentGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppTheme.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 900,
        height: 700,
        decoration: AppTheme.glassCard(),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Icon(Icons.price_change_rounded, color: AppTheme.primaryColor, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reajuste de Preços em Massa', style: theme.textTheme.headlineSmall),
                        Text('${widget.products.length} produtos selecionados', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10, height: 1),

            // Global Adjustment Toolbar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: AppTheme.primaryColor.withValues(alpha: 0.05),
              child: Row(
                children: [
                  const Text('Ajuste Global:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _globalValueCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Porcentagem',
                        suffixText: '%',
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('em'),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _globalTarget,
                    dropdownColor: const Color(0xFF1C2039),
                    style: const TextStyle(color: Colors.white),
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(value: 'venda', child: Text('Preço de Venda')),
                      DropdownMenuItem(value: 'custo', child: Text('Preço de Custo')),
                    ],
                    onChanged: (v) => setState(() => _globalTarget = v!),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _applyGlobalAdjustment,
                    icon: const Icon(Icons.bolt_rounded, size: 18),
                    label: const Text('Aplicar em Todos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // Table
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(1),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    // Header Row
                    TableRow(
                      children: [
                        _buildTableHeader('Produto'),
                        _buildTableHeader('P. Custo (R\$)'),
                        _buildTableHeader('P. Venda (R\$)'),
                        _buildTableHeader('Margem'),
                      ],
                    ),
                    // Data Rows
                    ...List.generate(_updates.length, (index) {
                      final u = _updates[index];
                      final margin = _calculateMargin(u['preco_custo'], u['preco_venda']);
                      
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(u['nome'], style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: TextField(
                              controller: u['custo_controller'],
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 13),
                              decoration: const InputDecoration(isDense: true),
                              onChanged: (v) {
                                setState(() {
                                  u['preco_custo'] = double.tryParse(v.replaceAll(',', '.')) ?? 0;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: TextField(
                              controller: u['venda_controller'],
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 13),
                              decoration: const InputDecoration(isDense: true),
                              onChanged: (v) {
                                setState(() {
                                  u['preco_venda'] = double.tryParse(v.replaceAll(',', '.')) ?? 0;
                                });
                              },
                            ),
                          ),
                          Center(
                            child: Text(
                              '${margin.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: margin < 0 ? AppTheme.accentRed : AppTheme.accentGreen,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Footer
            const Divider(color: Colors.white10, height: 1),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    child: _isSaving 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Salvar Todos os Preços'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
