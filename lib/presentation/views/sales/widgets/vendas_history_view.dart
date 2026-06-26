import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/domain/models/sale.dart';
import 'package:unifytechxenoswebowner/presentation/providers/sale_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/presentation/views/sales/widgets/sales_shared_widgets.dart';
import 'package:unifytechxenoswebowner/presentation/views/sales/widgets/venda_detail_modal.dart';

class VendasHistoryView extends ConsumerStatefulWidget {
  const VendasHistoryView({super.key});
  @override
  ConsumerState<VendasHistoryView> createState() => _VendasHistoryViewState();
}

class _VendasHistoryViewState extends ConsumerState<VendasHistoryView> {
  DateTime _inicio = DateTime.now();
  DateTime _fim = DateTime.now();
  final _scrollCtrl = ScrollController();
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'Todos';

  String get _inicioStr => _inicio.toString().split(' ')[0];
  String get _fimStr => _fim.toString().split(' ')[0];

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final salesAsync = ref.watch(salesHistoryProvider(inicio: _inicioStr, fim: _fimStr));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildViewHeader(
          title: 'Histórico de Vendas',
          icon: Icons.receipt_long_rounded,
          actions: [
            DateRangeButton(
              inicio: _inicio,
              fim: _fim,
              onChanged: (start, end) => setState(() {
                _inicio = start;
                _fim = end;
              }),
            ),
            const SizedBox(width: 12),
            IconButton.outlined(
              onPressed: () => ref.read(salesHistoryProvider(inicio: _inicioStr, fim: _fimStr).notifier).refresh(),
              icon: const Icon(Icons.refresh, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: salesAsync.when(
            loading: () => const LoadingOverlay(message: 'Buscando vendas...'),
            error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
            data: (vendas) {
              if (vendas.isEmpty) {
                return const EmptyState(icon: Icons.receipt_long_outlined, title: 'Nenhuma venda neste período');
              }

              // Filtros
              var filtered = vendas.where((v) {
                final matchBusca = v.numeroVenda.toLowerCase().contains(_searchQuery) ||
                    (v.operadorNome?.toLowerCase().contains(_searchQuery) ?? false);
                final matchStatus = _statusFilter == 'Todos' ||
                    (_statusFilter == 'Concluída' && v.status != 'cancelada') ||
                    (_statusFilter == 'Cancelada' && v.status == 'cancelada');
                return matchBusca && matchStatus;
              }).toList();

              final concluidas = filtered.where((v) => v.status != 'cancelada').toList();
              final total = concluidas.fold(0.0, (s, v) => s + v.valorTotal);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // KPIs
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      MiniKpi(title: 'Total Pago', value: Formatters.currency(total), color: AppTheme.accentGreen),
                      MiniKpi(title: 'Qtd Vendas', value: '${concluidas.length}', color: AppTheme.primaryColor),
                      MiniKpi(title: 'Canceladas', value: '${filtered.length - concluidas.length}', color: AppTheme.accentRed),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Gráfico
                  if (concluidas.isNotEmpty) ...[
                    Container(
                      height: 220,
                      padding: const EdgeInsets.all(16),
                      decoration: AppTheme.glassCard(),
                      child: _buildSalesChart(concluidas),
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Barra de Busca e Filtros
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _searchCtrl,
                          decoration: InputDecoration(
                            hintText: 'Buscar por Nº da Venda ou Operador...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: theme.cardColor.withValues(alpha: 0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownMenu<String>(
                        initialSelection: 'Todos',
                        onSelected: (val) => setState(() => _statusFilter = val ?? 'Todos'),
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: theme.cardColor.withValues(alpha: 0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'Todos', label: 'Todos os Status'),
                          DropdownMenuEntry(value: 'Concluída', label: 'Somente Concluídas'),
                          DropdownMenuEntry(value: 'Cancelada', label: 'Somente Canceladas'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tabela
                  Expanded(
                    child: Container(
                      decoration: AppTheme.glassCard(),
                      clipBehavior: Clip.antiAlias,
                      child: filtered.isEmpty
                          ? const EmptyState(icon: Icons.search_off_rounded, title: 'Nenhuma venda encontrada')
                          : _buildSalesTable(filtered, theme),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSalesChart(List<Venda> vendas) {
    final map = <int, double>{};
    for (var v in vendas) {
      final day = v.dataVenda.day;
      map[day] = (map[day] ?? 0) + v.valorTotal;
    }

    if (map.isEmpty) return const Center(child: Text('Sem dados'));

    final spots = map.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
    spots.sort((a, b) => a.x.compareTo(b.x));

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('${value.toInt()}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesTable(List<Venda> vendas, ThemeData theme) {
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollCtrl,
          child: DataTable(
            showCheckboxColumn: false,
            columns: const [
              DataColumn(label: Text('Nº VENDA')),
              DataColumn(label: Text('DATA/HORA')),
              DataColumn(label: Text('OPERADOR')),
              DataColumn(label: Text('CAIXA')),
              DataColumn(label: Text('VALOR'), numeric: true),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('DETALHES')),
            ],
            rows: vendas.map((v) => DataRow(
              cells: [
                DataCell(Text(v.numeroVenda, style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(Text(Formatters.dateTime(v.dataVenda))),
                DataCell(Text(v.operadorNome ?? '-')),
                DataCell(Text(v.caixaNome ?? '-')),
                DataCell(Text(Formatters.currency(v.valorTotal), style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(StatusChip.fromStatus(v.status)),
                DataCell(IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  onPressed: () => showVendaDetail(context, v),
                )),
              ],
            )).toList(),
          ),
        ),
      ),
    );
  }
}
