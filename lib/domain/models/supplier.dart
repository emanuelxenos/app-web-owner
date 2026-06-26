class Fornecedor {
  final int idFornecedor;
  final int empresaId;
  final String razaoSocial;
  final String? nomeFantasia;
  final String? cnpj;
  final String? inscricaoEstadual;
  final String? telefone;
  final String? telefone2;
  final String? email;
  final String? logradouro;
  final String? numero;
  final String? bairro;
  final String? cidade;
  final String? estado;
  final String? cep;
  final String? nomeContato;
  final String? telefoneContato;
  final int prazoEntrega;
  final int prazoPagamento;
  final double limiteCredito;
  final DateTime dataCadastro;
  final DateTime? dataUltimaCompra;
  final double totalCompras;
  final bool ativo;
  final String? observacoes;

  Fornecedor({
    required this.idFornecedor,
    required this.empresaId,
    required this.razaoSocial,
    this.nomeFantasia,
    this.cnpj,
    this.inscricaoEstadual,
    this.telefone,
    this.telefone2,
    this.email,
    this.logradouro,
    this.numero,
    this.bairro,
    this.cidade,
    this.estado,
    this.cep,
    this.nomeContato,
    this.telefoneContato,
    this.prazoEntrega = 7,
    this.prazoPagamento = 30,
    this.limiteCredito = 0,
    required this.dataCadastro,
    this.dataUltimaCompra,
    this.totalCompras = 0,
    this.ativo = true,
    this.observacoes,
  });

  factory Fornecedor.fromJson(Map<String, dynamic> json) => Fornecedor(
        idFornecedor: json['id_fornecedor'] as int,
        empresaId: json['empresa_id'] as int,
        razaoSocial: json['razao_social'] as String,
        nomeFantasia: json['nome_fantasia'] as String?,
        cnpj: json['cnpj'] as String?,
        inscricaoEstadual: json['inscricao_estadual'] as String?,
        telefone: json['telefone'] as String?,
        telefone2: json['telefone2'] as String?,
        email: json['email'] as String?,
        logradouro: json['logradouro'] as String?,
        numero: json['numero'] as String?,
        bairro: json['bairro'] as String?,
        cidade: json['cidade'] as String?,
        estado: json['estado'] as String?,
        cep: json['cep'] as String?,
        nomeContato: json['nome_contato'] as String?,
        telefoneContato: json['telefone_contato'] as String?,
        prazoEntrega: json['prazo_entrega'] as int? ?? 7,
        prazoPagamento: json['prazo_pagamento'] as int? ?? 30,
        limiteCredito: (json['limite_credito'] as num?)?.toDouble() ?? 0,
        dataCadastro: DateTime.parse(json['data_cadastro'] as String),
        dataUltimaCompra: json['data_ultima_compra'] != null
            ? DateTime.parse(json['data_ultima_compra'] as String)
            : null,
        totalCompras: (json['total_compras'] as num?)?.toDouble() ?? 0,
        ativo: json['ativo'] as bool? ?? true,
        observacoes: json['observacoes'] as String?,
      );
  Map<String, dynamic> toJson() => {
        'razao_social': razaoSocial,
        'nome_fantasia': nomeFantasia,
        'cnpj': cnpj,
        'inscricao_estadual': inscricaoEstadual,
        'telefone': telefone,
        'telefone2': telefone2,
        'email': email,
        'logradouro': logradouro,
        'numero': numero,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
        'cep': cep,
        'nome_contato': nomeContato,
        'telefone_contato': telefoneContato,
        'prazo_entrega': prazoEntrega,
        'prazo_pagamento': prazoPagamento,
        'limite_credito': limiteCredito,
        'observacoes': observacoes,
      };
}

class CriarFornecedorRequest {
  final String razaoSocial;
  final String? nomeFantasia;
  final String? cnpj;
  final String? inscricaoEstadual;
  final String? telefone;
  final String? telefone2;
  final String? email;
  final String? logradouro;
  final String? numero;
  final String? bairro;
  final String? cidade;
  final String? estado;
  final String? cep;
  final String? nomeContato;
  final String? telefoneContato;
  final int? prazoEntrega;
  final int? prazoPagamento;
  final double? limiteCredito;
  final String? observacoes;

  CriarFornecedorRequest({
    required this.razaoSocial,
    this.nomeFantasia,
    this.cnpj,
    this.inscricaoEstadual,
    this.telefone,
    this.telefone2,
    this.email,
    this.logradouro,
    this.numero,
    this.bairro,
    this.cidade,
    this.estado,
    this.cep,
    this.nomeContato,
    this.telefoneContato,
    this.prazoEntrega,
    this.prazoPagamento,
    this.limiteCredito,
    this.observacoes,
  });

  Map<String, dynamic> toJson() => {
        'razao_social': razaoSocial,
        'nome_fantasia': nomeFantasia,
        'cnpj': cnpj,
        'inscricao_estadual': inscricaoEstadual,
        'telefone': telefone,
        'telefone2': telefone2,
        'email': email,
        'logradouro': logradouro,
        'numero': numero,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
        'cep': cep,
        'nome_contato': nomeContato,
        'telefone_contato': telefoneContato,
        'prazo_entrega': prazoEntrega,
        'prazo_pagamento': prazoPagamento,
        'limite_credito': limiteCredito,
        'observacoes': observacoes,
      };
}
