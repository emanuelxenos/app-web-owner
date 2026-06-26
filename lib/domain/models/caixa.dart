class CaixaFisico {
  final int idCaixaFisico;
  final int empresaId;
  final String codigo;
  final String nome;
  final String? descricao;
  final String? localizacao;
  final String? setor;
  final String? impressoraModelo;
  final String? impressoraPorta;
  final String? balancaModelo;
  final String? balancaPorta;
  final bool ativo;
  final DateTime dataCadastro;
  final DateTime? dataUltimoUso;

  CaixaFisico({
    required this.idCaixaFisico,
    required this.empresaId,
    required this.codigo,
    required this.nome,
    this.descricao,
    this.localizacao,
    this.setor,
    this.impressoraModelo,
    this.impressoraPorta,
    this.balancaModelo,
    this.balancaPorta,
    this.ativo = true,
    required this.dataCadastro,
    this.dataUltimoUso,
  });

  factory CaixaFisico.fromJson(Map<String, dynamic> json) => CaixaFisico(
        idCaixaFisico: json['id_caixa_fisico'] as int,
        empresaId: json['empresa_id'] as int,
        codigo: json['codigo'] as String,
        nome: json['nome'] as String,
        descricao: json['descricao'] as String?,
        localizacao: json['localizacao'] as String?,
        setor: json['setor'] as String?,
        impressoraModelo: json['impressora_modelo'] as String?,
        impressoraPorta: json['impressora_porta'] as String?,
        balancaModelo: json['balanca_modelo'] as String?,
        balancaPorta: json['balanca_porta'] as String?,
        ativo: json['ativo'] as bool? ?? true,
        dataCadastro: DateTime.parse(json['data_cadastro'] as String),
        dataUltimoUso: json['data_ultimo_uso'] != null
            ? DateTime.parse(json['data_ultimo_uso'] as String)
            : null,
      );
}

class SessaoCaixa {
  final int idSessao;
  final int empresaId;
  final int caixaFisicoId;
  final int usuarioId;
  final String? usuarioNome;
  final String codigoSessao;
  final DateTime dataAbertura;
  final DateTime? dataFechamento;
  final double saldoInicial;
  final double totalVendas;
  final double totalVendasCanceladas;
  final double totalDescontosConcedidos;
  final double totalSangrias;
  final double totalSuprimentos;
  final double totalDinheiro;
  final double totalCartaoDebito;
  final double totalCartaoCredito;
  final double totalPix;
  final double totalVale;
  final double totalOutros;
  final double saldoFinal;
  final double saldoFinalEsperado;
  final double diferenca;
  final String status;
  final String? observacoesAbertura;
  final String? observacoesFechamento;

  SessaoCaixa({
    required this.idSessao,
    required this.empresaId,
    required this.caixaFisicoId,
    required this.usuarioId,
    this.usuarioNome,
    required this.codigoSessao,
    required this.dataAbertura,
    this.dataFechamento,
    this.saldoInicial = 0,
    this.totalVendas = 0,
    this.totalVendasCanceladas = 0,
    this.totalDescontosConcedidos = 0,
    this.totalSangrias = 0,
    this.totalSuprimentos = 0,
    this.totalDinheiro = 0,
    this.totalCartaoDebito = 0,
    this.totalCartaoCredito = 0,
    this.totalPix = 0,
    this.totalVale = 0,
    this.totalOutros = 0,
    this.saldoFinal = 0,
    this.saldoFinalEsperado = 0,
    this.diferenca = 0,
    this.status = 'aberto',
    this.observacoesAbertura,
    this.observacoesFechamento,
  });

  bool get isAberto => status == 'aberto';

  factory SessaoCaixa.fromJson(Map<String, dynamic> json) => SessaoCaixa(
        idSessao: json['id_sessao'] as int,
        empresaId: json['empresa_id'] as int,
        caixaFisicoId: json['caixa_fisico_id'] as int,
        usuarioId: json['usuario_id'] as int,
        usuarioNome: json['usuario_nome'] as String?,
        codigoSessao: json['codigo_sessao'] as String,
        dataAbertura: DateTime.parse(json['data_abertura'] as String),
        dataFechamento: json['data_fechamento'] != null
            ? DateTime.parse(json['data_fechamento'] as String)
            : null,
        saldoInicial: (json['saldo_inicial'] as num?)?.toDouble() ?? 0,
        totalVendas: (json['total_vendas'] as num?)?.toDouble() ?? 0,
        totalVendasCanceladas:
            (json['total_vendas_canceladas'] as num?)?.toDouble() ?? 0,
        totalDescontosConcedidos:
            (json['total_descontos_concedidos'] as num?)?.toDouble() ?? 0,
        totalSangrias: (json['total_sangrias'] as num?)?.toDouble() ?? 0,
        totalSuprimentos:
            (json['total_suprimentos'] as num?)?.toDouble() ?? 0,
        totalDinheiro: (json['total_dinheiro'] as num?)?.toDouble() ?? 0,
        totalCartaoDebito:
            (json['total_cartao_debito'] as num?)?.toDouble() ?? 0,
        totalCartaoCredito:
            (json['total_cartao_credito'] as num?)?.toDouble() ?? 0,
        totalPix: (json['total_pix'] as num?)?.toDouble() ?? 0,
        totalVale: (json['total_vale'] as num?)?.toDouble() ?? 0,
        totalOutros: (json['total_outros'] as num?)?.toDouble() ?? 0,
        saldoFinal: (json['saldo_final'] as num?)?.toDouble() ?? 0,
        saldoFinalEsperado:
            (json['saldo_final_esperado'] as num?)?.toDouble() ?? 0,
        diferenca: (json['diferenca'] as num?)?.toDouble() ?? 0,
        status: json['status'] as String? ?? 'aberto',
        observacoesAbertura: json['observacoes_abertura'] as String?,
        observacoesFechamento: json['observacoes_fechamento'] as String?,
      );
}

