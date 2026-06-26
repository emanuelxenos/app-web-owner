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

class ReportsHelpDialog extends StatefulWidget {
  const ReportsHelpDialog({super.key});

  @override
  State<ReportsHelpDialog> createState() => _ReportsHelpDialogState();
}

class _ReportsHelpDialogState extends State<ReportsHelpDialog> {
  int _selectedCategoryIndex = 0;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<_HelpCategory> _categories = const [
    _HelpCategory(
      title: 'Operacional',
      icon: Icons.today_rounded,
      items: [
        _HelpItem(
          title: 'Vendas Hoje',
          categoryName: 'Operacional',
          finalidade: 'Acompanhamento em tempo real do desempenho do caixa no dia atual.',
          utilidade: 'Permite ao supervisor verificar se a meta diária de vendas está próxima, monitorar a quantidade de vendas abertas/fechadas e identificar o faturamento bruto acumulado até o minuto atual.',
          indicadores: [
            'Faturamento Bruto do Dia (R\$)',
            'Quantidade de Vendas Realizadas',
            'Ticket Médio do Dia',
            'Listagem cronológica de cada venda (horário, operador, cliente e valor)'
          ],
        ),
        _HelpItem(
          title: 'Vendas do Mês',
          categoryName: 'Operacional',
          finalidade: 'Analisar o faturamento bruto e volume comercial do mês corrente.',
          utilidade: 'Essencial para comparar o desempenho do mês atual com os meses anteriores, auxiliando na projeção de metas e fluxo de caixa de curto prazo.',
          indicadores: [
            'Faturamento Mensal Acumulado',
            'Média Diária de Faturamento',
            'Crescimento percentual em relação ao mesmo período do mês passado',
            'Gráfico de barras indicando a flutuação diária das vendas'
          ],
        ),
        _HelpItem(
          title: 'Mais Vendidos',
          categoryName: 'Operacional',
          finalidade: 'Identificar quais itens possuem maior giro de saída (Curva de Giro).',
          utilidade: 'Ajuda o departamento de compras a planejar a reposição, garantindo que os produtos mais procurados nunca fiquem em falta (ruptura), além de orientar campanhas promocionais de produtos complementares.',
          indicadores: [
            'Ranking dos produtos mais vendidos por quantidade física',
            'Receita total gerada por cada item no período',
            'Filtro por categoria para análises de nicho'
          ],
        ),
        _HelpItem(
          title: 'Vendas por Categoria',
          categoryName: 'Operacional',
          finalidade: 'Demonstrar a participação percentual de cada categoria no faturamento.',
          utilidade: 'Permite aos gestores identificar quais departamentos do mercado (ex: Hortifrúti, Padaria, Açougue) são os pilares do faturamento e planejar gôndolas ou ofertas.',
          indicadores: [
            'Participação percentual de cada categoria (Gráfico de Pizza/Donut)',
            'Valor total faturado por categoria',
            'Quantidade de itens vendidos em cada grupo'
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Estoque',
      icon: Icons.inventory_2_rounded,
      items: [
        _HelpItem(
          title: 'Visão de Estoque',
          categoryName: 'Estoque',
          finalidade: 'Diagnóstico rápido do patrimônio físico estocado na empresa.',
          utilidade: 'Permite avaliar a saúde financeira imobilizada no estoque, identificar produtos parados e estimar o valor potencial de venda de todo o acervo.',
          indicadores: [
            'Custo total do estoque ativo (investimento em mercadoria)',
            'Valor potencial de venda (faturamento estimado)',
            'Margem média geral do estoque',
            'Quantidade total de itens cadastrados e ativos'
          ],
        ),
        _HelpItem(
          title: 'Curva ABC',
          categoryName: 'Estoque',
          finalidade: 'Classificar os produtos em grupos A, B e C com base no impacto financeiro.',
          utilidade: 'Permite focar esforços de controle onde o retorno é maior. Classe A representa ~80% do faturamento, Classe B ~15%, e Classe C ~5%.',
          indicadores: [
            'Classificação individual de cada produto (A, B ou C)',
            'Porcentagem acumulada de contribuição de faturamento',
            'Sugestão de controle de estoque baseada na curva de Pareto'
          ],
        ),
        _HelpItem(
          title: 'Giro de Estoque',
          categoryName: 'Estoque',
          finalidade: 'Medir a frequência com que o estoque é totalmente renovado.',
          utilidade: 'Indica a eficiência de giro das mercadorias. Um giro baixo alerta para capital preso; um giro alto reflete excelente liquidez.',
          indicadores: [
            'Taxa de giro por categoria/produto',
            'Tempo médio de permanência do item na prateleira antes da venda',
            'Alerta de \"Estoque Ocioso\" para itens com giro próximo de zero'
          ],
        ),
        _HelpItem(
          title: 'Ruptura de Estoque',
          categoryName: 'Estoque',
          finalidade: 'Mapear itens que estão ativos no catálogo, mas sem saldo físico.',
          utilidade: 'Alerta crítico para compras imediatas. Evita a perda de vendas devido à ausência de produtos básicos que o cliente espera encontrar.',
          indicadores: [
            'Lista de produtos ativos com saldo zero ou negativo',
            'Último preço de compra registrado do fornecedor',
            'Média histórica de vendas do item para estimar o prejuízo de não tê-lo'
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Financeiro',
      icon: Icons.account_balance_rounded,
      items: [
        _HelpItem(
          title: 'Resumo Financeiro',
          categoryName: 'Financeiro',
          finalidade: 'Visão rápida da saúde de caixa em um único dashboard de controle.',
          utilidade: 'Utilizado diariamente pelo gerente financeiro para conferir saldo em contas bancárias, conciliações de cartões e valores iminentes.',
          indicadores: [
            'Saldo disponível total (Caixa + Bancos)',
            'Contas a pagar para os próximos 7 dias',
            'Contas a receber para os próximos 7 dias',
            'Saldo líquido projetado de curto prazo'
          ],
        ),
        _HelpItem(
          title: 'Contas Pagar Det.',
          categoryName: 'Financeiro',
          finalidade: 'Relação minuciosa de todas as obrigações financeiras com fornecedores.',
          utilidade: 'Evita multas, juros e cortes de fornecimento ao organizar pagamentos por vencimento e programar saídas de caixa saudáveis.',
          indicadores: [
            'Listagem de contas com status (Pendente, Pago, Atrasado)',
            'Vencimento, Fornecedor, Valor original e Valor com juros',
            'Somatório de contas pendentes agrupado por mês/semana'
          ],
        ),
        _HelpItem(
          title: 'Inadimplência',
          categoryName: 'Financeiro',
          finalidade: 'Identificar duplicatas e crediários de clientes vencidos e não pagos.',
          utilidade: 'Essencial para a equipe de cobrança e análise de crédito. Ajuda a restringir a venda a prazo para clientes com alto índice de atrasos.',
          indicadores: [
            'Ranking de clientes inadimplentes',
            'Tempo médio de atraso (Aging List)',
            'Valor total em aberto e número de parcelas vencidas'
          ],
        ),
        _HelpItem(
          title: 'Projeção de Caixa',
          categoryName: 'Financeiro',
          finalidade: 'Prever a saúde financeira da empresa nas próximas semanas ou meses.',
          utilidade: 'Combina contas a pagar e contas a receber futuras para prever se haverá dinheiro suficiente em caixa nas datas críticas de folha de pagamento.',
          indicadores: [
            'Gráfico de linha com entradas vs. saídas programadas',
            'Saldo de caixa projetado no final de cada período',
            'Indicador visual de alerta de \"Caixa Negativo\" futuro'
          ],
        ),
        _HelpItem(
          title: 'Meios de Pagamento',
          categoryName: 'Financeiro',
          finalidade: 'Segmentar e demonstrar como o faturamento é recebido (PIX, Cartões, etc.).',
          utilidade: 'Ajuda a entender a preferência do consumidor, a estimar custos de taxas de operadoras e planejar o fluxo de recebimentos.',
          indicadores: [
            'Faturamento consolidado no período por meio de pagamento',
            'Volume de transações por modalidade',
            'Participação percentual de cada forma de pagamento (Gráfico de Pizza)'
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Estratégico',
      icon: Icons.assessment_rounded,
      items: [
        _HelpItem(
          title: 'DRE Gerencial',
          categoryName: 'Estratégico',
          finalidade: 'Demonstrar se a empresa está gerando Lucro ou Prejuízo contábil real.',
          utilidade: 'A ferramenta definitiva de tomada de decisão do dono do negócio. Consolida a receita bruta, descontando custos de mercadoria vendida, despesas operacionais e fixas.',
          indicadores: [
            'Receita Bruta de Vendas',
            'Deduções e Custos de Mercadorias (CMV)',
            'Margem de Contribuição',
            'Despesas Fixas e Variáveis',
            'EBITDA e Lucro Líquido Operacional'
          ],
        ),
        _HelpItem(
          title: 'Comissões',
          categoryName: 'Estratégico',
          finalidade: 'Calcular os valores devidos aos colaboradores por desempenho de venda.',
          utilidade: 'Simplifica a rotina de recursos humanos, garantindo que o cálculo de prêmios e comissões dos operadores de caixa seja exato e transparente.',
          indicadores: [
            'Lista de colaboradores e suas vendas realizadas no período',
            'Margem e meta atingida individualmente',
            'Valor da comissão apurada'
          ],
        ),
        _HelpItem(
          title: 'Produtos por Margem',
          categoryName: 'Estratégico',
          finalidade: 'Avaliar quais mercadorias geram maior margem de lucro real.',
          utilidade: 'Evita a armadilha de vender muito um produto que dá pouco lucro. Permite ajustar a precificação correta de mercadorias.',
          indicadores: [
            'Preço de Custo vs. Preço de Venda de cada produto',
            'Margem Bruta Individual (R\$)',
            'Margem Percentual (Markup / Margem de Contribuição %)',
            'Classificação de maior a menor rentabilidade'
          ],
        ),
        _HelpItem(
          title: 'Fluxo por Horário',
          categoryName: 'Estratégico',
          finalidade: 'Mapear os horários de maior fluxo de vendas ao longo do dia.',
          utilidade: 'Excelente para decisões de escalas de trabalho e abertura. Permite alocar mais operadores nos picos e programar limpeza/recebimento nos horários fracos.',
          indicadores: [
            'Gráfico de linhas demonstrando o pico de vendas por hora',
            'Faturamento acumulado por faixa horária',
            'Contagem de cupons emitidos a cada hora'
          ],
        ),
        _HelpItem(
          title: 'Compras vs. Vendas',
          categoryName: 'Estratégico',
          finalidade: 'Cruzar o dinheiro gasto com compras de estoque vs. faturamento diário.',
          utilidade: 'Ajuda a manter a balança comercial positiva. Alerta se a empresa está comprando dos fornecedores mais do que é capaz de vender, evitando sufocar o caixa.',
          indicadores: [
            'Comparativo de saídas de compras vs. faturamento de vendas',
            'Saldo líquido comercial diário',
            'KPIs consolidados de faturamento, compras e saldo líquido'
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'CRM',
      icon: Icons.groups_rounded,
      items: [
        _HelpItem(
          title: 'Ranking Clientes',
          categoryName: 'CRM',
          finalidade: 'Identificar os clientes que mais gastam no estabelecimento (VIPs).',
          utilidade: 'Permite a criação de programas de fidelidade, convites para eventos exclusivos e descontos de retenção para os maiores compradores.',
          indicadores: [
            'Lista de clientes ordenados por volume de compras acumulado (R\$)',
            'Frequência de visitas ao mercado',
            'Ticket médio individual do cliente'
          ],
        ),
        _HelpItem(
          title: 'Clientes Inativados',
          categoryName: 'CRM',
          finalidade: 'Relação de cadastros de clientes que foram suspensos ou inativados.',
          utilidade: 'Controle administrativo e de conformidade. Ajuda a monitorar cadastros bloqueados por restrição interna, duplicidades ou fraudes.',
          indicadores: [
            'Lista de clientes inativos no sistema',
            'Motivo de bloqueio ou data de inativação',
            'Usuário administrador responsável pelo bloqueio'
          ],
        ),
        _HelpItem(
          title: 'Clientes Ausentes',
          categoryName: 'CRM',
          finalidade: 'Identificar clientes cadastrados que pararam de comprar no mercado.',
          utilidade: 'Recuperação ativa de clientes! Alerta quando um cliente antigo não aparece há mais de 30 ou 60 dias, permitindo envio de cupons de reativação.',
          indicadores: [
            'Lista de clientes com ausência prolongada',
            'Dias decorridos desde a última compra registrada',
            'Histórico de preferência de categorias do cliente para ofertas focadas'
          ],
        ),
      ],
    ),
    _HelpCategory(
      title: 'Auditoria',
      icon: Icons.security_rounded,
      items: [
        _HelpItem(
          title: 'Auditoria Geral',
          categoryName: 'Auditoria',
          finalidade: 'Registrar todos os acessos e manipulações de dados sensíveis no ERP.',
          utilidade: 'Ferramenta vital de governança corporativa e segurança. Permite rastrear quem editou preços de produtos, excluiu vendas ou alterou permissões.',
          indicadores: [
            'Data, Hora e IP do acesso',
            'Colaborador responsável pelo evento',
            'Ação realizada (ex: Alteração de Preço, Exclusão de Venda, Login)'
          ],
        ),
        _HelpItem(
          title: 'Cancelamentos',
          categoryName: 'Auditoria',
          finalidade: 'Monitorar itens ou cupons inteiros cancelados nos caixas (PDV).',
          utilidade: 'Prevenção de perdas e fraudes na frente de caixa. Evita a prática ilícita de cancelar itens da compra após receber o dinheiro do cliente.',
          indicadores: [
            'Relação de cancelamentos efetuados no PDV',
            'Operador de caixa e supervisor que autorizou o cancelamento',
            'Motivo do cancelamento (ex: Erro de digitação, Cliente desistiu)'
          ],
        ),
        _HelpItem(
          title: 'Ranking Operadores',
          categoryName: 'Auditoria',
          finalidade: 'Avaliar o desempenho individual de eficiência de cada operador.',
          utilidade: 'Útil para identificar quais operadores registram mais vendas, quais são mais ágeis no processamento e quais operam com menor taxa de erros.',
          indicadores: [
            'Volume de vendas registrado por operador de caixa (R\$)',
            'Velocidade média de processamento de itens',
            'Taxa de cancelamentos vinculada a cada operador'
          ],
        ),
      ],
    ),
  ];

  Color _getCategoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'operacional': return Colors.amber;
      case 'estoque': return Colors.orange;
      case 'financeiro': return Colors.green;
      case 'estratégico': return Colors.indigoAccent;
      case 'crm': return Colors.teal;
      case 'auditoria': return Colors.redAccent;
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
                              'Central de Ajuda dos Relatórios',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Entenda a finalidade, indicadores e utilidade de cada tela gerencial',
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
                    hintText: 'Pesquise por nome, descrição ou indicador (ex: curva abc, comissão, dre)...',
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
                                    'Nenhum relatório encontrado',
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
                                        'Indicadores Exibidos:',
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
