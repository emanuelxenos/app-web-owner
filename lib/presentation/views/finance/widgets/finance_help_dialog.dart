import 'package:flutter/material.dart';

class _HelpCategory {
  final String title;
  final IconData icon;
  final List<_HelpItem> items;
  const _HelpCategory({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class _HelpItem {
  final String title;
  final String categoryName;
  final String finalidade;
  final String utilidade;
  final List<String> indicadores;
  const _HelpItem({
    required this.title,
    required this.categoryName,
    required this.finalidade,
    required this.utilidade,
    required this.indicadores,
  });
}

class FinanceHelpDialog extends StatefulWidget {
  const FinanceHelpDialog({super.key});

  @override
  State<FinanceHelpDialog> createState() => _FinanceHelpDialogState();
}

class _FinanceHelpDialogState extends State<FinanceHelpDialog> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<_HelpCategory> _categories = const [
    _HelpCategory(
      title: 'Aba: Contas a Pagar',
      icon: Icons.money_off_csred_rounded,
      items: [
        _HelpItem(
          title: 'Gestão de Despesas e Obrigações',
          categoryName: 'Aba: Contas a Pagar',
          finalidade:
              'Registrar, organizar e liquidar todas as obrigações financeiras da empresa.',
          utilidade:
              'Exibe a listagem completa de despesas (fornecedores, contas de consumo, impostos). Permite dar baixa nos pagamentos e excluir lançamentos manuais. Ajuda a evitar juros por atraso acompanhando a coluna de vencimento.',
          indicadores: [
            'Filtros por período',
            'Indicadores de status (Aberta, Paga, Cancelada)',
            'Soma automática do total a pagar na página',
            'Ação para registrar pagamento na hora (ícone de cheque)',
            'Paginação para listar grandes volumes rapidamente',
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Aba: Contas a Receber',
      icon: Icons.attach_money_rounded,
      items: [
        _HelpItem(
          title: 'Gestão de Recebimentos e Faturamento',
          categoryName: 'Aba: Contas a Receber',
          finalidade:
              'Acompanhar todo o dinheiro que deve entrar no caixa, incluindo vendas a prazo e pagamentos parcelados.',
          utilidade:
              'Lista as contas de clientes e outras entradas. Muito útil para cobrar clientes inadimplentes e prever o caixa futuro. Permite registrar o recebimento ou remover contas geradas indevidamente.',
          indicadores: [
            'Coluna com Data de Vencimento',
            'Indicadores visuais de atraso',
            'Soma automática do total a receber',
            'Botão para confirmação de recebimento do valor',
            'Paginação inteligente por lotes de 50 registros',
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Aba: Extrato de Fluxo',
      icon: Icons.account_balance_rounded,
      items: [
        _HelpItem(
          title: 'Histórico Completo de Movimentações',
          categoryName: 'Aba: Extrato de Fluxo',
          finalidade:
              'Auditar o fluxo real de entradas e saídas de capital de todos os caixas e contas bancárias do sistema.',
          utilidade:
              'Exibe cada movimentação (crédito e débito) ocorrida no período selecionado. Excelente para reconciliação bancária, fechamento mensal e compreensão de onde o dinheiro está indo.',
          indicadores: [
            'Valores positivos (verde) para entradas',
            'Valores negativos (vermelho) para saídas',
            'Exibição do saldo acumulado do período no painel',
            'Data e tipo da operação registradas precisamente',
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Indicadores e Gráficos',
      icon: Icons.insert_chart_rounded,
      items: [
        _HelpItem(
          title: 'Dashboard Financeiro',
          categoryName: 'Indicadores e Gráficos',
          finalidade: 'Análise gerencial da saúde financeira do negócio.',
          utilidade:
              'Painel visual localizado acima das abas, mostrando as tendências de entradas e saídas do caixa. Facilita muito a visualização da margem operacional (se o negócio está no azul ou no vermelho).',
          indicadores: [
            'Gráfico em barras de Receitas vs Despesas',
            'Tooltips detalhados passando o mouse no gráfico',
            'Cartões totalizadores (Entradas Totais, Saídas Totais, Saldo)',
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Lançamentos Manuais',
      icon: Icons.edit_note_rounded,
      items: [
        _HelpItem(
          title: 'Registro de Novas Despesas e Entradas',
          categoryName: 'Lançamentos Manuais',
          finalidade:
              'Permitir a inclusão de movimentações que não nascem automaticamente (como vendas de PDV).',
          utilidade:
              'Botões localizados no cabeçalho ("Nova Despesa" e "Nova Entrada") que abrem um formulário simples para alimentar as contas a pagar ou a receber.',
          indicadores: [
            'Botão vermelho para cadastrar obrigações (Nova Despesa)',
            'Botão verde para lançamentos diversos (Nova Entrada)',
            'Categorização inteligente do lançamento (ex: Aluguel, Imposto)',
            'Lançamento automático na tabela correspondente',
          ],
        ),
      ],
    ),
  ];

  Color _getCategoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'aba: contas a pagar':
        return Colors.redAccent;
      case 'aba: contas a receber':
        return Colors.green;
      case 'aba: extrato de fluxo':
        return Colors.blue;
      case 'indicadores e gráficos':
        return Colors.purple;
      case 'lançamentos manuais':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    List<_HelpItem> searchResults = [];
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      for (var cat in _categories) {
        for (var item in cat.items) {
          if (item.title.toLowerCase().contains(q) ||
              item.finalidade.toLowerCase().contains(q) ||
              item.utilidade.toLowerCase().contains(q) ||
              item.categoryName.toLowerCase().contains(q) ||
              item.indicadores.any((ind) => ind.toLowerCase().contains(q))) {
            searchResults.add(item);
          }
        }
      }
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Container(
        width: 1000,
        height: 700,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black12,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(32, 24, 24, 20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF181824) : Colors.grey[50],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.help_outline_rounded,
                            color: Colors.blue,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manual de Gestão Financeira',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Guia explicativo sobre a finalidade, utilidade e funcionamento das telas de finanças',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 24,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 280,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF181824)
                            : Colors.grey[50],
                        border: Border(
                          right: BorderSide(
                            color: isDark ? Colors.white10 : Colors.black12,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) =>
                                  setState(() => _searchQuery = v),
                              decoration: InputDecoration(
                                hintText: 'Pesquisar...',
                                prefixIcon: const Icon(Icons.search, size: 20),
                                filled: true,
                                fillColor: isDark
                                    ? Colors.white10
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                final cat = _categories[index];
                                final isSelected =
                                    _selectedCategoryIndex == index &&
                                    _searchQuery.isEmpty;
                                final catColor = _getCategoryColor(cat.title);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      cat.icon,
                                      color: isSelected
                                          ? catColor
                                          : Colors.grey,
                                    ),
                                    title: Text(
                                      cat.title,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? (isDark
                                                  ? Colors.white
                                                  : Colors.black)
                                            : Colors.grey,
                                      ),
                                    ),
                                    selected: isSelected,
                                    selectedTileColor: catColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _searchQuery = '';
                                        _searchController.clear();
                                        _selectedCategoryIndex = index;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                        child: _searchQuery.isNotEmpty
                            ? _buildSearchResults(searchResults, theme, isDark)
                            : _buildCategoryDetail(
                                _categories[_selectedCategoryIndex],
                                theme,
                                isDark,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    List<_HelpItem> results,
    ThemeData theme,
    bool isDark,
  ) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum resultado encontrado',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(32),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        final item = results[index];
        return _buildHelpCard(item, theme, isDark, showCategory: true);
      },
    );
  }

  Widget _buildCategoryDetail(
    _HelpCategory category,
    ThemeData theme,
    bool isDark,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(32),
      itemCount: category.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        return _buildHelpCard(category.items[index], theme, isDark);
      },
    );
  }

  Widget _buildHelpCard(
    _HelpItem item,
    ThemeData theme,
    bool isDark, {
    bool showCategory = false,
  }) {
    final catColor = _getCategoryColor(item.categoryName);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252538) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showCategory) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.categoryName,
                style: TextStyle(
                  color: catColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            item.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FINALIDADE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(item.finalidade, style: const TextStyle(height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.build_rounded,
                  color: Colors.green,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'COMO UTILIZAR',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(item.utilidade, style: const TextStyle(height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Principais Indicadores e Recursos:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.indicadores
                .map(
                  (ind) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.black12,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: catColor,
                        ),
                        const SizedBox(width: 8),
                        Text(ind, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
