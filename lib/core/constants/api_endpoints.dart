class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/api/auth/login';
  static const String discover = '/api/discover';
  static const String health = '/health';

  // Caixa
  static const String caixaStatus = '/api/caixa/status';
  static const String caixaAbrir = '/api/caixa/abrir';
  static const String caixaFechar = '/api/caixa/fechar';
  static const String caixaSangria = '/api/caixa/sangria';
  static const String caixaSuprimento = '/api/caixa/suprimento';
  static const String caixaSessoes = '/api/caixa/sessoes';
  static const String caixaMovimentacoes = '/api/caixa/movimentacoes';
  static const String caixaFisicos = '/api/caixa/fisicos';

  // Vendas
  static const String vendas = '/api/vendas';
  static const String vendasDia = '/api/vendas/dia';
  static String vendaPorId(int id) => '/api/vendas/$id';
  static String vendaCancelar(int id) => '/api/vendas/$id/cancelar';
  static const String emitirNFe = '/api/fiscal/emitir-nfe';

  // Produtos
  static const String produtos = '/api/produtos';
  static const String produtosBusca = '/api/produtos/busca';
  static const String produtosUpload = '/api/produtos/upload';
  static const String produtosImportar = '/api/produtos/importar';
  static const String produtosBulkPreco = '/api/produtos/bulk-preco';
  static String produtoPorId(int id) => '/api/produtos/$id';
  static String produtoLookup(String ean) => '/api/produtos/lookup/$ean';

  // Categorias
  static const String categorias = '/api/categorias';
  static String categoriaPorId(int id) => '/api/categorias/$id';

  // Clientes
  static const String clientes = '/api/clientes';
  static String clientePorId(int id) => '/api/clientes/$id';

  // Fornecedores
  static const String fornecedores = '/api/fornecedores';
  static String fornecedorPorId(int id) => '/api/fornecedores/$id';

  // Estoque
  static const String estoqueBaixo = '/api/estoque/baixo';
  static const String estoqueAjuste = '/api/estoque/ajuste';
  static const String estoqueInventario = '/api/estoque/inventario';
  static String estoqueInventarioFinalizar(int id) => '/api/estoque/inventario/$id';
  static const String estoqueMovimentacoes = '/api/estoque/movimentacoes';
  static const String estoqueInventarios = '/api/estoque/inventarios';
  static const String estoqueLocalizacoes = '/api/estoque/localizacoes';
  static String estoqueLotePorProduto(int id) => '/api/estoque/lotes/$id';
  static const String estoquePerda = '/api/estoque/perda';


  // Compras
  static const String compras = '/api/compras';
  static String compraPorId(int id) => '/api/compras/$id';
  static String compraReceber(int id) => '/api/compras/$id/receber';

  // Financeiro
  static const String contasPagar = '/api/financeiro/contas-pagar';
  static String contaPagarPagar(int id) => '/api/financeiro/contas-pagar/$id/pagar';
  static String contaPagarDelete(int id) => '/api/financeiro/contas-pagar/$id';
  static const String contasReceber = '/api/financeiro/contas-receber';
  static String contaReceberReceber(int id) => '/api/financeiro/contas-receber/$id/receber';
  static String contaReceberDelete(int id) => '/api/financeiro/contas-receber/$id';
  static const String fluxoCaixa = '/api/financeiro/fluxo-caixa';

  // Relatórios
  static const String relatorioVendasDia = '/api/relatorios/vendas/dia';
  static const String relatorioVendasMes = '/api/relatorios/vendas/mes';
  static const String relatorioVendasPeriodo = '/api/relatorios/vendas/periodo';
  static const String relatorioMaisVendidos = '/api/relatorios/produtos/mais-vendidos';
  static const String relatorioEstoqueResumo = '/api/relatorios/estoque/resumo';
  static const String relatorioFinanceiroResumo = '/api/relatorios/financeiro/resumo';
  static const String relatorioDRE = '/api/relatorios/dre';
  static const String relatorioInadimplencia = '/api/relatorios/inadimplencia';
  static const String relatorioCurvaABC = '/api/relatorios/curva-abc';
  static const String relatorioComissoes = '/api/relatorios/comissoes';
  static const String relatorioRankingClientes = '/api/relatorios/clientes/ranking';
  static const String relatorioClientesInativos = '/api/relatorios/clientes/inativos';
  static const String relatorioClientesAusentes = '/api/relatorios/clientes/ausentes';
  static const String relatorioDREDetalhado = '/api/relatorios/dre-detalhado';
  static const String relatorioProjecaoCaixa = '/api/relatorios/financeiro/projecao';
  static const String relatorioCancelamentos = '/api/relatorios/vendas/cancelamentos';
  static const String relatorioGiroEstoque = '/api/relatorios/estoque/giro';
  static const String relatorioRupturaEstoque = '/api/relatorios/estoque/ruptura';
  static const String relatorioExportPdf = '/api/relatorios/exportar/pdf';
  static const String relatorioExportExcel = '/api/relatorios/exportar/excel';
  static const String relatorioExportBalanca = '/api/relatorios/exportar/balanca';
  static const String relatorioEtiqueta = '/api/relatorios/etiqueta';
  static const String relatorioEtiquetas = '/api/relatorios/etiquetas';
  static const String relatorioSugestaoCompra = '/api/relatorios/sugestao-compra';
  static const String relatorioPerformanceProduto = '/api/relatorios/performance-produto';
  static const String relatorioAuditoriaEstoque = '/api/relatorios/auditoria-estoque';
  static const String relatorioRankingOperadores = '/api/relatorios/vendas/ranking-operadores';
  static const String relatorioVendasCategoria = '/api/relatorios/vendas/categoria';
  static const String relatorioAuditoriaGeral = '/api/relatorios/auditoria-geral';
  static const String relatorioContasPagarDetalhado = '/api/relatorios/financeiro/contas-pagar-detalhado';
  static const String relatorioProdutosMargem = '/api/relatorios/produtos/margem';
  static const String relatorioVendasFluxoHorario = '/api/relatorios/vendas/fluxo-horario';
  static const String relatorioMeiosPagamento = '/api/relatorios/vendas/meios-pagamento';
  static const String relatorioComprasVendas = '/api/relatorios/financeiro/compras-vendas';



  // Config (Admin)
  static const String config = '/api/config';
  static const String empresa = '/api/empresa';

  // Usuários (Admin)
  static const String usuarios = '/api/usuarios';
  static String usuarioPorId(int id) => '/api/usuarios/$id';

  // Backup (Admin)
  static const String backup = '/api/backup';
  static const String backupRestaurar = '/api/backup/restaurar';

  // WebSocket
  static const String ws = '/ws';
}
