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

class CustomersHelpDialog extends StatefulWidget {
  const CustomersHelpDialog({super.key});

  @override
  State<CustomersHelpDialog> createState() => _CustomersHelpDialogState();
}

class _CustomersHelpDialogState extends State<CustomersHelpDialog> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<_HelpCategory> _categories = const [
    _HelpCategory(
      title: 'Visão Geral',
      icon: Icons.people_alt_rounded,
      items: [
        _HelpItem(
          title: 'Cadastro de Clientes',
          categoryName: 'Visão Geral',
          finalidade: 'Manter a base de clientes atualizada para uso em vendas e crediário.',
          utilidade: 'Permite identificar quem compra na loja, controlar os pagamentos a prazo (fiado/crediário) e manter contato.',
          indicadores: [
            'Nome e documento (CPF/CNPJ)',
            'Telefone e endereço de contato',
            'Limite de crédito e Saldo devedor'
          ],
        ),
        _HelpItem(
          title: 'Saldo Devedor vs Limite',
          categoryName: 'Visão Geral',
          finalidade: 'Monitorar o quanto o cliente deve à loja em comparação ao limite concedido.',
          utilidade: 'Ajuda a evitar a venda para clientes que já atingiram seu limite, prevenindo a inadimplência.',
          indicadores: [
            'Saldo Devedor: Valor total que o cliente ainda não pagou.',
            'Limite de Crédito: Valor máximo que a loja permite vender a prazo para este cliente.'
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Gestão de Crédito',
      icon: Icons.credit_card_rounded,
      items: [
        _HelpItem(
          title: 'Ações em Lote',
          categoryName: 'Gestão de Crédito',
          finalidade: 'Realizar alterações rápidas em vários clientes de uma só vez.',
          utilidade: 'Economiza tempo quando o gerente decide reajustar o limite de vários clientes ou inativar vários devedores de uma vez.',
          indicadores: [
            'Selecione os clientes na caixa de seleção (checkbox).',
            'Reajustar Limite: Aumenta ou diminui o limite dos selecionados.',
            'Inativar Selecionados: Impede os selecionados de realizarem novas compras a prazo.'
          ],
        ),
        _HelpItem(
          title: 'Filtros Avançados',
          categoryName: 'Gestão de Crédito',
          finalidade: 'Localizar clientes com características específicas, como inadimplência ou por faixa de limite.',
          utilidade: 'Ideal para campanhas de cobrança, filtrando apenas clientes que estão devendo e em atraso (Inadimplentes).',
          indicadores: [
            'Tipo de pessoa (Física/Jurídica)',
            'Faixa de limite (ex: de R\$ 100 até R\$ 500)',
            'Apenas inadimplentes'
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Ações e Relatórios',
      icon: Icons.print_rounded,
      items: [
        _HelpItem(
          title: 'Exportar Base',
          categoryName: 'Ações e Relatórios',
          finalidade: 'Gerar um arquivo com a listagem de clientes em PDF ou Excel (CSV).',
          utilidade: 'Muito útil para enviar a lista de contatos ou devedores para a equipe de cobrança externa ou contabilidade.',
          indicadores: [
            'Exportação em PDF (pronto para impressão)',
            'Exportação em CSV (para abrir no Excel e fazer gráficos)'
          ],
        ),
        _HelpItem(
          title: 'Inativos',
          categoryName: 'Ações e Relatórios',
          finalidade: 'Ocultar clientes que não compram mais para manter a lista limpa.',
          utilidade: 'Os clientes inativos não aparecem na tela de vendas. Para ver os inativos, basta marcar a opção \"Mostrar Inativos\".',
          indicadores: [
            'Clientes inativos têm o status vermelho na tabela.',
            'Para reativar, clique no ícone de lápis e mude o status para Ativo.'
          ],
        ),
        _HelpItem(
          title: 'Histórico Financeiro',
          categoryName: 'Ações e Relatórios',
          finalidade: 'Acompanhar de forma detalhada e centralizada todas as compras e amortizações (pagamentos) de cada cliente.',
          utilidade: 'Oferece uma visão dividida (Master-Detail) com busca e filtros por data/período e paginação local, vinculando cada pagamento diretamente à respectiva compra.',
          indicadores: [
            'Lista de compras paginada (5 por página) com barra de busca rápida no painel esquerdo.',
            'Filtros rápidos de período (Tudo, Hoje, 30d) e calendário personalizado por intervalo de datas.',
            'Painel de detalhes no lado direito com indicadores de Total, Pago, Saldo Restante e dados de caixa.',
            'Botão para \"Registrar Amortização / Pagamento\" direto a partir da compra selecionada.',
            'Listagem cronológica de amortizações pertencentes àquela compra específica no painel direito.'
          ],
        ),
      ],
    ),
  ];

  Color _getCategoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'visão geral': return Colors.blueAccent;
      case 'gestão de crédito': return Colors.green;
      case 'ações e relatórios': return Colors.purpleAccent;
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
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.help_outline_rounded, color: Colors.blueAccent, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Central de Ajuda de Clientes',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Entenda o funcionamento da tela e como gerenciar o crédito',
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
                    hintText: 'Pesquise por cadastro, limite, inadimplência, exportar...',
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
                                hoverColor: Colors.blueAccent.withOpacity(0.05),
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
                                          const Icon(Icons.info_outline_rounded, color: Colors.blueAccent, size: 18),
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
                                          const Icon(Icons.insights_rounded, color: Colors.purpleAccent, size: 18),
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
                                        'Indicadores / Detalhes:',
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
                                                child: Icon(Icons.circle, size: 6, color: Colors.greenAccent),
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