class CaixaStatusResponse {
  final bool sessaoAtiva;
  final SessaoCaixa? sessao;
  final OperadorInfo? operador;

  CaixaStatusResponse({
    required this.sessaoAtiva,
    this.sessao,
    this.operador,
  });

  factory CaixaStatusResponse.fromJson(Map<String, dynamic> json) =>
      CaixaStatusResponse(
        sessaoAtiva: json['sessao_ativa'] as bool,
        sessao: json['sessao'] != null
            ? SessaoCaixa.fromJson(json['sessao'] as Map<String, dynamic>)
            : null,
        operador: json['operador'] != null
            ? OperadorInfo.fromJson(json['operador'] as Map<String, dynamic>)
            : null,
      );
}

class OperadorInfo {
  final int id;
  final String nome;

  OperadorInfo({required this.id, required this.nome});

  factory OperadorInfo.fromJson(Map<String, dynamic> json) => OperadorInfo(
        id: json['id'] as int,
        nome: json['nome'] as String,
      );
}

class CaixaMovimentacao {
  final int idCaixaMovimentacao;
  final int empresaId;
  final int sessaoCaixaId;
  final String tipo;
  final double valor;
  final String? motivo;
  final String? observacao;
  final DateTime dataMovimentacao;
  final int usuarioId;
  final String? usuarioNome;

  CaixaMovimentacao({
    required this.idCaixaMovimentacao,
    required this.empresaId,
    required this.sessaoCaixaId,
    required this.tipo,
    required this.valor,
    this.motivo,
    this.observacao,
    required this.dataMovimentacao,
    required this.usuarioId,
    this.usuarioNome,
  });

  bool get isSangria => tipo == 'sangria';
  bool get isSuprimento => tipo == 'suprimento';

  factory CaixaMovimentacao.fromJson(Map<String, dynamic> json) =>
      CaixaMovimentacao(
        idCaixaMovimentacao: json['id_caixa_movimentacao'] as int,
        empresaId: json['empresa_id'] as int,
        sessaoCaixaId: json['sessao_caixa_id'] as int,
        tipo: json['tipo'] as String,
        valor: (json['valor'] as num).toDouble(),
        motivo: json['motivo'] as String?,
        observacao: json['observacao'] as String?,
        dataMovimentacao: DateTime.parse(json['data_movimentacao'] as String),
        usuarioId: json['usuario_id'] as int,
        usuarioNome: json['usuario_nome'] as String?,
      );
}

class FluxoCaixaResponse {
  final List<FluxoCaixaItem> items;
  final double totalEntrada;
  final double totalSaida;
  final double saldo;

  FluxoCaixaResponse({
    required this.items,
    required this.totalEntrada,
    required this.totalSaida,
    required this.saldo,
  });

  factory FluxoCaixaResponse.fromJson(Map<String, dynamic> json) => FluxoCaixaResponse(
        items: (json['items'] as List? ?? [])
            .map((e) => FluxoCaixaItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalEntrada: (json['total_entrada'] as num?)?.toDouble() ?? 0.0,
        totalSaida: (json['total_saida'] as num?)?.toDouble() ?? 0.0,
        saldo: (json['saldo'] as num?)?.toDouble() ?? 0.0,
      );
}

class FluxoCaixaItem {
  final DateTime data;
  final String tipo;
  final String descricao;
  final double valor;
  final String categoria;

  FluxoCaixaItem({
    required this.data,
    required this.tipo,
    required this.descricao,
    required this.valor,
    required this.categoria,
  });

  factory FluxoCaixaItem.fromJson(Map<String, dynamic> json) => FluxoCaixaItem(
        data: json['data'] != null ? DateTime.parse(json['data'] as String) : DateTime.now(),
        tipo: json['tipo'] as String? ?? 'desconhecido',
        descricao: json['descricao'] as String? ?? 'Sem descrição',
        valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
        categoria: json['categoria'] as String? ?? 'Diversos',
      );
}
