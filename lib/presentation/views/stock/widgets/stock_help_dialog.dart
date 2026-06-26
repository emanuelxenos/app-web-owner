import 'package:flutter/material.dart';

class _HelpCategory {
  final String title;
  final IconData icon;
  final List<_HelpItem> items;
  const _HelpCategory({required this.title, required this.icon, required this.items});
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

class StockHelpDialog extends StatefulWidget {
  const StockHelpDialog({super.key});

  @override
  State<StockHelpDialog> createState() => _StockHelpDialogState();
}

class _StockHelpDialogState extends State<StockHelpDialog> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<_HelpCategory> _categories = const [
    _HelpCategory(
      title: 'Ações Globais da Tela',
      icon: Icons.bolt_rounded,
      items: [
        _HelpItem(
          title: 'Botões Superiores (Cabeçalho)',
          categoryName: 'Ações Globais da Tela',
          finalidade: 'Ações administrativas rápidas que afetam o estoque como um todo ou geram relatórios consolidados.',
          utilidade: 'Registrar perdas de estoque, exportar listagens para acompanhamento externo e obter auxílio sobre o que repor no estoque.',
          indicadores: [
            'Botão "Registrar Perda": Usado para dar baixa em produtos danificados ou perdidos.',
            'Botão "Exportar PDF/Excel": Gera arquivos da lista atual da tela com todos os dados visíveis.',
            'Botão "Sugestão de Compra": Exibe uma análise do que precisa ser comprado para repor estoques críticos.',
            'Atalhos de teclado (Ctrl+F, Alt+S, Alt+P) para facilitar o uso para quem usa muito teclado.',
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Aba: Posição Atual',
      icon: Icons.inventory_2_rounded,
      items: [
        _HelpItem(
          title: 'Visão Geral e Busca',
          categoryName: 'Aba: Posição Atual',
          finalidade: 'Fornecer uma visão imediata de todos os produtos cadastrados e seus níveis atuais.',
          utilidade: 'Permite consultar rapidamente quantidades, identificar itens abaixo do estoque mínimo e produtos próximos ao vencimento, além de mostrar indicadores gerais da loja.',
          indicadores: [
            'Cartões de KPIs: Mostra total de itens, estoque baixo, valor de custo, valor de reposição e itens vencendo em 15 dias.',
            'Filtros rápidos (Estoque Baixo, Vencendo, Reposição) e Dropdown de Categorias para refinar a busca.',
            'Barra de pesquisa de produtos.',
          ],
        ),
        _HelpItem(
          title: 'Ações por Produto (Linha da Tabela)',
          categoryName: 'Aba: Posição Atual',
          finalidade: 'Executar ações individuais diretamente em um produto listado.',
          utilidade: 'Permite gerenciar detalhes específicos de um item sem precisar ir para outra tela.',
          indicadores: [
            'Clique no Nome/Foto: Abre a tela de "Performance do Produto".',
            'Ícone "Ver Lotes" (Azul): Mostra todos os lotes registrados para aquele produto.',
            'Ícone "Imprimir Etiqueta" (Laranja): Gera etiqueta individual do produto.',
            'Ícone "Ajustar" (Verde/Azul): Abre o modal de Ajuste de Estoque para dar entrada ou saída avulsa.',
          ],
        ),
        _HelpItem(
          title: 'Ações em Massa (Checkbox)',
          categoryName: 'Aba: Posição Atual',
          finalidade: 'Selecionar múltiplos produtos simultaneamente.',
          utilidade: 'Ao marcar produtos na caixa de seleção (checkbox), surge uma barra flutuante no topo para aplicar uma mesma ação a todos, como Imprimir Etiquetas em Lote.',
          indicadores: [
            'Checkbox na primeira coluna da tabela.',
            'Barra flutuante superior com botão "Imprimir Etiquetas Lote".',
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Aba: Histórico',
      icon: Icons.history_rounded,
      items: [
        _HelpItem(
          title: 'Auditoria de Movimentações',
          categoryName: 'Aba: Histórico',
          finalidade: 'Registrar de forma imutável toda e qualquer alteração de quantidade no estoque.',
          utilidade: 'Exibe o registro de entradas e saídas. Útil para verificar perdas, ajustes, inventários e identificar exatamente quando o estoque de um item foi modificado e por qual motivo.',
          indicadores: [
            'Filtros por Tipo (Entrada, Saída, Ajuste, Inventário).',
            'Selo informativo de LOTE quando houver lote registrado na movimentação.',
            'Seta verde (Para Cima): Acréscimo no estoque.',
            'Seta vermelha (Para Baixo): Baixa/Retirada no estoque.',
            'Filtro de período (Datas) e opção rápida "Hoje".',
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Aba: Inventários',
      icon: Icons.fact_check_rounded,
      items: [
        _HelpItem(
          title: 'Gestão de Balanços (Inventários)',
          categoryName: 'Aba: Inventários',
          finalidade: 'Agendar e controlar sessões de contagem (balanço) do estoque.',
          utilidade: 'Permite criar um inventário e listar quais itens serão contados. Após a contagem, o sistema corrige as quantidades registradas com base no que foi informado manualmente na tela de contagem.',
          indicadores: [
            'Botão "Novo Inventário" para criar um balanço.',
            'Lista de balanços por status visual (letra indicativa da situação).',
            'Navegação: Clicar sobre um inventário abre a tela de contagem.',
            'Filtro de período para achar inventários passados.',
          ],
        ),
      ],
    ),
  ];

  Color _getCategoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'ações globais da tela': return Colors.purple;
      case 'aba: posição atual': return Colors.blue;
      case 'aba: histórico': return Colors.orange;
      case 'aba: inventários': return Colors.green;
      default: return Colors.grey;
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
          border: Border.all(color: isDark ? Colors.white10 : Colors.black12, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 10),
            )
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
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.help_outline_rounded, color: Colors.blue, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manual de Gestão de Estoque',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Guia explicativo sobre as ações globais e abas da tela',
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
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
                        color: isDark ? const Color(0xFF181824) : Colors.grey[50],
                        border: Border(right: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) => setState(() => _searchQuery = v),
                              decoration: InputDecoration(
                                hintText: 'Pesquisar...',
                                prefixIcon: const Icon(Icons.search, size: 20),
                                filled: true,
                                fillColor: isDark ? Colors.white10 : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                final cat = _categories[index];
                                final isSelected = _selectedCategoryIndex == index && _searchQuery.isEmpty;
                                final catColor = _getCategoryColor(cat.title);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  child: ListTile(
                                    leading: Icon(cat.icon, color: isSelected ? catColor : Colors.grey),
                                    title: Text(
                                      cat.title,
                                      style: TextStyle(
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.grey,
                                      ),
                                    ),
                                    selected: isSelected,
                                    selectedTileColor: catColor.withOpacity(0.1),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                            : _buildCategoryDetail(_categories[_selectedCategoryIndex], theme, isDark),
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

  Widget _buildSearchResults(List<_HelpItem> results, ThemeData theme, bool isDark) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text('Nenhum resultado encontrado', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
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

  Widget _buildCategoryDetail(_HelpCategory category, ThemeData theme, bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.all(32),
      itemCount: category.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        return _buildHelpCard(category.items[index], theme, isDark);
      },
    );
  }

  Widget _buildHelpCard(_HelpItem item, ThemeData theme, bool isDark, {bool showCategory = false}) {
    final catColor = _getCategoryColor(item.categoryName);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252538) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showCategory) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                item.categoryName,
                style: TextStyle(color: catColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            item.title,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flag_rounded, color: Colors.blue, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('FINALIDADE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
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
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.build_rounded, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('COMO UTILIZAR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(height: 4),
                    Text(item.utilidade, style: const TextStyle(height: 1.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Principais Indicadores e Recursos:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: item.indicadores.map((ind) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(Icons.check_circle_rounded, size: 16, color: catColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(ind, style: const TextStyle(fontSize: 13))),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
