import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/data/repositories/report_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';

class PerformanceProdutoDialog extends ConsumerWidget {
  final Produto product;

  const PerformanceProdutoDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reportRepo = ref.read(reportRepositoryProvider);

    return DefaultTabController(
      length: 2,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 700,
          constraints: const BoxConstraints(maxHeight: 600),
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.glassCard(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Informações Detalhadas', style: theme.textTheme.titleSmall?.copyWith(color: Colors.white70)),
                        Text(product.nome, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorColor: AppTheme.primaryColor,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                tabs: const [
                  Tab(text: 'Performance (6m)'),
                  Tab(text: 'Histórico de Auditoria'),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: TabBarView(
                  children: [
                    _PerformanceTab(repo: reportRepo, id: product.idProduto),
                    _AuditoriaTab(repo: reportRepo, id: product.idProduto),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PerformanceTab extends StatelessWidget {
  final ReportRepository repo;
  final int id;

  const _PerformanceTab({required this.repo, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: repo.getPerformanceProduto(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Sem dados de movimentação nos últimos 6 meses.', style: TextStyle(color: Colors.white54)),
          );
        }

        final data = snapshot.data!;
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 16),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _getMaxY(data),
                    barGroups: _buildBarGroups(data),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            if (val.toInt() >= data.length) return const Text('');
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                data[val.toInt()]['mes'],
                                style: const TextStyle(color: Colors.white54, fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend('Entradas', Colors.blueAccent),
                const SizedBox(width: 24),
                _buildLegend('Saídas', Colors.redAccent),
              ],
            ),
          ],
        );
      },
    );
  }

  double _getMaxY(List<Map<String, dynamic>> data) {
    double max = 0;
    for (var d in data) {
      if (d['entrada'] > max) max = (d['entrada'] as num).toDouble();
      if (d['saida'] > max) max = (d['saida'] as num).toDouble();
    }
    return max == 0 ? 10 : max * 1.2;
  }

  List<BarChartGroupData> _buildBarGroups(List<Map<String, dynamic>> data) {
    return List.generate(data.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: (data[i]['entrada'] as num).toDouble(),
            color: Colors.blueAccent,
            width: 12,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: (data[i]['saida'] as num).toDouble(),
            color: Colors.redAccent,
            width: 12,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _AuditoriaTab extends StatelessWidget {
  final ReportRepository repo;
  final int id;

  const _AuditoriaTab({required this.repo, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: repo.getAuditoriaEstoque(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Nenhuma movimentação registrada.',
                style: TextStyle(color: Colors.white54)),
          );
        }

        final data = snapshot.data!;
        final scrollController = ScrollController();
        return Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.2),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(0.8),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1.8),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white10))),
                  children: [
                    _headerCell('Data'),
                    _headerCell('Usuário'),
                    _headerCell('Lote'),
                    _headerCell('Op.'),
                    _headerCell('Qtd'),
                    _headerCell('Obs.'),
                  ],
                ),
                ...data.map((m) {
                  final date = DateTime.parse(m['data']);
                  return TableRow(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.white.withValues(alpha: 0.05)))),
                    children: [
                      _dataCell(Formatters.dateTime(date)),
                      _dataCell(m['usuario'], size: 11),
                      _dataCell(m['lote'] ?? '-',
                          size: 10, color: Colors.blueGrey),
                      _dataCell(m['tipo'].toString().toUpperCase(),
                          color: _getTipoColor(m['tipo']), size: 10),
                      _dataCell(Formatters.quantity(m['quantidade']),
                          bold: true, size: 11),
                      _dataCell(m['observacao'] ?? '-', size: 10),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _headerCell(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70, fontSize: 12)),
  );

  Widget _dataCell(String text, {Color? color, bool bold = false, double size = 12}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      style: TextStyle(
        color: color ?? Colors.white54,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
      ),
    ),
  );

  Color _getTipoColor(String tipo) {
    if (tipo.contains('entrada') || tipo.contains('compra')) return Colors.greenAccent;
    if (tipo.contains('saida') || tipo.contains('venda') || tipo.contains('perda')) return Colors.redAccent;
    return Colors.blueAccent;
  }
}
