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

class PurchasesHelpDialog extends StatefulWidget {
  const PurchasesHelpDialog({super.key});

  @override
  State<PurchasesHelpDialog> createState() => _PurchasesHelpDialogState();
}

class _PurchasesHelpDialogState extends State<PurchasesHelpDialog> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<_HelpCategory> _categories = const [
    _HelpCategory(
      title: 'Aba: Histórico de Compras',
      icon: Icons.history_rounded,
      items: [
        _HelpItem(
          title: 'Histórico de Lançamentos',
          categoryName: 'Aba: Histórico de Compras',
          finalidade: 'Consultar, conferir e auditar todas as compras de produtos registradas na empresa.',
          utilidade: 'Exibe a listagem completa com colunas de Fornecedor, Nº Nota Fiscal, Data de Emissão, Valor Total e ações. Possui barra de pesquisa por fornecedor/nota e paginação para navegação rápida.',
          indicadores: [
            'Coluna de Fornecedor da compra',
            'Coluna do Nº da Nota Fiscal informada',
            'Coluna com a Data de Emissão do documento',
            'Coluna com o Valor Total bruto da compra',
            'Filtro de busca por termo e controle de paginação'
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Aba: Fornecedores',
      icon: Icons.business_rounded,
      items: [
        _HelpItem(
          title: 'Gestão de Fornecedores',
          categoryName: 'Aba: Fornecedores',
          finalidade: 'Visualizar, cadastrar, editar e remover parceiros comerciais cadastrados.',
          utilidade: 'Tabela principal com colunas de Razão Social, Nome Fantasia, CNPJ e Telefone. Inclui botão de cadastro e ações por linha: Visualizar Detalhes (diálogo Teal de 3 abas sem risco de edição), Editar dados e Excluir.',
          indicadores: [
            'Coluna com a Razão Social e Nome Fantasia',
            'Coluna com o CNPJ do fornecedor',
            'Coluna com o Telefone principal do contato',
            'Botão para Visualizar Detalhes em modo leitura rápida',
            'Botão de Edição e remoção segura do registro'
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Aba: Consultas por Fornecedor',
      icon: Icons.analytics_rounded,
      items: [
        _HelpItem(
          title: 'Estatísticas & Gráficos',
          categoryName: 'Aba: Consultas por Fornecedor',
          finalidade: 'Análise gerencial do volume de compras acumulado por fornecedor.',
          utilidade: 'Painel com gráficos analíticos e tabelas que somam e consolidam as compras por parceiro, ajudando a identificar quais fornecedores concentram a maior fatia das reposições do seu estoque.',
          indicadores: [
            'Gráfico de distribuição e representação financeira',
            'Tabela com totais acumulados por fornecedor',
            'Controle de volume comprado por parceiro comercial'
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Botão: Nova Compra',
      icon: Icons.add_shopping_cart_rounded,
      items: [
        _HelpItem(
          title: 'Formulário de Entrada',
          categoryName: 'Botão: Nova Compra',
          finalidade: 'Lançar novas entradas de mercadorias e atualizar o estoque físico.',
          utilidade: 'Abre a janela flutuante para preenchimento dos dados. Permite selecionar o fornecedor, inserir o Nº da Nota Fiscal, buscar produtos para adicionar ao carrinho e editar os campos de item (Qtd, Preço de Custo, Localização, Validade e Lote).',
          indicadores: [
            'Seleção do Fornecedor e Nº da Nota Fiscal',
            'Carrinho dinâmico de produtos selecionados',
            'Edição por item: Qtd, Custo, Lote, Validade e Localização',
            'Soma automática do TOTAL DA COMPRA no rodapé',
            'Botões de Ação: Cancelar ou Finalizar Compra'
          ],
        ),
      ],
    ),
  ];

  Color _getCategoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'aba: histórico de compras': return Colors.teal;
      case 'aba: fornecedores': return Colors.amber;
      case 'aba: consultas por fornecedor': return Colors.blue;
      case 'botão: nova compra': return Colors.green;
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
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.help_outline_rounded, color: Colors.teal, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manual de Gestão de Compras',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Guia explicativo sobre a finalidade, utilidade e funcionamento das telas e recursos de compras',
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Pesquise por abas, botões ou termos (ex: histórico, fornecedor, nova compra)...',
                    prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                    suffixIcon: _searchQuery.isNotEmpty  
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = "");
                          },
                        )
                      : null,
                    filled: true,
                    fillColor: isDark ? const Color(0xFF161622) : Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_searchQuery.isEmpty) ...[
                      Container(
                        width: 240,
                        color: isDark ? const Color(0xFF181824) : Colors.grey[50],
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          itemCount: _categories.length,
                          itemBuilder: (context, idx) {
                            final cat = _categories[idx];
                            final isSel = idx == _selectedCategoryIndex;
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: Icon(
                                  cat.icon, 
                                  color: isSel 
                                    ? _getCategoryColor(cat.title) 
                                    : (isDark ? Colors.white38 : Colors.black38),
                                  size: 20,
                                ),
                                title: Text(
                                  cat.title,
                                  style: TextStyle(
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                    color: isSel 
                                      ? (isDark ? Colors.white : Colors.black87)
                                      : (isDark ? Colors.white60 : Colors.black54),
                                    fontSize: 14,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                tileColor: isSel 
                                  ? _getCategoryColor(cat.title).withOpacity(0.12)
                                  : Colors.transparent,
                                hoverColor: Colors.teal.withOpacity(0.05),
                                onTap: () => setState(() => _selectedCategoryIndex = idx),
                              ),
                            );
                          },
                        ),
                      ),
                      VerticalDivider(width: 1, color: isDark ? Colors.white10 : Colors.black12),
                    ],
                    Expanded(
                      child: Container(
                        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                        child: _searchQuery.isNotEmpty && searchResults.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[600]),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nenhum tópico encontrado',
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Tente pesquisar com termos mais simples.',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(32),
                              itemCount: _searchQuery.isNotEmpty 
                                ? searchResults.length 
                                : _categories[_selectedCategoryIndex].items.length,
                              itemBuilder: (context, idx) {
                                final item = _searchQuery.isNotEmpty
                                  ? searchResults[idx]
                                  : _categories[_selectedCategoryIndex].items[idx];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 24),
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF242438) : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.title,
                                            style: theme.textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: _getCategoryColor(item.categoryName).withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: _getCategoryColor(item.categoryName).withOpacity(0.3),
                                              ),
                                            ),
                                            child: Text(
                                              item.categoryName,
                                              style: TextStyle(
                                                color: _getCategoryColor(item.categoryName),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.info_outline_rounded, color: Colors.teal, size: 18),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                    color: isDark ? Colors.white70 : Colors.black87,
                                                  ),
                                                  children: [
                                                    const TextSpan(text: 'Finalidade: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                    TextSpan(text: item.finalidade),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.insights_rounded, color: Colors.orangeAccent, size: 18),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                    color: isDark ? Colors.white70 : Colors.black87,
                                                  ),
                                                  children: [
                                                    const TextSpan(text: 'Utilidade Prática: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                                    TextSpan(text: item.utilidade),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Aspectos Chave:',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                                        ),
                                        const SizedBox(height: 8),
                                        ...item.indicadores.map((ind) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(top: 6),
                                                  child: Icon(Icons.circle, size: 6, color: Colors.tealAccent),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    ind,
                                                    style: theme.textTheme.bodyMedium?.copyWith(
                                                      color: isDark ? Colors.white70 : Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  );
                                },
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
  }
