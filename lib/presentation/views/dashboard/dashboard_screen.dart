import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/sale_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/stock_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/report_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final today = DateTime.now().toString().split(' ')[0];
    final salesAsync = ref.watch(salesHistoryProvider(inicio: today, fim: today));
    final lowStockAsync = ref.watch(lowStockProvider);
    final reportAsync = ref.watch(stockReportProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          final today = DateTime.now().toString().split(' ')[0];
          ref.invalidate(salesHistoryProvider(inicio: today, fim: today));
          ref.invalidate(lowStockProvider);
          ref.invalidate(stockReportProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dashboard', style: theme.textTheme.headlineLarge),
                      const SizedBox(height: 4),
                      Text(
                        'Visão geral do seu negócio',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      final today = DateTime.now().toString().split(' ')[0];
                      ref.invalidate(salesHistoryProvider(inicio: today, fim: today));
                      ref.invalidate(lowStockProvider);
                      ref.invalidate(stockReportProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Atualizar'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // KPI Cards
              _buildKpiRow(context, ref, salesAsync, reportAsync),
              const SizedBox(height: 24),

              // Charts & Tables Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sales chart (Full Width)
                  Expanded(
                    child: Container(
                      height: 340,
                      decoration: AppTheme.glassCard(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vendas do Dia', style: theme.textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text('Resumo de faturamento por hora', style: theme.textTheme.bodySmall),
                          const SizedBox(height: 20),
                          Expanded(child: _buildSalesChart(salesAsync)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent sales table
              Container(
                decoration: AppTheme.glassCard(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Últimas Vendas', style: theme.textTheme.titleLarge),
                        TextButton.icon(
                          onPressed: () => context.go('/vendas'),
                          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                          label: const Text('Ver todas'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildRecentSalesTable(salesAsync, theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiRow(BuildContext context, WidgetRef ref, AsyncValue salesAsync, AsyncValue reportAsync) {
    final isLoading = salesAsync.isLoading || reportAsync.isLoading;
    final hasError = salesAsync.hasError || reportAsync.hasError;

    final vendas = salesAsync.valueOrNull ?? [];
    final report = reportAsync.valueOrNull; // Dados do RelatorioEstoque
    
    final totalVendas = vendas.where((v) => v.status != 'cancelada').fold(0.0, (sum, v) => sum + v.valorTotal);
    final qtdVendas = vendas.where((v) => v.status != 'cancelada').length;
    final ticketMedio = qtdVendas > 0 ? totalVendas / qtdVendas : 0.0;

    String getDisplayValue(String actualValue) {
      if (isLoading) return 'Carregando...';
      if (hasError) return 'Erro';
      return actualValue;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Ajustando para 3 ou 6 cards dependendo da largura
        final double spacing = 16;
        final int cardsPerRow = constraints.maxWidth > 1200 ? 6 : (constraints.maxWidth > 800 ? 3 : 2);
        final cardWidth = (constraints.maxWidth - (spacing * (cardsPerRow - 1))) / cardsPerRow;
        
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            // FINANCEIRO VENDAS
            SizedBox(
              width: cardWidth,
              child: KpiCard(
                title: 'Vendas Hoje',
                value: getDisplayValue(Formatters.currency(totalVendas)),
                icon: Icons.trending_up_rounded,
                color: AppTheme.accentGreen,
                subtitle: isLoading || hasError ? '' : '$qtdVendas vendas realizadas',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: KpiCard(
                title: 'Ticket Médio',
                value: getDisplayValue(Formatters.currency(ticketMedio)),
                icon: Icons.receipt_long_rounded,
                color: AppTheme.accentBlue,
              ),
            ),
            
            // ESTOQUE ALERTAS
            SizedBox(
              width: cardWidth,
              child: KpiCard(
                title: 'Estoque Baixo',
                value: getDisplayValue('${report?.produtosBaixos ?? 0}'),
                icon: Icons.warning_amber_rounded,
                color: (report?.produtosBaixos ?? 0) > 0 ? AppTheme.accentOrange : AppTheme.accentGreen,
                subtitle: isLoading || hasError ? '' : ((report?.produtosBaixos ?? 0) > 0 ? 'Produtos abaixo do mínimo' : 'Tudo em ordem'),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: KpiCard(
                title: 'Vencendo (15 dias)',
                value: getDisplayValue('${report?.produtosVencendo ?? 0}'),
                icon: Icons.hourglass_bottom_rounded,
                color: (report?.produtosVencendo ?? 0) > 0 ? AppTheme.accentRed : AppTheme.accentGreen,
                subtitle: isLoading || hasError ? '' : ((report?.produtosVencendo ?? 0) > 0 ? 'Risco de perda iminente' : 'Nenhuma perda prevista'),
              ),
            ),
            
            // PATRIMÔNIO
            SizedBox(
              width: cardWidth,
              child: KpiCard(
                title: 'Valor em Estoque',
                value: getDisplayValue(Formatters.currency(report?.valorTotalCusto ?? 0)),
                icon: Icons.inventory_2_rounded,
                color: AppTheme.primaryColor,
                subtitle: isLoading || hasError ? '' : 'Total a preço de custo',
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: KpiCard(
                title: 'Potencial de Venda',
                value: getDisplayValue(Formatters.currency(report?.valorTotalVenda ?? 0)),
                icon: Icons.attach_money_rounded,
                color: AppTheme.accentGreen,
                subtitle: isLoading || hasError ? '' : 'Total a preço de venda',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSalesChart(AsyncValue salesAsync) {
    return salesAsync.when(
      loading: () => const LoadingOverlay(message: 'Carregando...'),
      error: (e, _) => Center(child: Text('Erro: $e')),
      data: (vendas) {
        // Group by hour
        final Map<int, double> byHour = {};
        for (final v in vendas) {
          if (v.status != 'cancelada') {
            final hora = v.dataVenda.hour;
            byHour[hora] = (byHour[hora] ?? 0) + v.valorTotal;
          }
        }

        if (byHour.isEmpty) {
          return const EmptyState(
            icon: Icons.bar_chart_rounded,
            title: 'Sem vendas hoje',
            subtitle: 'Os dados aparecerão aqui quando houver vendas',
          );
        }

        // Preencher as horas vazias com zero
        int minHour = byHour.keys.reduce((a, b) => a < b ? a : b);
        int maxHour = DateTime.now().hour;
        if (maxHour < minHour) maxHour = minHour;

        for (int h = minHour; h <= maxHour; h++) {
          if (!byHour.containsKey(h)) {
            byHour[h] = 0.0;
          }
        }

        final spots = byHour.entries
            .map((e) => FlSpot(e.key.toDouble(), e.value))
            .toList()
          ..sort((a, b) => a.x.compareTo(b.x));

        return LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 100,
              getDrawingHorizontalLine: (value) => FlLine(
                color: const Color(0xFF2A2E4A),
                strokeWidth: 0.5,
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 2,
                  getTitlesWidget: (value, meta) => Text(
                    '${value.toInt()}h',
                    style: const TextStyle(fontSize: 10, color: Color(0xFF8E92BC)),
                  ),
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: AppTheme.primaryColor,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.3),
                      AppTheme.primaryColor.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLowStockList(AsyncValue lowStockAsync, ThemeData theme) {
    return lowStockAsync.when(
      loading: () => const LoadingOverlay(),
      error: (e, _) => Center(child: Text('Erro: $e')),
      data: (items) {
        if (items.isEmpty) {
          return const EmptyState(
            icon: Icons.check_circle_outline,
            title: 'Estoque OK',
            subtitle: 'Nenhum produto abaixo do mínimo',
          );
        }
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = items[index];
            final pct = item.estoqueMinimo > 0
                ? (item.estoqueAtual / item.estoqueMinimo * 100).clamp(0, 100)
                : 0.0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.nome, style: theme.textTheme.bodyLarge, overflow: TextOverflow.ellipsis),
                        Text(
                          'Atual: ${Formatters.quantity(item.estoqueAtual)} | Mín: ${Formatters.quantity(item.estoqueMinimo)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: LinearProgressIndicator(
                      value: pct / 100,
                      backgroundColor: const Color(0xFF2A2E4A),
                      valueColor: AlwaysStoppedAnimation(
                        pct < 30 ? AppTheme.accentRed : AppTheme.accentOrange,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRecentSalesTable(AsyncValue salesAsync, ThemeData theme) {
    return salesAsync.when(
      loading: () => const LoadingOverlay(),
      error: (e, _) => Center(child: Text('Erro: $e')),
      data: (vendas) {
        final recent = vendas.take(8).toList();
        if (recent.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: EmptyState(icon: Icons.receipt_long, title: 'Nenhuma venda hoje'),
          );
        }
        return DataTable(
          columns: const [
            DataColumn(label: Text('Nº Venda')),
            DataColumn(label: Text('Hora')),
            DataColumn(label: Text('Operador')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Valor'), numeric: true),
          ],
          rows: recent.map<DataRow>((v) {
            return DataRow(cells: [
              DataCell(Text(v.numeroVenda, style: theme.textTheme.bodyLarge)),
              DataCell(Text(Formatters.time(v.dataVenda))),
              DataCell(Text(v.operadorNome ?? '-')),
              DataCell(StatusChip.fromStatus(v.status)),
              DataCell(Text(
                Formatters.currency(v.valorTotal),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: v.isCancelada ? AppTheme.accentRed : null,
                ),
              )),
            ]);
          }).toList(),
        );
      },
    );
  }
}
