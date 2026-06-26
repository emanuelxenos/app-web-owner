class Cliente {
  final int idCliente;
  final String nome;
  final String tipoPessoa;
  final String? cpfCnpj;
  final String? telefone;
  final String? email;
  final double limiteCredito;
  final double saldoDevedor;
  final bool ativo;
  final DateTime? dataCadastro;
  final String? logradouro;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? estado;
  final String? cep;

  Cliente({
    required this.idCliente,
    required this.nome,
    required this.tipoPessoa,
    this.cpfCnpj,
    this.telefone,
    this.email,
    required this.limiteCredito,
    required this.saldoDevedor,
    this.ativo = true,
    this.dataCadastro,
    this.logradouro,
    this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
    this.cep,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        idCliente: json['id_cliente'] as int,
        nome: json['nome'] as String,
        tipoPessoa: json['tipo_pessoa'] as String,
        cpfCnpj: json['cpf_cnpj'] as String?,
        telefone: json['telefone'] as String?,
        email: json['email'] as String?,
        limiteCredito: (json['limite_credito'] as num).toDouble(),
        saldoDevedor: (json['saldo_devedor'] as num).toDouble(),
        ativo: json['ativo'] as bool? ?? true,
        dataCadastro: json['data_cadastro'] != null ? DateTime.tryParse(json['data_cadastro'] as String) : null,
        logradouro: json['logradouro'] as String?,
        numero: json['numero'] as String?,
        complemento: json['complemento'] as String?,
        bairro: json['bairro'] as String?,
        cidade: json['cidade'] as String?,
        estado: json['estado'] as String?,
        cep: json['cep'] as String?,
      );
}

class ClienteStats {
  final int totalClientes;
  final double saldoDevedorTotal;
  final double limiteCreditoTotal;
  final int totalInadimplentes;

  ClienteStats({
    required this.totalClientes,
    required this.saldoDevedorTotal,
    required this.limiteCreditoTotal,
    required this.totalInadimplentes,
  });

  factory ClienteStats.fromJson(Map<String, dynamic> json) => ClienteStats(
        totalClientes: json['total_clientes'] as int,
        saldoDevedorTotal: (json['saldo_devedor_total'] as num).toDouble(),
        limiteCreditoTotal: (json['limite_credito_total'] as num).toDouble(),
        totalInadimplentes: json['total_inadimplentes'] as int,
      );
}

class CriarClienteRequest {
  final String nome;
  final String tipoPessoa;
  final String? cpfCnpj;
  final String? telefone;
  final String? email;
  final double limiteCredito;

  CriarClienteRequest({
    required this.nome,
    required this.tipoPessoa,
    this.cpfCnpj,
    this.telefone,
    this.email,
    required this.limiteCredito,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'tipo_pessoa': tipoPessoa,
        'cpf_cnpj': cpfCnpj,
        'telefone': telefone,
        'email': email,
        'limite_credito': limiteCredito,
      };
}
