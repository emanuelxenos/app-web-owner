class Usuario {
  final int idUsuario;
  final int empresaId;
  final String nome;
  final String? cpf;
  final String? rg;
  final DateTime? dataNascimento;
  final String? telefone;
  final String? email;
  final String? endereco;
  final String login;
  final String perfil;
  final bool podeAbrirCaixa;
  final bool podeFecharCaixa;
  final bool podeDarDesconto;
  final double limiteDescontoPercentual;
  final bool podeCancelarVenda;
  final bool podeAlterarPreco;
  final bool podeAcessarRelatorios;
  final bool podeGerenciarProdutos;
  final bool podeGerenciarUsuarios;
  final String? caixaPadrao;
  final bool ativo;
  final DateTime dataCadastro;
  final DateTime? ultimoAcesso;

  Usuario({
    required this.idUsuario,
    required this.empresaId,
    required this.nome,
    this.cpf,
    this.rg,
    this.dataNascimento,
    this.telefone,
    this.email,
    this.endereco,
    required this.login,
    required this.perfil,
    this.podeAbrirCaixa = false,
    this.podeFecharCaixa = false,
    this.podeDarDesconto = false,
    this.limiteDescontoPercentual = 10.0,
    this.podeCancelarVenda = false,
    this.podeAlterarPreco = false,
    this.podeAcessarRelatorios = false,
    this.podeGerenciarProdutos = false,
    this.podeGerenciarUsuarios = false,
    this.caixaPadrao,
    this.ativo = true,
    required this.dataCadastro,
    this.ultimoAcesso,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        idUsuario: json['id_usuario'] as int,
        empresaId: json['empresa_id'] as int,
        nome: json['nome'] as String,
        cpf: json['cpf'] as String?,
        rg: json['rg'] as String?,
        dataNascimento: json['data_nascimento'] != null
            ? DateTime.parse(json['data_nascimento'] as String)
            : null,
        telefone: json['telefone'] as String?,
        email: json['email'] as String?,
        endereco: json['endereco'] as String?,
        login: json['login'] as String,
        perfil: json['perfil'] as String,
        podeAbrirCaixa: json['pode_abrir_caixa'] as bool? ?? false,
        podeFecharCaixa: json['pode_fechar_caixa'] as bool? ?? false,
        podeDarDesconto: json['pode_dar_desconto'] as bool? ?? false,
        limiteDescontoPercentual:
            (json['limite_desconto_percentual'] as num?)?.toDouble() ?? 10.0,
        podeCancelarVenda: json['pode_cancelar_venda'] as bool? ?? false,
        podeAlterarPreco: json['pode_alterar_preco'] as bool? ?? false,
        podeAcessarRelatorios:
            json['pode_acessar_relatorios'] as bool? ?? false,
        podeGerenciarProdutos:
            json['pode_gerenciar_produtos'] as bool? ?? false,
        podeGerenciarUsuarios:
            json['pode_gerenciar_usuarios'] as bool? ?? false,
        caixaPadrao: json['caixa_padrao'] as String?,
        ativo: json['ativo'] as bool? ?? true,
        dataCadastro: DateTime.parse(json['data_cadastro'] as String),
        ultimoAcesso: json['ultimo_acesso'] != null
            ? DateTime.parse(json['ultimo_acesso'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id_usuario': idUsuario,
        'empresa_id': empresaId,
        'nome': nome,
        'cpf': cpf,
        'telefone': telefone,
        'email': email,
        'login': login,
        'perfil': perfil,
        'pode_abrir_caixa': podeAbrirCaixa,
        'pode_fechar_caixa': podeFecharCaixa,
        'pode_dar_desconto': podeDarDesconto,
        'limite_desconto_percentual': limiteDescontoPercentual,
        'pode_cancelar_venda': podeCancelarVenda,
        'ativo': ativo,
      };
}

class UsuarioLoginRequest {
  final String email;
  final String password;

  UsuarioLoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class StoreInfo {
  final String id;
  final String cnpj;
  final String name;

  StoreInfo({required this.id, required this.cnpj, required this.name});

  factory StoreInfo.fromJson(Map<String, dynamic> json) => StoreInfo(
        id: json['id'] as String,
        cnpj: json['cnpj'] as String,
        name: json['name'] as String,
      );
}

class UsuarioLoginResponse {
  final String token;
  final String role;
  final List<StoreInfo> stores;

  UsuarioLoginResponse({
    required this.token,
    required this.role,
    required this.stores,
  });

  factory UsuarioLoginResponse.fromJson(Map<String, dynamic> json) =>
      UsuarioLoginResponse(
        token: json['token'] as String,
        role: json['role'] as String,
        stores: (json['stores'] as List<dynamic>?)
                ?.map((e) => StoreInfo.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class UsuarioInfo {
  final int id;
  final String nome;
  final String perfil;
  final UsuarioPermissao permissoes;

  UsuarioInfo({
    required this.id,
    required this.nome,
    required this.perfil,
    required this.permissoes,
  });

  factory UsuarioInfo.fromJson(Map<String, dynamic> json) => UsuarioInfo(
        id: json['id'] as int,
        nome: json['nome'] as String,
        perfil: json['perfil'] as String,
        permissoes: UsuarioPermissao.fromJson(
            json['permissoes'] as Map<String, dynamic>),
      );
}

class UsuarioPermissao {
  final bool podeAbrirCaixa;
  final bool podeDarDesconto;
  final double limiteDesconto;

  UsuarioPermissao({
    this.podeAbrirCaixa = false,
    this.podeDarDesconto = false,
    this.limiteDesconto = 0,
  });

  factory UsuarioPermissao.fromJson(Map<String, dynamic> json) =>
      UsuarioPermissao(
        podeAbrirCaixa: json['pode_abrir_caixa'] as bool? ?? false,
        podeDarDesconto: json['pode_dar_desconto'] as bool? ?? false,
        limiteDesconto: (json['limite_desconto'] as num?)?.toDouble() ?? 0,
      );
}

class CriarUsuarioRequest {
  final String nome;
  final String login;
  final String senha;
  final String perfil;
  final String? cpf;
  final String? telefone;
  final String? email;
  final bool podeAbrirCaixa;
  final bool podeFecharCaixa;
  final bool podeDarDesconto;
  final double limiteDescontoPercentual;
  final bool podeCancelarVenda;

  CriarUsuarioRequest({
    required this.nome,
    required this.login,
    required this.senha,
    required this.perfil,
    this.cpf,
    this.telefone,
    this.email,
    this.podeAbrirCaixa = false,
    this.podeFecharCaixa = false,
    this.podeDarDesconto = false,
    this.limiteDescontoPercentual = 10.0,
    this.podeCancelarVenda = false,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'login': login,
        'senha': senha,
        'perfil': perfil,
        'cpf': cpf,
        'telefone': telefone,
        'email': email,
        'pode_abrir_caixa': podeAbrirCaixa,
        'pode_fechar_caixa': podeFecharCaixa,
        'pode_dar_desconto': podeDarDesconto,
        'limite_desconto_percentual': limiteDescontoPercentual,
        'pode_cancelar_venda': podeCancelarVenda,
      };
}
