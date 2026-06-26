import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/finance_provider.dart';
import 'package:unifytechxenoswebowner/presentation/views/finance/widgets/date_filter_button.dart';
import 'package:unifytechxenoswebowner/presentation/views/finance/widgets/finance_tabs.dart';
import 'package:unifytechxenoswebowner/presentation/views/finance/widgets/finance_pagination_bar.dart';
import 'package:unifytechxenoswebowner/presentation/views/finance/widgets/manual_entry_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/domain/models/caixa.dart';
import 'package:file_picker/file_picker.dart';
import 'package:unifytechxenoswebowner/data/repositories/report_repository.dart';
import 'package:unifytechxenoswebowner/presentation/views/finance/widgets/finance_help_dialog.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});
  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchCtrl = TextEditingController();
  bool _isExporting = false;
  final _pagarController = ScrollController();
  final _receberController = ScrollController();
  final _fluxoController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pagarController.dispose();
    _receberController.dispose();
    _fluxoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fluxoChartAsync = ref.watch(chartCashFlowProvider);
    final filters = ref.watch(financialFiltersProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: FinancePaginationBar(tabController: _tabController),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, ref, theme, filters),
                  const SizedBox(height: 24),
                  fluxoChartAsync.when(
                    loading: () => const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => const SizedBox.shrink(),
                    data: (respPaginated) {
                      final resp = respPaginated.data.first;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: KpiCard(
                                  title: 'Entradas Totais',
                                  value: Formatters.currency(resp.totalEntrada),
                                  icon: Icons.trending_up,
                                  color: AppTheme.accentGreen,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: KpiCard(
                                  title: 'Saídas Totais',
                                  value: Formatters.currency(resp.totalSaida),
                                  icon: Icons.trending_down,
                                  color: AppTheme.accentRed,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: KpiCard(
                                  title: 'Saldo no Período',
                                  value: Formatters.currency(resp.saldo),
                                  icon: Icons.account_balance_wallet,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: MiniKpiCard(
                                  title: 'A Receber (Nesta pág)',
                                  value:
                                      ref
                                          .watch(accountsReceivableProvider)
                                          .valueOrNull
                                          ?.data
                                          .where((e) => e.status == 'aberta')
                                          .fold(
                                            0.0,
                                            (sum, e) => sum! + e.valorOriginal,
                                          ) ??
                                      0.0,
                                  color: AppTheme.accentGreen.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: MiniKpiCard(
                                  title: 'A Pagar (Nesta pág)',
                                  value:
                                      ref
                                          .watch(accountsPayableProvider)
                                          .valueOrNull
                                          ?.data
                                          .where((e) => e.status == 'aberta')
                                          .fold(
                                            0.0,
                                            (sum, e) => sum! + e.valorOriginal,
                                          ) ??
                                      0.0,
                                  color: AppTheme.accentRed.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Spacer(), // Placeholder para alinhamento
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildChartCard(resp),
                          const SizedBox(height: 24),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: const Color(
                    0xFF0D1117,
                  ).withOpacity(0.8), // Fundo para a aba fixada
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                      tabs: const [
                        Tab(text: 'Contas a Pagar'),
                        Tab(text: 'Contas a Receber'),
                        Tab(text: 'Extrato de Fluxo'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          body: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TabBarView(
              controller: _tabController,
              children: [
                ContasPagarTab(controller: _pagarController),
                ContasReceberTab(controller: _receberController),
                FluxoCaixaTab(controller: _fluxoController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    ({DateTime? start, DateTime? end}) filters,
  ) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Gestão Financeira 360º',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Gestão administrativa completa: automático + manual',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DateFilterButton(filters: filters),
            IconButton.filled(
              onPressed: () {
                ref.read(cashFlowProvider.notifier).refresh();
                ref.read(accountsPayableProvider.notifier).refresh();
                ref.read(accountsReceivableProvider.notifier).refresh();
              },
              icon: const Icon(Icons.refresh),
              tooltip: 'Atualizar Dados',
            ),
            IconButton.outlined(
              onPressed: () => _export(context, ref, 'xlsx'),
              icon: const Icon(Icons.table_view_rounded, color: Colors.green),
              tooltip: 'Exportar Excel',
            ),
            const SizedBox(width: 12),
            IconButton.outlined(
              onPressed: () => _export(context, ref, 'pdf'),
              icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.red),
              tooltip: 'Exportar PDF',
            ),
            IconButton.outlined(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const FinanceHelpDialog(),
              ),
              icon: const Icon(Icons.help_outline_rounded, color: Colors.blue),
              tooltip: 'Manual do Financeiro',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartCard(FluxoCaixaResponse resp) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tendência de Caixa',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: resp.items.isEmpty
                ? const Center(
                    child: Text(
                      'Sem dados suficientes para o gráfico',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : _FinanceBarChart(items: resp.items),
          ),
        ],
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context, {required bool isPagar}) {
    showDialog(
      context: context,
      builder: (context) => ManualEntryDialog(isPagar: isPagar),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref, String ext) async {
    final filters = ref.read(financialFiltersProvider);
    final path = await FilePicker.saveFile(
      dialogTitle: 'Salvar Extrato Financeiro',
      fileName: 'extrato_financeiro.$ext',
      allowedExtensions: [ext],
      type: FileType.custom,
    );
    if (path == null) return;

    setState(() => _isExporting = true);
    final queryParams = {
      if (filters.start != null)
        'data_inicio': filters.start!.toString().split(' ')[0],
      if (filters.end != null)
        'data_fim': filters.end!.toString().split(' ')[0],
    };
    try {
      await ref
          .read(reportRepositoryProvider)
          .exportarRelatorio(ext, path, 'financeiro', params: queryParams);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Exportado com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro: $e',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }
}

class MiniKpiCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  const MiniKpiCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2039),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            Formatters.currency(value),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinanceBarChart extends StatelessWidget {
  final List<FluxoCaixaItem> items;
  const _FinanceBarChart({required this.items});

  @override
  Widget build(BuildContext context) {
    // Agrupar por data para o gráfico (Separando Entradas e Saídas)
    final Map<String, ({double inVal, double outVal})> dataPoints = {};
    for (var item in items) {
      final key = item.data.toString().split(' ')[0];
      final curr = dataPoints[key] ?? (inVal: 0.0, outVal: 0.0);
      if (item.valor >= 0) {
        dataPoints[key] = (inVal: curr.inVal + item.valor, outVal: curr.outVal);
      } else {
        dataPoints[key] = (
          inVal: curr.inVal,
          outVal: curr.outVal + item.valor.abs(),
        );
      }
    }

    final sortedKeys = dataPoints.keys.toList()..sort();
    final List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < sortedKeys.length; i++) {
      final dp = dataPoints[sortedKeys[i]]!;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: dp.inVal,
              color: AppTheme.accentGreen,
              width: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            BarChartRodData(
              toY: dp.outVal,
              color: AppTheme.accentRed,
              width: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    if (barGroups.isEmpty) return const SizedBox.shrink();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF1C2039),
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                Formatters.currency(rod.toY),
                TextStyle(color: rod.color, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, meta) {
                if (val.toInt() >= 0 && val.toInt() < sortedKeys.length) {
                  final date = DateTime.parse(sortedKeys[val.toInt()]);
                  return Text(
                    '${date.day}/${date.month}',
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);
  final Widget _tabBar;

  @override
  double get minExtent => 64;
  @override
  double get maxExtent => 64;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => _tabBar;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}
