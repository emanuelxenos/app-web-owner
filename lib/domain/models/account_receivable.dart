class ContaReceber {
  final int idContaReceber;
  final int empresaId;
  final int? clienteId;
  final int? vendaId;
  final String descricao;
  final String? parcela;
  final double valorOriginal;
  final double valorRecebido;
  final DateTime dataVencimento;
  final DateTime? dataRecebimento;
  final String status;
  final String categoria;
  final String? observacoes;
  final DateTime dataCadastro;
  final int? usuarioId;
  final String? clienteNome;

  ContaReceber({
    required this.idContaReceber,
    required this.empresaId,
    this.clienteId,
    this.vendaId,
    required this.descricao,
    this.parcela,
    required this.valorOriginal,
    this.valorRecebido = 0,
    required this.dataVencimento,
    this.dataRecebimento,
    this.status = 'aberta',
    this.categoria = 'venda',
    this.observacoes,
    required this.dataCadastro,
    this.usuarioId,
    this.clienteNome,
  });

  bool get isVencida =>
      status == 'aberta' && dataVencimento.isBefore(DateTime.now());

  factory ContaReceber.fromJson(Map<String, dynamic> json) => ContaReceber(
        idContaReceber: json['id_conta_receber'] as int,
        empresaId: json['empresa_id'] as int,
        clienteId: json['cliente_id'] as int?,
        vendaId: json['venda_id'] as int?,
        descricao: json['descricao'] as String,
        parcela: json['parcela'] as String?,
        valorOriginal: (json['valor_original'] as num).toDouble(),
        valorRecebido: (json['valor_recebido'] as num?)?.toDouble() ?? 0,
        dataVencimento: DateTime.parse(json['data_vencimento'] as String),
        dataRecebimento: json['data_recebimento'] != null
            ? DateTime.parse(json['data_recebimento'] as String)
            : null,
        status: json['status'] as String? ?? 'aberta',
        categoria: json['categoria'] as String? ?? 'venda',
        observacoes: json['observacoes'] as String?,
        dataCadastro: DateTime.parse(json['data_cadastro'] as String),
        usuarioId: json['usuario_id'] as int?,
        clienteNome: json['cliente_nome'] as String?,
      );
}

class ReceberContaRequest {
  final double valorRecebido;
  final String dataRecebimento;

  ReceberContaRequest({
    required this.valorRecebido,
    required this.dataRecebimento,
  });

  Map<String, dynamic> toJson() => {
        'valor_recebido': valorRecebido,
        'data_recebimento': dataRecebimento,
      };
}

class CriarContaReceberRequest {
  final String descricao;
  final double valorOriginal;
  final String dataVencimento;
  final int? clienteId;
  final String categoria;

  CriarContaReceberRequest({
    required this.descricao,
    required this.valorOriginal,
    required this.dataVencimento,
    this.clienteId,
    this.categoria = 'geral',
  });

  Map<String, dynamic> toJson() => {
        'descricao': descricao,
        'valor_original': valorOriginal,
        'data_vencimento': dataVencimento,
        'cliente_id': clienteId,
        'categoria': categoria,
      };
}
