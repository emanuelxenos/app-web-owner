class Empresa {
  final int idEmpresa;
  final String razaoSocial;
  final String nomeFantasia;
  final String cnpj;
  final String? inscricaoEstadual;
  final String? inscricaoMunicipal;
  final String logradouro;
  final String numero;
  final String? complemento;
  final String bairro;
  final String cidade;
  final String estado;
  final String cep;
  final String telefone;
  final String? telefone2;
  final String email;
  final String? site;
  final String regimeTributario;
  final String moeda;
  final int casasDecimais;
  final String fusoHorario;
  final String? logotipoUrl;
  final String corPrimaria;
  final String corSecundaria;
  final String? observacoes;
  final bool ativo;
  final DateTime dataCadastro;
  final DateTime? dataAtualizacao;
  final int crt;
  final String? cscToken;
  final String? cscId;
  final String ufEmissao;
  final String? certificadoSenha;
  final int ambiente;

  Empresa({
    required this.idEmpresa,
    required this.razaoSocial,
    required this.nomeFantasia,
    required this.cnpj,
    this.inscricaoEstadual,
    this.inscricaoMunicipal,
    required this.logradouro,
    required this.numero,
    this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.telefone,
    this.telefone2,
    required this.email,
    this.site,
    this.regimeTributario = 'SIMPLES',
    this.moeda = 'R\$',
    this.casasDecimais = 2,
    this.fusoHorario = 'America/Sao_Paulo',
    this.logotipoUrl,
    this.corPrimaria = '#1976D2',
    this.corSecundaria = '#43A047',
    this.observacoes,
    this.ativo = true,
    required this.dataCadastro,
    this.dataAtualizacao,
    this.crt = 1,
    this.cscToken,
    this.cscId,
    this.ufEmissao = 'PE',
    this.certificadoSenha,
    this.ambiente = 2,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
        idEmpresa: json['id_empresa'] as int,
        razaoSocial: json['razao_social'] as String,
        nomeFantasia: json['nome_fantasia'] as String,
        cnpj: json['cnpj'] as String,
        inscricaoEstadual: json['inscricao_estadual'] as String?,
        inscricaoMunicipal: json['inscricao_municipal'] as String?,
        logradouro: json['logradouro'] as String? ?? '',
        numero: json['numero'] as String? ?? '',
        complemento: json['complemento'] as String?,
        bairro: json['bairro'] as String? ?? '',
        cidade: json['cidade'] as String? ?? '',
        estado: json['estado'] as String? ?? '',
        cep: json['cep'] as String? ?? '',
        telefone: json['telefone'] as String? ?? '',
        telefone2: json['telefone2'] as String?,
        email: json['email'] as String? ?? '',
        site: json['site'] as String?,
        regimeTributario: json['regime_tributario'] as String? ?? 'SIMPLES',
        moeda: json['moeda'] as String? ?? 'R\$',
        casasDecimais: json['casas_decimais'] as int? ?? 2,
        fusoHorario: json['fuso_horario'] as String? ?? 'America/Sao_Paulo',
        logotipoUrl: json['logotipo_url'] as String?,
        corPrimaria: json['cor_primaria'] as String? ?? '#1976D2',
        corSecundaria: json['cor_secundaria'] as String? ?? '#43A047',
        observacoes: json['observacoes'] as String?,
        ativo: json['ativo'] as bool? ?? true,
        dataCadastro: DateTime.parse(json['data_cadastro'] as String),
        dataAtualizacao: json['data_atualizacao'] != null
            ? DateTime.parse(json['data_atualizacao'] as String)
            : null,
        crt: json['crt'] as int? ?? 1,
        cscToken: json['csc_token'] as String?,
        cscId: json['csc_id'] as String?,
        ufEmissao: json['uf_emissao'] as String? ?? 'PE',
        certificadoSenha: json['certificado_senha'] as String?,
        ambiente: json['ambiente'] as int? ?? 2,
      );

  Map<String, dynamic> toJson() => {
        'id_empresa': idEmpresa,
        'razao_social': razaoSocial,
        'nome_fantasia': nomeFantasia,
        'cnpj': cnpj,
        'inscricao_estadual': inscricaoEstadual,
        'inscricao_municipal': inscricaoMunicipal,
        'logradouro': logradouro,
        'numero': numero,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
        'cep': cep,
        'telefone': telefone,
        'telefone2': telefone2,
        'email': email,
        'site': site,
        'regime_tributario': regimeTributario,
        'moeda': moeda,
        'casas_decimais': casasDecimais,
        'fuso_horario': fusoHorario,
        'logotipo_url': logotipoUrl,
        'cor_primaria': corPrimaria,
        'cor_secundaria': corSecundaria,
        'observacoes': observacoes,
        'ativo': ativo,
        'crt': crt,
        'csc_token': cscToken,
        'csc_id': cscId,
        'uf_emissao': ufEmissao,
        'certificado_senha': certificadoSenha,
        'ambiente': ambiente,
      };
}

class Configuracao {
  final int idConfig;
  final String chave;
  final String valor;
  final String? descricao;

  Configuracao({
    required this.idConfig,
    required this.chave,
    required this.valor,
    this.descricao,
  });

  factory Configuracao.fromJson(Map<String, dynamic> json) => Configuracao(
        idConfig: json['id_configuracao'] as int,
        chave: json['chave'] as String,
        valor: json['valor'] as String,
        descricao: json['descricao'] as String?,
      );
}

class AtualizarConfigRequest {
  final List<ConfigItem> configs;

  AtualizarConfigRequest({required this.configs});

  Map<String, dynamic> toJson() => {
        'configs': configs.map((e) => e.toJson()).toList(),
      };
}

class ConfigItem {
  final String chave;
  final String valor;

  ConfigItem({required this.chave, required this.valor});

  Map<String, dynamic> toJson() => {
        'chave': chave,
        'valor': valor,
      };
}
