class Venda {
  final int idVenda;
  final int empresaId;
  final int sessaoCaixaId;
  final int usuarioId;
  final int caixaFisicoId;
  final String numeroVenda;
  final int? clienteId;
  final String? clienteNome;
  final String? clienteDocumento;
  final DateTime dataVenda;
  final DateTime? dataCancelamento;
  final double valorTotalProdutos;
  final double valorTotalDescontos;
  final double valorTotalAcrescimos;
  final double valorSubtotal;
  final double valorFrete;
  final double valorTotal;
  final double valorPago;
  final double valorTroco;
  final String status;
  final String tipoVenda;
  final String? observacoes;
  final String? motivoCancelamento;
  final String? operadorNome;
  final String? caixaNome;
  final List<ItemVenda> itens;
  final List<VendaPagamento> pagamentos;

  Venda({
    required this.idVenda,
    required this.empresaId,
    required this.sessaoCaixaId,
    required this.usuarioId,
    required this.caixaFisicoId,
    required this.numeroVenda,
    this.clienteId,
    this.clienteNome,
    this.clienteDocumento,
    required this.dataVenda,
    this.dataCancelamento,
    this.valorTotalProdutos = 0,
    this.valorTotalDescontos = 0,
    this.valorTotalAcrescimos = 0,
    this.valorSubtotal = 0,
    this.valorFrete = 0,
    required this.valorTotal,
    this.valorPago = 0,
    this.valorTroco = 0,
    this.status = 'concluida',
    this.tipoVenda = 'venda',
    this.observacoes,
    this.motivoCancelamento,
    this.operadorNome,
    this.caixaNome,
    this.itens = const [],
    this.pagamentos = const [],
  });

  bool get isCancelada => status == 'cancelada';

