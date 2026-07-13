import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/data/repositories/report_repository.dart';
import 'package:unifytechxenoswebowner/presentation/providers/report_provider.dart';
import 'package:unifytechxenoswebowner/services/file_export_service.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/presentation/providers/category_provider.dart';
import 'package:unifytechxenoswebowner/presentation/views/reports/widgets/reports_help_dialog.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});
  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  int _selectedReportIndex = 0;
  bool _isExporting = false;

  final List<_ReportItem> _reports = [
    _ReportItem(title: 'Vendas Hoje', icon: Icons.today_rounded, type: 'vendas_dia', category: 'Operacional'),
    _ReportItem(title: 'Vendas do Mês', icon: Icons.calendar_month_rounded, type: 'vendas_mes', category: 'Operacional'),
    _ReportItem(title: 'Mais Vendidos', icon: Icons.star_rounded, type: 'mais_vendidos', category: 'Operacional'),
    _ReportItem(title: 'Visão de Estoque', icon: Icons.inventory_2_rounded, type: 'estoque', category: 'Estoque'),
    _ReportItem(title: 'Curva ABC', icon: Icons.auto_graph_rounded, type: 'abc', category: 'Estoque'),
    _ReportItem(title: 'Resumo Financeiro', icon: Icons.account_balance_rounded, type: 'financeiro', category: 'Financeiro'),
    _ReportItem(title: 'Inadimplência', icon: Icons.person_off_rounded, type: 'inadimplencia', category: 'Financeiro'),
    _ReportItem(title: 'Projeção de Caixa', icon: Icons.query_stats_rounded, type: 'projecao_caixa', category: 'Financeiro'),
    _ReportItem(title: 'DRE Gerencial', icon: Icons.assessment_rounded, type: 'dre', category: 'Estratégico'),
    _ReportItem(title: 'Ranking Clientes', icon: Icons.groups_rounded, type: 'ranking_clientes', category: 'CRM'),
    _ReportItem(title: 'Clientes Inativados', icon: Icons.person_off_rounded, type: 'clientes_inativados', category: 'CRM'),
    _ReportItem(title: 'Clientes Ausentes', icon: Icons.person_search_rounded, type: 'clientes_ausentes', category: 'CRM'),
    _ReportItem(title: 'Comissões', icon: Icons.badge_rounded, type: 'comissoes', category: 'Estratégico'),
    _ReportItem(title: 'Cancelamentos', icon: Icons.cancel_presentation_rounded, type: 'cancelamentos', category: 'Estratégico'),
    _ReportItem(title: 'Ranking Operadores', icon: Icons.person_pin_rounded, type: 'ranking_operadores', category: 'Estratégico'),
    _ReportItem(title: 'Vendas por Categoria', icon: Icons.category_rounded, type: 'vendas_categoria', category: 'Operacional'),
    _ReportItem(title: 'Giro de Estoque', icon: Icons.sync_alt_rounded, type: 'giro_estoque', category: 'Estoque'),
    _ReportItem(title: 'Ruptura de Estoque', icon: Icons.warning_amber_rounded, type: 'ruptura', category: 'Estoque'),
    _ReportItem(title: 'Auditoria Geral', icon: Icons.security_rounded, type: 'auditoria_geral', category: 'Auditoria'),
    _ReportItem(title: 'Contas Pagar Det.', icon: Icons.receipt_long_rounded, type: 'contas_pagar_det', category: 'Financeiro'),
    _ReportItem(title: 'Meios de Pagamento', icon: Icons.pie_chart_rounded, type: 'meios_pagamento', category: 'Financeiro'),
    _ReportItem(title: 'Produtos por Margem', icon: Icons.trending_up_rounded, type: 'produtos_margem', category: 'Estratégico'),
    _ReportItem(title: 'Fluxo por Horário', icon: Icons.access_time_filled_rounded, type: 'fluxo_horario', category: 'Estratégico'),
    _ReportItem(title: 'Compras vs Vendas', icon: Icons.swap_vert_rounded, type: 'compras_vendas', category: 'Estratégico'),
  ];



  String _getTipoRelatorioAtivo() {
    return _reports[_selectedReportIndex].type;
  }

  Future<void> _exportar(String formato) async {
    setState(() => _isExporting = true);
    try {
      final bytes = await ref.read(reportRepositoryProvider).exportarRelatorioBytes(formato, _getTipoRelatorioAtivo());
      
      String? outputFile = await FileExportService.exportAndSave(
        bytes: bytes,
        dialogTitle: 'Salvar Relatório',
        fileName: 'relatorio_${_getTipoRelatorioAtivo()}.$formato',
        extension: formato,
      );

      if (outputFile != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Relatório exportado em $outputFile', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao exportar: $e', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReportSidebar(
                    reports: _reports,
                    selectedIndex: _selectedReportIndex,
                    onSelected: (index) => setState(() => _selectedReportIndex = index),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: KeyedSubtree(
                        key: ValueKey(_selectedReportIndex),
                        child: _buildActiveReport(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Relatórios & Análises', style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Visão completa do negócio e indicadores chave', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isExporting) const CircularProgressIndicator() else ...[
              ElevatedButton.icon(
                onPressed: () => _exportar('pdf'),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('PDF'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _exportar('xlsx'),
                icon: const Icon(Icons.table_chart),
                label: const Text('Excel'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ReportsHelpDialog(),
                  );
                },
                icon: const Icon(Icons.help_outline_rounded, color: Colors.blueAccent),
                tooltip: 'Ajuda dos Relatórios',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  hoverColor: Colors.blueAccent.withOpacity(0.2),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }

  Widget _buildActiveReport() {
    switch (_reports[_selectedReportIndex].type) {
      case 'vendas_dia': return _ReportSalesView(provider: salesReportDayProvider, title: 'Vendas Hoje');
      case 'vendas_mes': return _ReportSalesView(provider: salesReportMonthProvider, title: 'Análise do Mês');
      case 'mais_vendidos': return _BestSellersView();
      case 'estoque': return _ReportStockView();
      case 'financeiro': return _ReportFinanceView();
      case 'dre': return _ReportDREView();
      case 'inadimplencia': return _ReportInadimplenciaView();
      case 'abc': return _ReportCurvaABCView();
      case 'comissoes': return _ReportComissoesView();
      case 'ranking_clientes': return _ReportRankingClientesView();
      case 'clientes_inativados': return _ReportClientesInativadosView();
      case 'clientes_ausentes': return _ReportClientesAusentesView();
      case 'projecao_caixa': return _ReportProjecaoCaixaView();
      case 'cancelamentos': return _ReportCancelamentosView();
      case 'giro_estoque': return _ReportGiroEstoqueView();
      case 'ruptura': return _ReportRupturaEstoqueView();
      case 'ranking_operadores': return _ReportRankingOperadoresView();
      case 'auditoria_geral': return _ReportAuditoriaGeralView();
      case 'vendas_categoria': return _ReportVendasCategoriaView();
      case 'contas_pagar_det': return _ReportContasPagarDetView();
      case 'meios_pagamento': return _ReportMeiosPagamentoView();
      case 'produtos_margem': return _ReportMargemLucroView();
      case 'fluxo_horario': return _ReportFluxoHorarioView();
      case 'compras_vendas': return _ReportComprasVendasView();
      default: return const Center(child: Text('Selecione um relatório'));
    }
  }
}


class _ReportItem {
  final String title;
  final IconData icon;
  final String type;
  final String category;

  _ReportItem({required this.title, required this.icon, required this.type, required this.category});
}

class _ReportSidebar extends StatelessWidget {
  final List<_ReportItem> reports;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _ReportSidebar({
    required this.reports,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Agrupar por categoria
    final Map<String, List<int>> categories = {};
    for (int i = 0; i < reports.length; i++) {
      final cat = reports[i].category;
      if (!categories.containsKey(cat)) categories[cat] = [];
      categories[cat]!.add(i);
    }

    return Container(
      width: 240,
      decoration: AppTheme.glassCard(),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: categories.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
                child: Text(
                  entry.key.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              ...entry.value.map((index) {
                final report = reports[index];
                final isSelected = selectedIndex == index;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: ListTile(
                    onTap: () => onSelected(index),
                    dense: true,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    selected: isSelected,
                    selectedTileColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                    leading: Icon(
                      report.icon, 
                      size: 20, 
                      color: isSelected ? AppTheme.primaryColor : theme.colorScheme.onSurfaceVariant
                    ),
                    title: Text(
                      report.title,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppTheme.primaryColor : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              const Divider(indent: 20, endIndent: 20, height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ReportSalesView extends ConsumerWidget {
  final ProviderListenable<AsyncValue<Map<String, dynamic>>> provider;
  final String title;

  const _ReportSalesView({required this.provider, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(provider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Carregando indicadores...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro de Relatório', subtitle: '$e'),
        data: (data) {
          final double totalVendas = (data['total_vendas'] ?? 0).toDouble();
          final double valorTotal = (data['valor_total'] ?? 0).toDouble();
          final double ticketMedio = (data['ticket_medio'] ?? 0).toDouble();
          
          final List porCaixa = data['por_caixa'] ?? [];
          final List porFormaPag = data['por_forma_pagamento'] ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.start,
                  children: [
                    _KPICard(title: 'Transações', value: totalVendas.toInt().toString(), icon: Icons.receipt),
                    _KPICard(title: 'Faturamento', value: Formatters.currency(valorTotal), icon: Icons.monetization_on, color: Colors.green),
                    _KPICard(title: 'Ticket Médio', value: Formatters.currency(ticketMedio), icon: Icons.analytics, color: Colors.purple),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Faturamento por Caixa', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          if (porCaixa.isEmpty) const Text('Nenhum dado registrado.') else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: porCaixa.length,
                            itemBuilder: (context, i) {
                              final item = porCaixa[i];
                              return ListTile(
                                leading: const Icon(Icons.point_of_sale, color: AppTheme.primaryColor),
                                title: Text(item['caixa'] ?? 'Caixa'),
                                subtitle: Text('${item['total']} transações'),
                                trailing: Text(Formatters.currency((item['valor_total'] ?? 0).toDouble()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Métodos de Pagamento', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          if (porFormaPag.isEmpty) const Text('Nenhum dado registrado.') else
                          ...porFormaPag.map((item) {
                             return ListTile(
                                leading: const Icon(Icons.payment, color: Colors.green),
                                title: Text(item['forma_pagamento'] ?? 'PAGAMENTO'),
                                subtitle: Text('${item['total']} transações'),
                                trailing: Text(Formatters.currency((item['valor_total'] ?? 0).toDouble()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _KPICard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KPICard({required this.title, required this.value, required this.icon, this.color = AppTheme.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260, minWidth: 200),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _BestSellersView extends ConsumerStatefulWidget {
  @override
  ConsumerState<_BestSellersView> createState() => _BestSellersViewState();
}

class _BestSellersViewState extends ConsumerState<_BestSellersView> {
  int? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(bestSellersProvider(categoriaId: _selectedCategoryId));
    final categoriesAsync = ref.watch(categoriesProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      child: Column(
        children: [
          // Header com Filtro
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🏆 Ranking de Performance', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Os 10 produtos com maior volume de saída', style: theme.textTheme.bodySmall),
                  ],
                ),
                // Filtro de Categoria
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
                  ),
                  child: categoriesAsync.response.when(
                    data: (paginated) => DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: _selectedCategoryId,
                        hint: const Text('Filtrar Categoria', style: TextStyle(fontSize: 13, color: Colors.white70)),
                        icon: const Icon(Icons.filter_list_rounded, size: 18, color: AppTheme.primaryColor),
                        dropdownColor: const Color(0xFF1C2039),
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                        onChanged: (id) => setState(() => _selectedCategoryId = id),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('Todas as Categorias')),
                          ...paginated.data.map((cat) => DropdownMenuItem(
                            value: cat.idCategoria,
                            child: Text(cat.nome),
                          )),
                        ],
                      ),
                    ),
                    loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    error: (_, __) => const Icon(Icons.error, size: 18, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: dataAsync.when(
              loading: () => const LoadingOverlay(message: 'Analisando dados...'),
              error: (e, _) => EmptyState(icon: Icons.analytics_outlined, title: 'Erro na análise', subtitle: '$e'),
              data: (products) {
                if (products.isEmpty) {
                  return const EmptyState(
                    icon: Icons.bar_chart_rounded, 
                    title: 'Sem dados para exibir',
                    subtitle: 'Não houve vendas registradas nesta categoria no período.',
                  );
                }

                final topProducts = products.take(10).toList();
                List<BarChartGroupData> barGroups = [];
                for (int i = 0; i < topProducts.length; i++) {
                  final double qty = (topProducts[i]['quantidade_vendida'] as num?)?.toDouble() ?? 0;
                  barGroups.add(BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: qty,
                        color: AppTheme.primaryColor,
                        width: 24,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      )
                    ],
                  ));
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gráfico Premium
                      Container(
                        height: 320,
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barGroups: barGroups,
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              getDrawingHorizontalLine: (value) => FlLine(color: Colors.white10, strokeWidth: 1),
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (val, meta) => Text(val.toInt().toString(), style: const TextStyle(color: Colors.white54, fontSize: 10)),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 60,
                                  getTitlesWidget: (val, meta) {
                                    if (val.toInt() < topProducts.length) {
                                      String name = topProducts[val.toInt()]['nome'] ?? '';
                                      if (name.length > 12) name = '${name.substring(0, 10)}..';
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: RotatedBox(
                                          quarterTurns: 1,
                                          child: Text(name, style: const TextStyle(fontSize: 10, color: Colors.white70)),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                            ),
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                    '${topProducts[groupIndex]['nome']}\n',
                                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: '${rod.toY.toInt()} vendidos',
                                        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.normal, fontSize: 12),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Text('📄 Listagem Detalhada', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DataTable(
                          headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                          columns: const [
                            DataColumn(label: Text('#')),
                            DataColumn(label: Text('PRODUTO')),
                            DataColumn(label: Text('QTD VENDIDA'), numeric: true),
                            DataColumn(label: Text('FATURAMENTO'), numeric: true),
                          ],
                          rows: products.asMap().entries.map((entry) {
                            final i = entry.key;
                            final p = entry.value;
                            return DataRow(
                              color: WidgetStateProperty.resolveWith<Color?>((states) => i < 3 ? AppTheme.primaryColor.withValues(alpha: 0.05) : null),
                              cells: [
                                DataCell(Text('${i + 1}', style: TextStyle(fontWeight: i < 3 ? FontWeight.bold : FontWeight.normal))),
                                DataCell(
                                  Row(
                                    children: [
                                      if (i < 3) Padding(padding: const EdgeInsets.only(right: 8), child: Icon(Icons.workspace_premium, size: 16, color: i == 0 ? Colors.amber : (i == 1 ? Colors.grey : Colors.brown))),
                                      Text(p['nome']?.toString() ?? '-'),
                                    ],
                                  ),
                                ),
                                DataCell(Text(Formatters.quantity((p['quantidade_vendida'] as num?)?.toDouble() ?? 0))),
                                DataCell(Text(Formatters.currency((p['valor_total'] as num?)?.toDouble() ?? 0))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportStockView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(stockReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Carregando Estoque...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro de Relatório', subtitle: '$e'),
        data: (data) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Avaliação de Patrimônio', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    _KPICard(title: 'Total de Itens Cadastrados', value: '${data.totalProdutos}', icon: Icons.inventory_2, color: Colors.blueGrey),
                    _KPICard(title: 'Alerta Estoque Baixo', value: '${data.produtosBaixos} produtos', icon: Icons.warning_amber_rounded, color: Colors.orange),
                    _KPICard(title: 'Alerta Vencendo (15d)', value: '${data.produtosVencendo} produtos', icon: Icons.hourglass_bottom_rounded, color: Colors.redAccent),
                    _KPICard(title: 'Valor Estoque (Custo)', value: Formatters.currency(data.valorTotalCusto), icon: Icons.price_change, color: Colors.red),
                    _KPICard(title: 'Valor Estoque (Venda)', value: Formatters.currency(data.valorTotalVenda), icon: Icons.monetization_on, color: Colors.green),
                  ],
                ),
                const SizedBox(height: 48),
                if (data.valorTotalVenda > 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.insights, color: Colors.green),
                      const SizedBox(width: 16),
                      Expanded(child: Text('A margem de lucro bruta (estimada global) baseada no estoque atual é de aproximadamente ${(((data.valorTotalVenda - data.valorTotalCusto) / data.valorTotalCusto) * 100).toStringAsFixed(1)}%.')),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReportFinanceView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(financeReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Carregando Finanças...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          final double pagar = (data['valor_pagar_aberto'] as num?)?.toDouble() ?? 0;
          final double receber = (data['valor_receber_aberto'] as num?)?.toDouble() ?? 0;
          final double caixa = (data['saldo_caixa_dia'] as num?)?.toDouble() ?? 0;

          return SingleChildScrollView(
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                  Text('Instantâneo Financeiro', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      _KPICard(title: 'A Receber (Aberto)', value: Formatters.currency(receber), icon: Icons.arrow_circle_down, color: Colors.green),
                      _KPICard(title: 'A Pagar (Aberto)', value: Formatters.currency(pagar), icon: Icons.arrow_circle_up, color: Colors.red),
                      _KPICard(title: 'Evolução Caixa Hoje', value: Formatters.currency(caixa), icon: Icons.account_balance, color: Colors.blue),
                    ],
                  ),
               ],
            ),
          );
        },
      ),
    );
  }
}

class _ReportDREView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(dreDetalhadoReportProvider());

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Calculando DRE...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          final double bruto = (data['receita_bruta'] ?? 0).toDouble();
          final double descontos = (data['descontos'] ?? 0).toDouble();
          final double liquida = (data['receita_liquida'] ?? 0).toDouble();
          final double cmv = (data['cmv'] ?? 0).toDouble();
          final double lucroBruto = (data['lucro_bruto'] ?? 0).toDouble();
          final double despesas = (data['despesas'] ?? 0).toDouble();
          final double lucroLiquido = (data['lucro_liquido'] ?? 0).toDouble();
          final double margem = (data['margem_percentual'] ?? 0).toDouble();
          final List despesasDetalhadas = data['despesas_por_categoria'] ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DRE Gerencial Detalhado', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                _DRELing(label: '(+) RECEITA BRUTA', value: bruto, color: Colors.green),
                _DRELing(label: '(-) Devoluções/Descontos', value: descontos, color: Colors.redAccent),
                _DRELing(label: '(=) RECEITA LÍQUIDA', value: liquida, isBold: true),
                const Divider(height: 32),
                _DRELing(label: '(-) CMV (Custo de Venda)', value: cmv, color: Colors.orange),
                _DRELing(label: '(=) LUCRO BRUTO', value: lucroBruto, isBold: true, color: Colors.green),
                const Divider(height: 32),
                _DRELing(label: '(-) Despesas Operacionais', value: despesas, color: Colors.red),
                
                if (despesasDetalhadas.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 8),
                    child: Column(
                      children: despesasDetalhadas.map((d) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(d['categoria'] ?? 'Outros', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            Text(Formatters.currency((d['valor'] ?? 0).toDouble()), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                ],

                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: (lucroLiquido >= 0 ? Colors.green : Colors.red).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: (lucroLiquido >= 0 ? Colors.green : Colors.red).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      _DRELing(label: '(=) LUCRO LÍQUIDO FINAL', value: lucroLiquido, isBold: true, color: lucroLiquido >= 0 ? Colors.green : Colors.red),
                      const SizedBox(height: 8),
                      Text('Margem Líquida: ${margem.toStringAsFixed(2)}%', style: TextStyle(fontWeight: FontWeight.bold, color: lucroLiquido >= 0 ? Colors.green : Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DRELing extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;
  final Color? color;

  const _DRELing({required this.label, required this.value, this.isBold = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(Formatters.currency(value), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _ReportInadimplenciaView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(inadimplenciaReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Listando Inadimplência...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          final List itens = data['itens'] ?? [];
          final double total = (data['total_vencido'] ?? 0).toDouble();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Títulos em Atraso', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Total em Aberto', style: TextStyle(fontSize: 12)),
                        Text(Formatters.currency(total), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: itens.isEmpty 
                  ? const EmptyState(icon: Icons.check_circle_outline, title: 'Nenhum título vencido!')
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: itens.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final item = itens[i];
                        final int dias = item['dias_atraso'] ?? 0;
                        Color statusColor = Colors.orange;
                        if (dias > 30) statusColor = Colors.red;
                        if (dias > 60) statusColor = const Color(0xff800000); // Bordô

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: statusColor.withValues(alpha: 0.2))),
                          child: Row(
                            children: [
                              CircleAvatar(backgroundColor: statusColor.withValues(alpha: 0.1), child: Icon(Icons.person, color: statusColor)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['cliente'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    Text('Vencido em: ${Formatters.date(item['data_vencimento'])}', style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(Formatters.currency((item['valor'] ?? 0).toDouble()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4)),
                                    child: Text('$dias dias em atraso', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportCurvaABCView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(curvaABCReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Gerando Curva ABC...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          final List itens = data['itens'] ?? [];
          final double total = (data['total_faturamento'] ?? 0).toDouble();

          // Agrupar por classificação para o gráfico
          double faturamentoA = 0;
          double faturamentoB = 0;
          double faturamentoC = 0;

          for (var item in itens) {
            final f = (item['faturamento'] ?? 0).toDouble();
            if (item['classificacao'] == 'A') faturamentoA += f;
            else if (item['classificacao'] == 'B') faturamentoB += f;
            else faturamentoC += f;
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                   children: [
                      const Icon(Icons.auto_graph, color: AppTheme.primaryColor, size: 30),
                      const SizedBox(width: 12),
                      Text('Análise Curva ABC (90 dias)', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                   ],
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: [
                             PieChartSectionData(value: faturamentoA, title: 'A (${((faturamentoA/total)*100).toStringAsFixed(1)}%)', color: Colors.green, radius: 50, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                             PieChartSectionData(value: faturamentoB, title: 'B (${((faturamentoB/total)*100).toStringAsFixed(1)}%)', color: Colors.blue, radius: 45, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                             PieChartSectionData(value: faturamentoC, title: 'C (${((faturamentoC/total)*100).toStringAsFixed(1)}%)', color: Colors.orange, radius: 40, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                    Expanded(
                      child: Column(
                        children: [
                           _ABCLegend(color: Colors.green, title: 'Classe A (Essenciais)', description: 'Representam ~80% do faturamento.'),
                           const SizedBox(height: 12),
                           _ABCLegend(color: Colors.blue, title: 'Classe B (Intermediários)', description: 'Representam ~15% do faturamento.'),
                           const SizedBox(height: 12),
                           _ABCLegend(color: Colors.orange, title: 'Classe C (Baixo Giro)', description: 'Representam os últimos ~5%.'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Text('Top Itens por Classificação', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('PRODUTO')),
                      DataColumn(label: Text('CLASSE')),
                      DataColumn(label: Text('FATURAMENTO')),
                      DataColumn(label: Text('ACUMULADO')),
                    ],
                    rows: itens.take(20).map((item) {
                       final String classe = item['classificacao'] ?? '-';
                       Color c = Colors.grey;
                       if (classe == 'A') c = Colors.green;
                       else if (classe == 'B') c = Colors.blue;
                       else if (classe == 'C') c = Colors.orange;

                       return DataRow(cells: [
                         DataCell(Text(item['nome'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold))),
                         DataCell(Chip(label: Text(classe, style: const TextStyle(color: Colors.white, fontSize: 10)), backgroundColor: c, padding: EdgeInsets.zero)),
                         DataCell(Text(Formatters.currency((item['faturamento'] ?? 0).toDouble()))),
                         DataCell(Text('${(item['percentual_acumulado'] as num?)?.toStringAsFixed(1)}%')),
                       ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ABCLegend extends StatelessWidget {
  final Color color;
  final String title;
  final String description;

  const _ABCLegend({required this.color, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(description, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportComissoesView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(comissoesReportProvider());

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Calculando Comissões...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          final List operadores = data['operadores'] ?? [];
          final double totalGeral = (data['total_geral'] ?? 0).toDouble();
          final double totalComissao = (data['total_comissao'] ?? 0).toDouble();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  _KPICard(title: 'Faturamento Total', value: Formatters.currency(totalGeral), icon: Icons.payments, color: AppTheme.primaryColor),
                  _KPICard(title: 'Comissões Presumidas (1%)', value: Formatters.currency(totalComissao), icon: Icons.card_giftcard, color: Colors.orange),
                ],
              ),
              const SizedBox(height: 48),
              Text('Performance por Operador', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: operadores.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    final op = operadores[i];
                    return ListTile(
                      leading: CircleAvatar(
                         backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                         child: Text(op['nome']?[0] ?? '?', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                      ),
                      title: Text(op['nome'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${op['total_vendas']} vendas | Ticket Médio: ${Formatters.currency((op['ticket_medio'] ?? 0).toDouble())}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(Formatters.currency((op['comissao'] ?? 0).toDouble()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                          const Text('Comissão', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportRankingClientesView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(rankingClientesReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Analisando clientes...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Top 20 Clientes (Faturamento)', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) {
                    final c = data[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                        child: Text('${i + 1}', style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(c['nome'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${c['total_vendas']} compras realizadas'),
                      trailing: Text(Formatters.currency((c['valor_total'] ?? 0).toDouble()), 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportClientesInativadosView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(clientesInativosReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Buscando inativados...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Clientes Inativados (Status: Inativo)', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Expanded(
                child: data.isEmpty 
                  ? const EmptyState(icon: Icons.check_circle_outline, title: 'Nenhum cliente inativado', subtitle: 'Todos os seus clientes estão ativos.')
                  : ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) {
                        final c = data[i];
                        return ListTile(
                          leading: const CircleAvatar(backgroundColor: Colors.redAccent, child: Icon(Icons.person_off, color: Colors.white)),
                          title: Text(c['nome'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Data de cadastro: ${Formatters.date(DateTime.tryParse(c['ultima_compra']?.toString() ?? ''))}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('STATUS', style: TextStyle(fontSize: 10, color: Colors.redAccent)),
                              const Text('INATIVO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportClientesAusentesView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(clientesAusentesReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Buscando clientes sumidos...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Clientes Ausentes (> 30 dias)', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text('${data.length} clientes encontrados', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: data.isEmpty 
                  ? const EmptyState(icon: Icons.sentiment_satisfied_alt, title: 'Nenhum cliente ausente!', subtitle: 'Sua retenção está excelente.')
                  : ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final c = data[i];
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.cardColor.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(child: Icon(Icons.person_outline)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c['nome'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Última compra: ${Formatters.date(DateTime.tryParse(c['ultima_compra']?.toString() ?? ''))}', style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${c['dias_inativo']} dias', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                  Text('Total gasto: ${Formatters.currency((c['total_gasto'] ?? 0).toDouble())}', style: const TextStyle(fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportProjecaoCaixaView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(projecaoCaixaReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Calculando futuro...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          if (data.isEmpty) return const EmptyState(icon: Icons.query_stats, title: 'Sem dados para projeção');

          final double minSaldo = data.map((e) => (e['saldo'] as num).toDouble()).reduce((a, b) => a < b ? a : b);
          final double maxSaldo = data.map((e) => (e['saldo'] as num).toDouble()).reduce((a, b) => a > b ? a : b);
          final double range = (maxSaldo - minSaldo).abs();
          final double padding = range > 0 ? range * 0.2 : 1000;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tendência de Fluxo de Caixa', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const Text('Projeção acumulada para os próximos 30 dias', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  _KPICardMini(
                    title: 'Saldo Final Previsto', 
                    value: Formatters.currency((data.last['saldo'] as num).toDouble()), 
                    color: (data.last['saldo'] as num) >= 0 ? Colors.green : Colors.red
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: padding > 0 ? padding : 1000,
                        getDrawingHorizontalLine: (value) => FlLine(color: theme.dividerColor.withValues(alpha: 0.1), strokeWidth: 1),
                        getDrawingVerticalLine: (value) => FlLine(color: theme.dividerColor.withValues(alpha: 0.1), strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 5,
                            getTitlesWidget: (value, meta) {
                              int idx = value.toInt();
                              if (idx >= 0 && idx < data.length) {
                                String date = data[idx]['data'].toString();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(date.substring(8, 10) + '/' + date.substring(5, 7), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTitlesWidget: (value, meta) {
                              return Text(Formatters.compactCurrency(value), style: const TextStyle(fontSize: 10, color: Colors.grey));
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: (data.length - 1).toDouble(),
                      minY: minSaldo - padding,
                      maxY: maxSaldo + padding,
                      lineBarsData: [
                        LineChartBarData(
                          spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['saldo'] as num).toDouble())).toList(),
                          isCurved: true,
                          color: AppTheme.primaryColor,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [AppTheme.primaryColor.withValues(alpha: 0.3), AppTheme.primaryColor.withValues(alpha: 0.0)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (spot) => theme.cardColor,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              final item = data[spot.x.toInt()];
                              return LineTooltipItem(
                                '${Formatters.date(item['data'])}\n',
                                theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: 'Saldo: ${Formatters.currency(spot.y)}\n',
                                    style: TextStyle(color: spot.y >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: '(+) Rec: ${Formatters.currency((item['a_receber'] as num).toDouble())}\n',
                                    style: const TextStyle(color: Colors.blue, fontSize: 10),
                                  ),
                                  TextSpan(
                                    text: '(-) Pag: ${Formatters.currency((item['a_pagar'] as num).toDouble())}',
                                    style: const TextStyle(color: Colors.orange, fontSize: 10),
                                  ),
                                ],
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   _KPICardMini(title: 'Total a Receber', value: Formatters.currency(data.fold(0.0, (a, b) => a + (b['a_receber'] as num).toDouble())), color: Colors.blue),
                   _KPICardMini(title: 'Total a Pagar', value: Formatters.currency(data.fold(0.0, (a, b) => a + (b['a_pagar'] as num).toDouble())), color: Colors.orange),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportCancelamentosView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(cancelamentosReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Buscando cancelamentos...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Auditoria de Cancelamentos', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Expanded(
                child: data.isEmpty 
                  ? const EmptyState(icon: Icons.check_circle_outline, title: 'Nenhum cancelamento encontrado')
                  : ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) {
                        final c = data[i];
                        return ListTile(
                          title: Row(
                            children: [
                              Text('Venda #${c['numero_venda']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text(Formatters.currency((c['valor'] ?? 0).toDouble()), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Data: ${Formatters.date(c['data'])} | Operador: ${c['usuario']}'),
                              Text('Motivo: ${c['motivo']}', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.orange)),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportGiroEstoqueView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(giroEstoqueReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Calculando giro...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Giro de Estoque (30 dias)', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) {
                    final p = data[i];
                    final double giro = (p['giro'] ?? 0).toDouble();
                    return ListTile(
                      title: Text(p['nome'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Saídas: ${p['saidas']} | Estoque Atual: ${p['estoque_atual']}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                           Text(giro.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: giro > 1 ? Colors.green : Colors.orange)),
                           const Text('Índice de Giro', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportRupturaEstoqueView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(rupturaEstoqueReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Identificando rupturas...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Produtos em Ruptura (Demanda x Estoque Zero)', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 24),
              Expanded(
                child: data.isEmpty 
                  ? const EmptyState(icon: Icons.check_circle_outline, title: 'Nenhuma ruptura detectada')
                  : ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) {
                        final p = data[i];
                        return ListTile(
                          leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                          title: Text(p['nome'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Média de vendas: ${(p['media_vendas_diaria'] ?? 0).toStringAsFixed(2)}/dia'),
                          trailing: const Text('ESTOQUE ZERO', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                        );
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportRankingOperadoresView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(rankingOperadoresReportProvider());

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Analisando performance...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (list) {
          if (list.isEmpty) return const EmptyState(icon: Icons.person_off_rounded, title: 'Sem dados', subtitle: 'Nenhuma venda registrada para os operadores no período.');
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ranking de Performance por Operador', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final op = list[index];
                    final color = index == 0 ? Colors.amber : (index == 1 ? Colors.grey : (index == 2 ? Colors.brown : Colors.blueGrey));
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: Colors.white.withValues(alpha: 0.03),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withValues(alpha: 0.2),
                          child: Text('${index + 1}', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                        ),
                        title: Text(op['nome'] ?? 'Operador', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${op['total_vendas']} vendas | Ticket Médio: ${Formatters.currency((op['ticket_medio'] ?? 0).toDouble())}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(Formatters.currency((op['valor_total'] ?? 0).toDouble()), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                            Text('Descontos: ${Formatters.currency((op['total_descontos'] ?? 0).toDouble())}', style: const TextStyle(fontSize: 10, color: Colors.white38)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportAuditoriaGeralView extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ReportAuditoriaGeralView> createState() => _ReportAuditoriaGeralViewState();
}

class _ReportAuditoriaGeralViewState extends ConsumerState<_ReportAuditoriaGeralView> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) setState(() {});
    });
  }

  String _formatAuditData(dynamic data) {
    if (data == null || data == 'null' || data == '{}' || data == '[]') return 'N/A';
    
    try {
      // Se já for um objeto/lista
      if (data is Map || data is List) {
        return _formatValue(data);
      }
      
      // Se for string, tenta decodificar
      final String strData = data.toString();
      if (strData.startsWith('{') || strData.startsWith('[')) {
        final decoded = json.decode(strData);
        return _formatValue(decoded);
      }
      return strData;
    } catch (_) {
      return data.toString();
    }
  }

  String _formatValue(dynamic val) {
    if (val is Map) {
      return val.entries
          .where((e) => e.value != null)
          .map((e) => '${e.key}: ${e.value}')
          .join(' | ');
    }
    if (val is List) {
      return val.map((e) => _formatValue(e)).join('; ');
    }
    return val.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(auditoriaGeralReportProvider(search: _searchController.text));

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Log de Auditoria do Sistema', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Ação, tabela ou usuário...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: dataAsync.when(
              loading: () => const LoadingOverlay(message: 'Recuperando logs...'),
              error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
              data: (list) {
                if (list.isEmpty) return const EmptyState(icon: Icons.history_rounded, title: 'Nenhum log', subtitle: 'Nenhuma atividade registrada com estes filtros.');
                
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final date = DateTime.parse(item['data']);
                    final isDanger = item['acao'] == 'DELETE' || item['tabela'] == 'usuario';
                    
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        item['acao'] == 'INSERT' ? Icons.add_circle_outline : (item['acao'] == 'UPDATE' || item['acao'].contains('UPDATE') ? Icons.edit_note : Icons.remove_circle_outline),
                        color: item['acao'] == 'INSERT' ? Colors.green : (item['acao'] == 'UPDATE' || item['acao'].contains('UPDATE') ? Colors.blue : Colors.red),
                      ),
                      title: Row(
                        children: [
                          Text(item['tabela'].toString().toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryColor)),
                          const SizedBox(width: 8),
                          Text(item['acao'], style: TextStyle(fontSize: 10, color: isDanger ? Colors.redAccent : Colors.white70)),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Usuário: ${item['usuario']}'),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 10),
                              children: [
                                const TextSpan(text: 'De: ', style: TextStyle(color: Colors.white38)),
                                TextSpan(text: _formatAuditData(item['valores_antigos']), style: const TextStyle(color: Colors.white60)),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 10),
                              children: [
                                const TextSpan(text: 'Para: ', style: TextStyle(color: Colors.blueGrey)),
                                TextSpan(text: _formatAuditData(item['valores_novos']), style: const TextStyle(color: Colors.blue)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 10, color: Colors.white38),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class _ReportVendasCategoriaView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(vendasCategoriaReportProvider());

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: dataAsync.when(
        loading: () => const LoadingOverlay(message: 'Calculando proporções...'),
        error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
        data: (list) {
          if (list.isEmpty) return const EmptyState(icon: Icons.category_rounded, title: 'Sem vendas', subtitle: 'Nenhuma venda categorizada no período.');
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Distribuição de Vendas por Categoria', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final cat = list[index];
                    final perc = (cat['percentual'] ?? 0).toDouble();
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(cat['categoria'] ?? 'Outros', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(Formatters.currency((cat['valor_total'] ?? 0).toDouble()), style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: perc / 100,
                              minHeight: 12,
                              backgroundColor: Colors.white10,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                index == 0 ? AppTheme.primaryColor : AppTheme.primaryColor.withValues(alpha: 0.5)
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text('${perc.toStringAsFixed(1)}% do faturamento total', style: const TextStyle(fontSize: 10, color: Colors.white38)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportContasPagarDetView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(contasPagarDetalhadoReportProvider(status: 'aberta'));

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Detalhamento de Contas a Pagar', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(
            child: dataAsync.when(
              loading: () => const LoadingOverlay(message: 'Consultando compromissos...'),
              error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
              data: (list) {
                if (list.isEmpty) return const EmptyState(icon: Icons.check_circle_outline, title: 'Tudo em dia!', subtitle: 'Não há contas a pagar pendentes.');
                
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                      columns: const [
                        DataColumn(label: Text('VENCIMENTO')),
                        DataColumn(label: Text('FORNECEDOR')),
                        DataColumn(label: Text('DESCRIÇÃO')),
                        DataColumn(label: Text('VALOR ORIGINAL'), numeric: true),
                        DataColumn(label: Text('STATUS')),
                      ],
                      rows: list.map((item) {
                        final venc = DateTime.parse(item['data_vencimento']);
                        final isLate = venc.isBefore(DateTime.now()) && item['status'] == 'aberta';
                        
                        return DataRow(
                          cells: [
                            DataCell(Text('${venc.day}/${venc.month}/${venc.year}', style: TextStyle(color: isLate ? Colors.redAccent : Colors.white70, fontWeight: isLate ? FontWeight.bold : FontWeight.normal))),
                            DataCell(Text(item['fornecedor'] ?? 'N/A')),
                            DataCell(Text(item['descricao'] ?? '-')),
                            DataCell(Text(Formatters.currency((item['valor_original'] ?? 0).toDouble()))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isLate ? Colors.red.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(isLate ? 'ATRASADO' : 'PENDENTE', style: TextStyle(fontSize: 10, color: isLate ? Colors.red : Colors.orange)),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _KPICardMini extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _KPICardMini({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _ReportMargemLucroView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(produtosMargemReportProvider);

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ranking de Rentabilidade por Produto', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Produtos ordenados pela maior margem de lucro percentual', style: theme.textTheme.bodySmall),
          const SizedBox(height: 24),
          Expanded(
            child: dataAsync.when(
              loading: () => const LoadingOverlay(message: 'Calculando margens...'),
              error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
              data: (list) {
                if (list.isEmpty) return const EmptyState(icon: Icons.trending_up_rounded, title: 'Sem dados', subtitle: 'Não há produtos com preço de custo e venda definidos.');
                
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final margem = (item['margem_percentual'] as num).toDouble();
                    
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getMargemColor(margem).withOpacity(0.1),
                        child: Text('${index + 1}', style: TextStyle(color: _getMargemColor(margem), fontWeight: FontWeight.bold)),
                      ),
                      title: Text(item['nome'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Custo: ${Formatters.currency(item['preco_custo'])} | Venda: ${Formatters.currency(item['preco_venda'])}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${margem.toStringAsFixed(1)}%', style: TextStyle(color: _getMargemColor(margem), fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Lucro: ${Formatters.currency(item['lucro_absoluto'])}', style: const TextStyle(fontSize: 10, color: Colors.white38)),
                        ],
                      ),

                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getMargemColor(double margem) {
    if (margem >= 50) return Colors.greenAccent;
    if (margem >= 30) return Colors.blueAccent;
    if (margem >= 15) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}

class _ReportFluxoHorarioView extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ReportFluxoHorarioView> createState() => _ReportFluxoHorarioViewState();
}

class _ReportFluxoHorarioViewState extends ConsumerState<_ReportFluxoHorarioView> {
  DateTime _dataInicio = DateTime.now().subtract(const Duration(days: 7));
  DateTime _dataFim = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(vendasFluxoHorarioReportProvider(
      dataInicio: Formatters.dateForApi(_dataInicio),
      dataFim: Formatters.dateForApi(_dataFim),
    ));

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fluxo de Vendas por Horário', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Identifique picos de movimento para otimizar a equipe', style: theme.textTheme.bodySmall),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    initialDateRange: DateTimeRange(start: _dataInicio, end: _dataFim),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: AppTheme.primaryColor,
                          onPrimary: Colors.white,
                          surface: const Color(0xFF1E1E1E),
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    setState(() {
                      _dataInicio = picked.start;
                      _dataFim = picked.end;
                    });
                  }
                },
                icon: const Icon(Icons.date_range_rounded, size: 18),
                label: Text('${Formatters.date(_dataInicio)} - ${Formatters.date(_dataFim)}'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          Expanded(
            child: dataAsync.when(
              loading: () => const LoadingOverlay(message: 'Analisando histórico...'),
              error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
              data: (list) {
                if (list.isEmpty) return const EmptyState(icon: Icons.access_time_rounded, title: 'Sem dados', subtitle: 'Nenhuma venda registrada no período.');
                
                return LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: true, drawVerticalLine: false),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 2,
                          getTitlesWidget: (value, meta) => Text('${value.toInt()}h', style: const TextStyle(color: Colors.white38, fontSize: 10)),
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (spot) => const Color(0xFF2C2C2C).withOpacity(0.9),
                        tooltipRoundedRadius: 8,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              '${spot.x.toInt()}h: ${spot.y.toInt()} vendas',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [

                      LineChartBarData(
                        spots: list.map((e) => FlSpot((e['hora'] as num).toDouble(), (e['total_vendas'] as num).toDouble())).toList(),
                        isCurved: true,
                        color: AppTheme.primaryColor,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppTheme.primaryColor.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: Text('Horário do Dia (24h)', style: TextStyle(color: Colors.white38, fontSize: 10))),
        ],
      ),
    );
  }
}

class _ReportMeiosPagamentoView extends ConsumerStatefulWidget {
  const _ReportMeiosPagamentoView();
  @override
  ConsumerState<_ReportMeiosPagamentoView> createState() => _ReportMeiosPagamentoViewState();
}

class _ReportMeiosPagamentoViewState extends ConsumerState<_ReportMeiosPagamentoView> {
  DateTime _dataInicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _dataFim = DateTime.now();
  int _touchedIndex = -1;

  Color _getPaymentMethodColor(String name) {
    final cleanName = name.trim().toLowerCase();
    if (cleanName.contains('pix')) return const Color(0xFF00D2B4);
    if (cleanName.contains('crédito') || cleanName.contains('credito')) return const Color(0xFF9F8FEF);
    if (cleanName.contains('débito') || cleanName.contains('debito')) return const Color(0xFF42A5F5);
    if (cleanName.contains('dinheiro') || cleanName.contains('espécie')) return const Color(0xFF66BB6A);
    if (cleanName.contains('crediário') || cleanName.contains('prazo')) return const Color(0xFFFFCA28);
    if (cleanName.contains('vale') || cleanName.contains('ticket')) return const Color(0xFFFF7043);
    return const Color(0xFFAB47BC);
  }

  IconData _getPaymentMethodIcon(String name) {
    final cleanName = name.trim().toLowerCase();
    if (cleanName.contains('pix')) return Icons.qr_code_scanner_rounded;
    if (cleanName.contains('crédito') || cleanName.contains('credito')) return Icons.credit_card_rounded;
    if (cleanName.contains('débito') || cleanName.contains('debito')) return Icons.credit_card_outlined;
    if (cleanName.contains('dinheiro') || cleanName.contains('espécie')) return Icons.attach_money_rounded;
    if (cleanName.contains('crediário') || cleanName.contains('prazo')) return Icons.calendar_today_rounded;
    return Icons.payment_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(vendasMeiosPagamentoReportProvider(
      dataInicio: Formatters.dateForApi(_dataInicio),
      dataFim: Formatters.dateForApi(_dataFim),
    ));

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💳 Vendas por Meio de Pagamento', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Análise do volume e fatia de participação por método de entrada', style: theme.textTheme.bodySmall),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    initialDateRange: DateTimeRange(start: _dataInicio, end: _dataFim),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppTheme.primaryColor,
                          onPrimary: Colors.white,
                          surface: Color(0xFF1E1E1E),
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    setState(() {
                      _dataInicio = picked.start;
                      _dataFim = picked.end;
                    });
                  }
                },
                icon: const Icon(Icons.date_range_rounded, size: 18),
                label: Text('${Formatters.date(_dataInicio)} - ${Formatters.date(_dataFim)}'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: dataAsync.when(
              loading: () => const LoadingOverlay(message: 'Agrupando recebimentos...'),
              error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
              data: (list) {
                if (list.isEmpty) {
                  return const EmptyState(
                    icon: Icons.pie_chart_outline_rounded,
                    title: 'Sem dados de vendas',
                    subtitle: 'Nenhum pagamento registrado no período selecionado.',
                  );
                }

                final double totalPeriodo = list.fold(0.0, (sum, item) => sum + (item['valor_total'] as num).toDouble());

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: SizedBox(
                          height: 280,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                  setState(() {
                                    if (!event.isInterestedForInteractions ||
                                        pieTouchResponse == null ||
                                        pieTouchResponse.touchedSection == null) {
                                      _touchedIndex = -1;
                                      return;
                                    }
                                    _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 4,
                              centerSpaceRadius: 60,
                              sections: List.generate(list.length, (i) {
                                final item = list[i];
                                final isTouched = i == _touchedIndex;
                                final double value = (item['valor_total'] as num).toDouble();
                                final double percent = (item['percentual'] as num).toDouble();
                                final String name = item['forma_pagamento'] ?? 'Outros';
                                final color = _getPaymentMethodColor(name);
                                final double radius = isTouched ? 65.0 : 55.0;

                                return PieChartSectionData(
                                  color: color,
                                  value: value,
                                  title: percent >= 8 ? '${percent.toStringAsFixed(1)}%' : '',
                                  radius: radius,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Faturamento no Período: ${Formatters.currency(totalPeriodo)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: list.length,
                              separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white10),
                              itemBuilder: (context, i) {
                                final item = list[i];
                                final String name = item['forma_pagamento'] ?? 'Outros';
                                final double value = (item['valor_total'] as num).toDouble();
                                final double percent = (item['percentual'] as num).toDouble();
                                final int count = (item['total_vendas'] as num).toInt();
                                final color = _getPaymentMethodColor(name);
                                final isSelected = i == _touchedIndex;

                                return Container(
                                  color: isSelected ? Colors.white.withOpacity(0.05) : Colors.transparent,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: color.withOpacity(0.15),
                                      child: Icon(_getPaymentMethodIcon(name), color: color, size: 20),
                                    ),
                                    title: Text(
                                      name,
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        color: Colors.white,
                                      ),
                                    ),
                                    subtitle: Text('$count transações', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(Formatters.currency(value), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                        Text('${percent.toStringAsFixed(1)}%', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportComprasVendasView extends ConsumerStatefulWidget {
  const _ReportComprasVendasView();
  @override
  ConsumerState<_ReportComprasVendasView> createState() => _ReportComprasVendasViewState();
}

class _ReportComprasVendasViewState extends ConsumerState<_ReportComprasVendasView> {
  DateTime _dataInicio = DateTime.now().subtract(const Duration(days: 30));
  DateTime _dataFim = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataAsync = ref.watch(comprasVendasReportProvider(
      dataInicio: Formatters.dateForApi(_dataInicio),
      dataFim: Formatters.dateForApi(_dataFim),
    ));

    return Container(
      decoration: AppTheme.glassCard(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📈 Balanço: Compras vs. Vendas', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Comparativo de saídas com fornecedores vs. faturamento bruto no período', style: theme.textTheme.bodySmall),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    initialDateRange: DateTimeRange(start: _dataInicio, end: _dataFim),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppTheme.primaryColor,
                          onPrimary: Colors.white,
                          surface: Color(0xFF1E1E1E),
                          onSurface: Colors.white,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    setState(() {
                      _dataInicio = picked.start;
                      _dataFim = picked.end;
                    });
                  }
                },
                icon: const Icon(Icons.date_range_rounded, size: 18),
                label: Text('${Formatters.date(_dataInicio)} - ${Formatters.date(_dataFim)}'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: dataAsync.when(
              loading: () => const LoadingOverlay(message: 'Consolidando balanço financeiro...'),
              error: (e, _) => EmptyState(icon: Icons.error_outline, title: 'Erro', subtitle: '$e'),
              data: (list) {
                if (list.isEmpty) {
                  return const EmptyState(
                    icon: Icons.analytics_outlined,
                    title: 'Balanço Vazio',
                    subtitle: 'Sem movimentações de compras ou vendas no período.',
                  );
                }

                double totalVendas = 0;
                double totalCompras = 0;
                for (final item in list) {
                  totalVendas += (item['total_vendas'] as num).toDouble();
                  totalCompras += (item['total_compras'] as num).toDouble();
                }
                final double saldoLiquido = totalVendas - totalCompras;

                final List<FlSpot> spotsVendas = [];
                final List<FlSpot> spotsCompras = [];
                
                for (int i = 0; i < list.length; i++) {
                  final double v = (list[i]['total_vendas'] as num).toDouble();
                  final double c = (list[i]['total_compras'] as num).toDouble();
                  spotsVendas.add(FlSpot(i.toDouble(), v));
                  spotsCompras.add(FlSpot(i.toDouble(), c));
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _KPICard(
                            title: 'Faturamento (Entradas)',
                            value: Formatters.currency(totalVendas),
                            icon: Icons.trending_up_rounded,
                            color: Colors.greenAccent,
                          ),
                          _KPICard(
                            title: 'Compras (Saídas)',
                            value: Formatters.currency(totalCompras),
                            icon: Icons.trending_down_rounded,
                            color: Colors.orangeAccent,
                          ),
                          _KPICard(
                            title: 'Saldo Líquido',
                            value: Formatters.currency(saldoLiquido),
                            icon: Icons.account_balance_wallet_rounded,
                            color: saldoLiquido >= 0 ? Colors.cyanAccent : Colors.redAccent,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text('Análise do Fluxo Diário', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Container(
                        height: 280,
                        padding: const EdgeInsets.only(top: 20, right: 20, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: true, drawVerticalLine: false),
                            titlesData: FlTitlesData(
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 46,
                                  getTitlesWidget: (val, meta) => Text(
                                    val >= 1000 ? '${(val / 1000).toStringAsFixed(1)}k' : val.toInt().toString(),
                                    style: const TextStyle(color: Colors.white30, fontSize: 10),
                                  ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 22,
                                  getTitlesWidget: (val, meta) {
                                    final int idx = val.toInt();
                                    if (idx >= 0 && idx < list.length) {
                                      if (list.length <= 10 || idx % (list.length ~/ 5 + 1) == 0) {
                                        final parts = (list[idx]['data'] as String).split('-');
                                        if (parts.length == 3) {
                                          return Text('${parts[2]}/${parts[1]}', style: const TextStyle(color: Colors.white38, fontSize: 10));
                                        }
                                      }
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineTouchData: LineTouchData(
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (spot) => const Color(0xFF2C2C2C).withOpacity(0.9),
                                tooltipRoundedRadius: 8,
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    final int idx = spot.x.toInt();
                                    final date = list[idx]['data'] as String;
                                    final parts = date.split('-');
                                    final formattedDate = parts.length == 3 ? '${parts[2]}/${parts[1]}' : date;
                                    
                                    final isSales = spot.barIndex == 0;
                                    final type = isSales ? 'Vendas' : 'Compras';
                                    final color = isSales ? Colors.greenAccent : Colors.orangeAccent;
                                    
                                    return LineTooltipItem(
                                      '$formattedDate - $type:\n${Formatters.currency(spot.y)}',
                                      TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spotsVendas,
                                isCurved: true,
                                color: Colors.greenAccent,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.greenAccent.withOpacity(0.05),
                                ),
                              ),
                              LineChartBarData(
                                spots: spotsCompras,
                                isCurved: true,
                                color: Colors.orangeAccent,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.orangeAccent.withOpacity(0.05),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text('Vendas (Faturamento)', style: TextStyle(color: Colors.white54, fontSize: 11)),
                          const SizedBox(width: 24),
                          Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text('Compras (Fornecedores)', style: TextStyle(color: Colors.white54, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text('📄 Detalhamento por Dia', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DataTable(
                          headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                          columns: const [
                            DataColumn(label: Text('DATA')),
                            DataColumn(label: Text('VENDAS (ENTRADAS)'), numeric: true),
                            DataColumn(label: Text('COMPRAS (SAÍDAS)'), numeric: true),
                            DataColumn(label: Text('SALDO LÍQUIDO'), numeric: true),
                          ],
                          rows: list.reversed.map((item) {
                            final date = item['data'] as String;
                            final parts = date.split('-');
                            final formattedDate = parts.length == 3 ? '${parts[2]}/${parts[1]}' : date;
                            final double v = (item['total_vendas'] as num).toDouble();
                            final double c = (item['total_compras'] as num).toDouble();
                            final double diff = v - c;

                            return DataRow(
                              cells: [
                                DataCell(Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.w600))),
                                DataCell(Text(Formatters.currency(v), style: const TextStyle(color: Colors.greenAccent))),
                                DataCell(Text(Formatters.currency(c), style: const TextStyle(color: Colors.orangeAccent))),
                                DataCell(
                                  Text(
                                    Formatters.currency(diff),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: diff >= 0 ? Colors.cyanAccent : Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
