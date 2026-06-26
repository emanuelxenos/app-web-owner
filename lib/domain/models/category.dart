class Categoria {
  final int idCategoria;
  final int empresaId;
  final String nome;
  final String? descricao;
  final String? icone;
  final String? corHex;
  final int? categoriaPaiId;
  final int nivel;
  final bool ativo;
  final int ordemExibicao;
  final DateTime dataCadastro;
  final int totalProdutos;
  final String? categoriaPaiNome;

  Categoria({
    required this.idCategoria,
    required this.empresaId,
    required this.nome,
    this.descricao,
    this.icone,
    this.corHex,
    this.categoriaPaiId,
    this.nivel = 1,
    this.ativo = true,
    this.ordemExibicao = 0,
    required this.dataCadastro,
    this.totalProdutos = 0,
    this.categoriaPaiNome,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        idCategoria: json['id_categoria'] as int,
        empresaId: json['empresa_id'] as int,
        nome: json['nome'] as String,
        descricao: json['descricao'] as String?,
        icone: json['icone'] as String?,
        corHex: json['cor_hex'] as String?,
        categoriaPaiId: json['categoria_pai_id'] as int?,
        nivel: json['nivel'] as int? ?? 1,
        ativo: json['ativo'] as bool? ?? true,
        ordemExibicao: json['ordem_exibicao'] as int? ?? 0,
        dataCadastro: DateTime.parse(json['data_cadastro'] as String),
        totalProdutos: json['total_produtos'] as int? ?? 0,
        categoriaPaiNome: json['categoria_pai_nome'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id_categoria': idCategoria,
        'empresa_id': empresaId,
        'nome': nome,
        'descricao': descricao,
        'icone': icone,
        'cor_hex': corHex,
        'categoria_pai_id': categoriaPaiId,
        'ativo': ativo,
      };
}

class CriarCategoriaRequest {
  final String nome;
  final String? descricao;
  final String? icone;
  final String? corHex;
  final int? categoriaPaiId;
  final int ordemExibicao;

  CriarCategoriaRequest({
    required this.nome,
    this.descricao,
    this.icone,
    this.corHex,
    this.categoriaPaiId,
    this.ordemExibicao = 0,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'descricao': descricao,
        'icone': icone,
        'cor_hex': corHex,
        'categoria_pai_id': categoriaPaiId,
        'ordem_exibicao': ordemExibicao,
      };
}
