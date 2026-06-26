class ContaPagar {
  final int idContaPagar;
  final int empresaId;
  final int? fornecedorId;
  final int? compraId;
  final String descricao;
  final String? documento;
  final String? parcela;
  final double valorOriginal;
  final double valorPago;
  final DateTime dataVencimento;
  final DateTime? dataPagamento;
  final String status;
  final String categoria;
  final String? observacoes;
  final DateTime dataCadastro;
  final int? usuarioId;
  final String? fornecedorNome;

  ContaPagar({
    required this.idContaPagar,
    required this.empresaId,
    this.fornecedorId,
    this.compraId,
    required this.descricao,
    this.documento,
    this.parcela,
    required this.valorOriginal,
    this.valorPago = 0,
    required this.dataVencimento,
    this.dataPagamento,
    this.status = 'aberta',
    this.categoria = 'fornecedor',
    this.observacoes,
    required this.dataCadastro,
    this.usuarioId,
    this.fornecedorNome,
  });

  bool get isVencida =>
      status == 'aberta' && dataVencimento.isBefore(DateTime.now());

  factory ContaPagar.fromJson(Map<String, dynamic> json) => ContaPagar(
        idContaPagar: json['id_conta_pagar'] as int,
        empresaId: json['empresa_id'] as int,
        fornecedorId: json['fornecedor_id'] as int?,
        compraId: json['compra_id'] as int?,
        descricao: json['descricao'] as String,
        documento: json['documento'] as String?,
        parcela: json['parcela'] as String?,
        valorOriginal: (json['valor_original'] as num).toDouble(),
        valorPago: (json['valor_pago'] as num?)?.toDouble() ?? 0,
        dataVencimento: DateTime.parse(json['data_vencimento'] as String),
        dataPagamento: json['data_pagamento'] != null
            ? DateTime.parse(json['data_pagamento'] as String)
            : null,
        status: json['status'] as String? ?? 'aberta',
        categoria: json['categoria'] as String? ?? 'fornecedor',
        observacoes: json['observacoes'] as String?,
        dataCadastro: DateTime.parse(json['data_cadastro'] as String),
        usuarioId: json['usuario_id'] as int?,
        fornecedorNome: json['fornecedor_nome'] as String?,
      );
}

class CriarContaPagarRequest {
  final String descricao;
  final double valorOriginal;
  final String dataVencimento;
  final int? fornecedorId;
  final String categoria;

  CriarContaPagarRequest({
    required this.descricao,
    required this.valorOriginal,
    required this.dataVencimento,
    this.fornecedorId,
    this.categoria = 'fornecedor',
  });

  Map<String, dynamic> toJson() => {
        'descricao': descricao,
        'valor_original': valorOriginal,
        'data_vencimento': dataVencimento,
        'fornecedor_id': fornecedorId,
        'categoria': categoria,
      };
}

class PagarContaRequest {
  final double valorPago;
  final String dataPagamento;

  PagarContaRequest({required this.valorPago, required this.dataPagamento});

  Map<String, dynamic> toJson() => {
        'valor_pago': valorPago,
        'data_pagamento': dataPagamento,
      };
}
