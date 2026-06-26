class RelatorioEstoque {
  final int totalProdutos;
  final double valorTotalCusto;
  final double valorTotalVenda;
  final int produtosBaixos;
  final double sugestaoCompraTotal;
  final int produtosVencendo;

  RelatorioEstoque({
    required this.totalProdutos,
    required this.valorTotalCusto,
    required this.valorTotalVenda,
    required this.produtosBaixos,
    required this.sugestaoCompraTotal,
    required this.produtosVencendo,
  });

  factory RelatorioEstoque.fromJson(Map<String, dynamic> json) => RelatorioEstoque(
        totalProdutos: json['total_produtos'] as int? ?? 0,
        valorTotalCusto: (json['valor_total_custo'] as num?)?.toDouble() ?? 0.0,
        valorTotalVenda: (json['valor_total_venda'] as num?)?.toDouble() ?? 0.0,
        produtosBaixos: json['produtos_baixo_estoque'] as int? ?? 0,
        sugestaoCompraTotal: (json['sugestao_compra_total'] as num?)?.toDouble() ?? 0.0,
        produtosVencendo: json['produtos_vencendo'] as int? ?? 0,
      );
}
