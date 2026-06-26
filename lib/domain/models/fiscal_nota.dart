class FiscalNota {
  final int idFiscal;
  final int empresaId;
  final int? vendaId;
  final String chaveAcesso;
  final int numero;
  final int serie;
  final String tipo; // 'NFE' ou 'NFCE'
  final String status; // 'autorizada', 'cancelada', 'contingencia', 'erro'
  final String? xmlEnviado;
  final String? xmlRetorno;
  final String? protocolo;
  final String? recibo;
  final DateTime dataEmissao;
  final DateTime? dataAutorizacao;
  final String? mensagemSefaz;
  final int usuarioId;
  final String clienteNome;
  final double valorTotal;

  FiscalNota({
    required this.idFiscal,
    required this.empresaId,
    this.vendaId,
    required this.chaveAcesso,
    required this.numero,
    required this.serie,
    required this.tipo,
    required this.status,
    this.xmlEnviado,
    this.xmlRetorno,
    this.protocolo,
    this.recibo,
    required this.dataEmissao,
    this.dataAutorizacao,
    this.mensagemSefaz,
    required this.usuarioId,
    required this.clienteNome,
    required this.valorTotal,
  });

  factory FiscalNota.fromJson(Map<String, dynamic> json) {
    return FiscalNota(
      idFiscal: json['id_fiscal'] as int,
      empresaId: json['empresa_id'] as int,
      vendaId: json['venda_id'] as int?,
      chaveAcesso: json['chave_acesso'] as String,
      numero: json['numero'] as int,
      serie: json['serie'] as int,
      tipo: json['tipo'] as String,
      status: json['status'] as String,
      xmlEnviado: json['xml_enviado'] as String?,
      xmlRetorno: json['xml_retorno'] as String?,
      protocolo: json['protocolo'] as String?,
      recibo: json['recibo'] as String?,
      dataEmissao: DateTime.parse(json['data_emissao'] as String),
      dataAutorizacao: json['data_autorizacao'] != null
          ? DateTime.parse(json['data_autorizacao'] as String)
          : null,
      mensagemSefaz: json['mensagem_sefaz'] as String?,
      usuarioId: json['usuario_id'] as int,
      clienteNome: json['cliente_nome'] as String? ?? '',
      valorTotal: (json['valor_total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