  factory Venda.fromJson(Map<String, dynamic> json) => Venda(
        idVenda: json['id_venda'] as int,
        empresaId: json['empresa_id'] as int,
        sessaoCaixaId: json['sessao_caixa_id'] as int,
        usuarioId: json['usuario_id'] as int,
        caixaFisicoId: json['caixa_fisico_id'] as int,
        numeroVenda: json['numero_venda'] as String,
        clienteId: json['cliente_id'] as int?,
        clienteNome: json['cliente_nome'] as String?,
        clienteDocumento: json['cliente_documento'] as String?,
        dataVenda: DateTime.parse(json['data_venda'] as String),
        dataCancelamento: json['data_cancelamento'] != null
            ? DateTime.parse(json['data_cancelamento'] as String)
            : null,
        valorTotalProdutos:
            (json['valor_total_produtos'] as num?)?.toDouble() ?? 0,
        valorTotalDescontos:
            (json['valor_total_descontos'] as num?)?.toDouble() ?? 0,
        valorTotalAcrescimos:
            (json['valor_total_acrescimos'] as num?)?.toDouble() ?? 0,
        valorSubtotal: (json['valor_subtotal'] as num?)?.toDouble() ?? 0,
        valorFrete: (json['valor_frete'] as num?)?.toDouble() ?? 0,
        valorTotal: (json['valor_total'] as num).toDouble(),
        valorPago: (json['valor_pago'] as num?)?.toDouble() ?? 0,
        valorTroco: (json['valor_troco'] as num?)?.toDouble() ?? 0,
        status: json['status'] as String? ?? 'concluida',
        tipoVenda: json['tipo_venda'] as String? ?? 'venda',
        observacoes: json['observacoes'] as String?,
        motivoCancelamento: json['motivo_cancelamento'] as String?,
        operadorNome: json['operador_nome'] as String?,
        caixaNome: json['caixa_nome'] as String?,
        itens: json['itens'] != null
            ? (json['itens'] as List)
                .map((e) => ItemVenda.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        pagamentos: json['pagamentos'] != null
            ? (json['pagamentos'] as List)
                .map(
                    (e) => VendaPagamento.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
      );
}

class ItemVenda {
  final int idItemVenda;
  final int vendaId;
  final int produtoId;
  final int sequencia;
  final double quantidade;
  final String unidadeVenda;
  final double precoUnitario;
  final double? precoCustoUnitario;
  final double valorTotal;
  final double valorDesconto;
  final double valorDescontoPercentual;
  final double valorAcrescimo;
  final double valorLiquido;
  final String status;
  final DateTime dataHora;
  final String? produtoNome;

  ItemVenda({
    required this.idItemVenda,
    required this.vendaId,
    required this.produtoId,
    required this.sequencia,
    required this.quantidade,
    this.unidadeVenda = 'UN',
    required this.precoUnitario,
    this.precoCustoUnitario,
    required this.valorTotal,
    this.valorDesconto = 0,
    this.valorDescontoPercentual = 0,
    this.valorAcrescimo = 0,
    required this.valorLiquido,
    this.status = 'vendido',
    required this.dataHora,
    this.produtoNome,
  });

  factory ItemVenda.fromJson(Map<String, dynamic> json) => ItemVenda(
        idItemVenda: json['id_item_venda'] as int,
        vendaId: json['venda_id'] as int,
        produtoId: json['produto_id'] as int,
        sequencia: json['sequencia'] as int,
        quantidade: (json['quantidade'] as num).toDouble(),
        unidadeVenda: json['unidade_venda'] as String? ?? 'UN',
        precoUnitario: (json['preco_unitario'] as num).toDouble(),
        precoCustoUnitario:
            (json['preco_custo_unitario'] as num?)?.toDouble(),
        valorTotal: (json['valor_total'] as num).toDouble(),
        valorDesconto: (json['valor_desconto'] as num?)?.toDouble() ?? 0,
        valorDescontoPercentual:
            (json['valor_desconto_percentual'] as num?)?.toDouble() ?? 0,
        valorAcrescimo: (json['valor_acrescimo'] as num?)?.toDouble() ?? 0,
        valorLiquido: (json['valor_liquido'] as num).toDouble(),
        status: json['status'] as String? ?? 'vendido',
        dataHora: DateTime.parse(json['data_hora'] as String),
        produtoNome: json['produto_nome'] as String?,
      );
}

class VendaPagamento {
  final int idVendaPagamento;
  final int vendaId;
  final int formaPagamentoId;
  final double valor;
  final double trocoPara;
  final String? autorizacao;
  final String? bandeiraCartao;
  final int parcelas;
  final String status;
  final DateTime dataProcessamento;
  final String? formaPagamentoNome;

  VendaPagamento({
    required this.idVendaPagamento,
    required this.vendaId,
    required this.formaPagamentoId,
    required this.valor,
    this.trocoPara = 0,
    this.autorizacao,
    this.bandeiraCartao,
    this.parcelas = 1,
    this.status = 'aprovado',
    required this.dataProcessamento,
    this.formaPagamentoNome,
  });

  factory VendaPagamento.fromJson(Map<String, dynamic> json) =>
      VendaPagamento(
        idVendaPagamento: json['id_venda_pagamento'] as int,
        vendaId: json['venda_id'] as int,
        formaPagamentoId: json['forma_pagamento_id'] as int,
        valor: (json['valor'] as num).toDouble(),
        trocoPara: (json['troco_para'] as num?)?.toDouble() ?? 0,
        autorizacao: json['autorizacao'] as String?,
        bandeiraCartao: json['bandeira_cartao'] as String?,
        parcelas: json['parcelas'] as int? ?? 1,
        status: json['status'] as String? ?? 'aprovado',
        dataProcessamento:
            DateTime.parse(json['data_processamento'] as String),
        formaPagamentoNome: json['forma_pagamento_nome'] as String?,
      );
}

class FormaPagamento {
  final int idFormaPagamento;
  final int empresaId;
  final String nome;
  final String codigo;
  final String tipo;
  final bool ativo;
  final bool exibirNoCaixa;
  final bool requerTroco;
  final double taxaOperacao;
  final int ordemExibicao;

  FormaPagamento({
    required this.idFormaPagamento,
    required this.empresaId,
    required this.nome,
    required this.codigo,
    required this.tipo,
    this.ativo = true,
    this.exibirNoCaixa = true,
    this.requerTroco = false,
    this.taxaOperacao = 0,
    this.ordemExibicao = 0,
  });

  factory FormaPagamento.fromJson(Map<String, dynamic> json) =>
      FormaPagamento(
        idFormaPagamento: json['id_forma_pagamento'] as int,
        empresaId: json['empresa_id'] as int,
        nome: json['nome'] as String,
        codigo: json['codigo'] as String,
        tipo: json['tipo'] as String,
        ativo: json['ativo'] as bool? ?? true,
        exibirNoCaixa: json['exibir_no_caixa'] as bool? ?? true,
        requerTroco: json['requer_troco'] as bool? ?? false,
        taxaOperacao: (json['taxa_operacao'] as num?)?.toDouble() ?? 0,
        ordemExibicao: json['ordem_exibicao'] as int? ?? 0,
      );
}

class CancelarVendaRequest {
  final String motivo;
  final String senhaSupervisor;

  CancelarVendaRequest({
    required this.motivo,
    required this.senhaSupervisor,
  });

  Map<String, dynamic> toJson() => {
        'motivo': motivo,
        'senha_supervisor': senhaSupervisor,
      };
}

class AmortizacaoHistorico {
  final int idAmortizacao;
  final int vendaId;
  final String numeroVenda;
  final double valor;
  final DateTime dataPagamento;
  final String usuarioNome;

  AmortizacaoHistorico({
    required this.idAmortizacao,
    required this.vendaId,
    required this.numeroVenda,
    required this.valor,
    required this.dataPagamento,
    required this.usuarioNome,
  });

  factory AmortizacaoHistorico.fromJson(Map<String, dynamic> json) =>
      AmortizacaoHistorico(
        idAmortizacao: json['id_amortizacao'] as int,
        vendaId: json['venda_id'] as int,
        numeroVenda: json['numero_venda'] as String,
        valor: (json['valor'] as num).toDouble(),
        dataPagamento: DateTime.parse(json['data_pagamento'] as String),
        usuarioNome: json['usuario_nome'] as String,
      );
}
