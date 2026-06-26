import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/domain/models/customer.dart';
import 'package:unifytechxenoswebowner/domain/models/sale.dart';
import 'package:unifytechxenoswebowner/presentation/providers/customer_provider.dart';
import 'package:unifytechxenoswebowner/presentation/views/customers/widgets/pagar_venda_dialog.dart';

class CustomerHistoryDialog extends ConsumerStatefulWidget {
  final Cliente cliente;
  const CustomerHistoryDialog({super.key, required this.cliente});

  @override
  ConsumerState<CustomerHistoryDialog> createState() => _CustomerHistoryDialogState();
}

class _CustomerHistoryDialogState extends ConsumerState<CustomerHistoryDialog> {
  Venda? _selectedVenda;
  String _searchQuery = '';
  DateTimeRange? _dateRange;
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyQuickDateFilter(String filter) {
    final now = DateTime.now();
    setState(() {
      _currentPage = 1;
      if (filter == 'Tudo') {
        _dateRange = null;
      } else if (filter == 'Hoje') {
        _dateRange = DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: DateTime(now.year, now.month, now.day),
        );
      } else if (filter == '30d') {
        _dateRange = DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );
      }
    });
  }

  Future<void> _selectCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Color(0xFF1C2039),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF15182C),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _currentPage = 1;
        _dateRange = picked;
      });
    }
  }

  String _getActiveShortcut() {
    if (_dateRange == null) return 'Tudo';
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    if (_dateRange!.start == todayStart && _dateRange!.end == todayStart) return 'Hoje';
    final thirtyDaysAgo = todayStart.subtract(const Duration(days: 30));
    if (_dateRange!.start.day == thirtyDaysAgo.day &&
        _dateRange!.start.month == thirtyDaysAgo.month &&
        _dateRange!.start.year == thirtyDaysAgo.year) return '30d';
    return 'Custom';
  }

  Widget _buildShortcutBtn(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryColor.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppTheme.primaryColor : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppTheme.primaryColor : Colors.white70,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(customerHistoryProvider(widget.cliente.idCliente));
    final amortizationsAsync = ref.watch(customerAmortizationsProvider(widget.cliente.idCliente));

    return AlertDialog(
      backgroundColor: const Color(0xFF1C2039),
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.account_box_rounded, color: AppTheme.primaryColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Histórico Financeiro - ${widget.cliente.nome}',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white54),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
      content: SizedBox(
        width: 1080,
        height: 620,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // LEFT COLUMN: Purchases list & filters
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.white10)),
                ),
                child: historyAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Text('Erro: $e', style: const TextStyle(color: AppTheme.accentRed)),
                  ),
                  data: (vendas) {
                    // Filter purchases
                    List<Venda> filtered = vendas;
                    if (_searchQuery.isNotEmpty) {
                      filtered = filtered
                          .where((v) => v.numeroVenda.toLowerCase().contains(_searchQuery.toLowerCase()))
                          .toList();
                    }
                    if (_dateRange != null) {
                      filtered = filtered.where((v) {
                        final date = DateTime(v.dataVenda.year, v.dataVenda.month, v.dataVenda.day);
                        final start = DateTime(_dateRange!.start.year, _dateRange!.start.month, _dateRange!.start.day);
                        final end = DateTime(_dateRange!.end.year, _dateRange!.end.month, _dateRange!.end.day);
                        return (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
                            (date.isBefore(end) || date.isAtSameMomentAs(end));
                      }).toList();
                    }

                    // Paginate
                    final int totalItems = filtered.length;
                    final int totalPages = (totalItems / _itemsPerPage).ceil();
                    if (_currentPage > totalPages && totalPages > 0) {
                      _currentPage = totalPages;
                    }
                    final int startIdx = (_currentPage - 1) * _itemsPerPage;
                    int endIdx = startIdx + _itemsPerPage;
                    if (endIdx > totalItems) endIdx = totalItems;
                    final paginated = totalItems > 0 ? filtered.sublist(startIdx, endIdx) : <Venda>[];

                    // Resolve selection dynamically from fresh list
                    Venda? activeVenda;
                    if (_selectedVenda != null) {
                      activeVenda = vendas.firstWhere(
                        (v) => v.idVenda == _selectedVenda!.idVenda,
                        orElse: () => _selectedVenda!,
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar
                        TextField(
                          controller: _searchCtrl,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Buscar pelo número da venda...',
                            hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                            prefixIcon: const Icon(Icons.search, color: Colors.white30, size: 18),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.white54, size: 16),
                                    onPressed: () {
                                      _searchCtrl.clear();
                                      setState(() {
                                        _searchQuery = '';
                                        _currentPage = 1;
                                      });
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                              _currentPage = 1;
                            });
                          },
                        ),
                        const SizedBox(height: 12),

                        // Date filters shortcuts
                        Row(
                          children: [
                            _buildShortcutBtn('Tudo', _getActiveShortcut() == 'Tudo', () => _applyQuickDateFilter('Tudo')),
                            const SizedBox(width: 8),
                            _buildShortcutBtn('Hoje', _getActiveShortcut() == 'Hoje', () => _applyQuickDateFilter('Hoje')),
                            const SizedBox(width: 8),
                            _buildShortcutBtn('Últimos 30d', _getActiveShortcut() == '30d', () => _applyQuickDateFilter('30d')),
                            const SizedBox(width: 8),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.calendar_month_rounded,
                                color: _getActiveShortcut() == 'Custom' ? AppTheme.primaryColor : Colors.white54,
                                size: 20,
                              ),
                              onPressed: _selectCustomDateRange,
                              tooltip: 'Selecionar Período Personalizado',
                              style: IconButton.styleFrom(
                                backgroundColor: _getActiveShortcut() == 'Custom'
                                    ? AppTheme.primaryColor.withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.05),
                                padding: const EdgeInsets.all(8),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Compras e Dívidas (${filtered.length})',
                          style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        // Purchases list
                        Expanded(
                          child: filtered.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.white.withValues(alpha: 0.1)),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Nenhuma compra encontrada.',
                                        style: TextStyle(color: Colors.white30, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: paginated.length,
                                  itemBuilder: (context, idx) {
                                    final v = paginated[idx];
                                    final saldo = v.valorTotal - v.valorPago;
                                    final isSelected = activeVenda?.idVenda == v.idVenda;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedVenda = v;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 150),
                                        margin: const EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppTheme.primaryColor.withValues(alpha: 0.12)
                                              : Colors.white.withValues(alpha: 0.03),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelected ? AppTheme.primaryColor : Colors.white.withValues(alpha: 0.08),
                                            width: isSelected ? 1.5 : 1.0,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 18,
                                                backgroundColor: v.status == 'concluida'
                                                    ? (saldo > 0
                                                        ? Colors.orange.withValues(alpha: 0.15)
                                                        : Colors.green.withValues(alpha: 0.15))
                                                    : AppTheme.accentRed.withValues(alpha: 0.15),
                                                child: Icon(
                                                  v.status == 'concluida'
                                                      ? (saldo > 0 ? Icons.warning_amber_rounded : Icons.check_circle_outline)
                                                      : Icons.cancel_outlined,
                                                  size: 18,
                                                  color: v.status == 'concluida'
                                                      ? (saldo > 0 ? Colors.orange : Colors.green)
                                                      : AppTheme.accentRed,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Compra #${v.numeroVenda}',
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Text(
                                                          'R\$ ${v.valorTotal.toStringAsFixed(2)}',
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${v.dataVenda.day.toString().padLeft(2, '0')}/${v.dataVenda.month.toString().padLeft(2, '0')}/${v.dataVenda.year} ${v.dataVenda.hour.toString().padLeft(2, '0')}:${v.dataVenda.minute.toString().padLeft(2, '0')}',
                                                          style: const TextStyle(
                                                            color: Colors.white38,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                        if (v.status == 'concluida')
                                                          Text(
                                                            saldo > 0
                                                                ? 'Pendente: R\$ ${saldo.toStringAsFixed(2)}'
                                                                : 'Quitado',
                                                            style: TextStyle(
                                                              color: saldo > 0 ? Colors.orange : Colors.green,
                                                              fontSize: 11,
                                                              fontWeight: saldo > 0 ? FontWeight.w500 : FontWeight.bold,
                                                            ),
                                                          )
                                                        else
                                                          const Text(
                                                            'Cancelada',
                                                            style: TextStyle(
                                                              color: AppTheme.accentRed,
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),

                        // Pagination UI
                        _buildPaginationControls(totalPages),
                      ],
                    );
                  },
                ),
              ),
            ),

            // RIGHT COLUMN: Selected purchase details & installments
            Expanded(
              flex: 5,
              child: Container(
                color: const Color(0xFF15182C),
                padding: const EdgeInsets.all(20.0),
                child: historyAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (vendas) {
                    Venda? activeVenda;
                    if (_selectedVenda != null) {
                      activeVenda = vendas.firstWhere(
                        (v) => v.idVenda == _selectedVenda!.idVenda,
                        orElse: () => _selectedVenda!,
                      );
                    }

                    if (activeVenda == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.payments_outlined,
                              size: 64,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Detalhes do Registro',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Selecione uma compra à esquerda para visualizar\no histórico de pagamentos e amortizações.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white30,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final saldo = activeVenda.valorTotal - activeVenda.valorPago;
                    final isPendente = saldo > 0 && activeVenda.status == 'concluida';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Details Summary
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Compra #${activeVenda.numeroVenda}',
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: activeVenda.status == 'concluida'
                                    ? (saldo > 0
                                        ? Colors.orange.withValues(alpha: 0.15)
                                        : Colors.green.withValues(alpha: 0.15))
                                    : AppTheme.accentRed.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                activeVenda.status == 'concluida'
                                    ? (saldo > 0 ? 'PENDENTE' : 'QUITADO')
                                    : 'CANCELADA',
                                style: TextStyle(
                                  color: activeVenda.status == 'concluida'
                                      ? (saldo > 0 ? Colors.orange : Colors.green)
                                      : AppTheme.accentRed,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // System details
                        Text(
                          'Realizada em: ${activeVenda.dataVenda.day.toString().padLeft(2, '0')}/${activeVenda.dataVenda.month.toString().padLeft(2, '0')}/${activeVenda.dataVenda.year} às ${activeVenda.dataVenda.hour.toString().padLeft(2, '0')}:${activeVenda.dataVenda.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                        if (activeVenda.operadorNome != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Operador: ${activeVenda.operadorNome} | Caixa: ${activeVenda.caixaNome ?? 'N/A'}',
                            style: const TextStyle(color: Colors.white38, fontSize: 12),
                          ),
                        ],
                        const SizedBox(height: 20),

                        // Cards Panel for Total / Paid / Balance
                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailMetricCard(
                                'Valor Total',
                                'R\$ ${activeVenda.valorTotal.toStringAsFixed(2)}',
                                Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildDetailMetricCard(
                                'Valor Pago',
                                'R\$ ${activeVenda.valorPago.toStringAsFixed(2)}',
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildDetailMetricCard(
                                'Saldo Restante',
                                'R\$ ${saldo.toStringAsFixed(2)}',
                                saldo > 0 ? Colors.orange : Colors.white54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Pay Button if pending
                        if (isPendente) ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (_) => PagarVendaDialog(cliente: widget.cliente, venda: activeVenda!),
                              ),
                              icon: const Icon(Icons.payment_outlined, size: 18),
                              label: const Text('Registrar Amortização / Pagamento', style: TextStyle(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],

                        const Divider(color: Colors.white10),
                        const SizedBox(height: 12),

                        const Text(
                          'Amortizações e Pagamentos Realizados',
                          style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        // Payments List
                        Expanded(
                          child: amortizationsAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (err, _) => Center(
                              child: Text('Erro: $err', style: const TextStyle(color: AppTheme.accentRed)),
                            ),
                            data: (amortizations) {
                              final specificAmorts = amortizations.where((p) => p.vendaId == activeVenda!.idVenda).toList();

                              if (specificAmorts.isEmpty) {
                                return Center(
                                  child: Text(
                                    activeVenda!.valorPago >= activeVenda.valorTotal
                                        ? 'Compra quitada no ato da venda.'
                                        : 'Nenhum pagamento amortizado registrado.',
                                    style: const TextStyle(color: Colors.white30, fontSize: 12, fontStyle: FontStyle.italic),
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: specificAmorts.length,
                                itemBuilder: (context, idx) {
                                  final pag = specificAmorts[idx];
                                  return Card(
                                    color: Colors.white.withValues(alpha: 0.04),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: Colors.white.withValues(alpha: 0.03)),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      leading: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                                        child: const Icon(Icons.receipt_long, color: AppTheme.primaryColor, size: 16),
                                      ),
                                      title: Text(
                                        '+ R\$ ${pag.valor.toStringAsFixed(2)}',
                                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      subtitle: Text(
                                        'Recebido em: ${pag.dataPagamento.day.toString().padLeft(2, '0')}/${pag.dataPagamento.month.toString().padLeft(2, '0')}/${pag.dataPagamento.year} às ${pag.dataPagamento.hour.toString().padLeft(2, '0')}:${pag.dataPagamento.minute.toString().padLeft(2, '0')}\nRecebido por: ${pag.usuarioNome}',
                                        style: const TextStyle(color: Colors.white38, fontSize: 11),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailMetricCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF24294B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    if (totalPages <= 1) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 14),
            label: const Text('Anterior', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(
              foregroundColor: _currentPage > 1 ? AppTheme.primaryColor : Colors.white24,
            ),
          ),
          Text(
            'Pág $_currentPage de $totalPages',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          TextButton.icon(
            onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            label: const Text('Próxima', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(
              foregroundColor: _currentPage < totalPages ? AppTheme.primaryColor : Colors.white24,
            ),
          ),
        ],
      ),
    );
  }
}
