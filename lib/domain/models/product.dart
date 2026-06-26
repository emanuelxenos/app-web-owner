import 'package:unifytechxenoswebowner/domain/models/category.dart';

class Produto {
  final int idProduto;
  final int empresaId;
  final int? categoriaId;
  final String? codigoBarras;
  final String? codigoInterno;
  final String nome;
  final String? descricao;
  final String? marca;
  final String unidadeVenda;
  final String unidadeCompra;
  final double fatorConversao;
  final double estoqueAtual;
  final double estoqueMinimo;
  final double? estoqueMaximo;
  final bool controlarEstoque;
  final double precoCusto;
  final double precoVenda;
  final double? precoPromocional;
  final DateTime? dataInicioPromocao;
  final DateTime? dataFimPromocao;
  final double? margemLucro;
  final String? ncm;
  final int origem;
  final String? cest;
  final String? cfopPadrao;
  final String? csosnPadrao;
  final String? cstPadrao;
  final double icmsAliquota;
  final double pisAliquota;
  final double cofinsAliquota;
  final DateTime dataCadastro;
  final DateTime? dataUltimaCompra;
  final DateTime? dataUltimaVenda;
  final String? fotoPrincipalUrl;
  final bool ativo;
  final bool destacado;
  final String? localizacao;
  final DateTime? dataVencimento;
  final String? categoriaNome;

  Produto({
    required this.idProduto,
    required this.empresaId,
    this.categoriaId,
    this.codigoBarras,
    this.codigoInterno,
    required this.nome,
    this.descricao,
    this.marca,
    this.unidadeVenda = 'UN',
    this.unidadeCompra = 'UN',
    this.fatorConversao = 1.0,
    this.estoqueAtual = 0,
    this.estoqueMinimo = 0,
    this.estoqueMaximo,
    this.controlarEstoque = true,
    this.precoCusto = 0,
    required this.precoVenda,
    this.precoPromocional,
    this.dataInicioPromocao,
    this.dataFimPromocao,
    this.margemLucro,
    this.ncm,
    this.origem = 0,
    this.cest,
    this.cfopPadrao,
    this.csosnPadrao,
    this.cstPadrao,
    this.icmsAliquota = 0,
    this.pisAliquota = 0,
    this.cofinsAliquota = 0,
    required this.dataCadastro,
    this.dataUltimaCompra,
    this.dataUltimaVenda,
    this.fotoPrincipalUrl,
    this.ativo = true,
    this.destacado = false,
    this.localizacao,
    this.dataVencimento,
    this.categoriaNome,
  });

  bool get estoqueBaixo =>
      controlarEstoque && estoqueAtual <= estoqueMinimo;

  bool get emPromocao {
    if (precoPromocional == null) return false;
    final now = DateTime.now();
    if (dataInicioPromocao != null && now.isBefore(dataInicioPromocao!)) {
      return false;
    }
    if (dataFimPromocao != null && now.isAfter(dataFimPromocao!)) return false;
    return true;
  }

  double get precoEfetivo => emPromocao ? precoPromocional! : precoVenda;

  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
        idProduto: json['id_produto'] as int,
        empresaId: json['empresa_id'] as int,
        categoriaId: json['categoria_id'] as int?,
        codigoBarras: json['codigo_barras'] as String?,
        codigoInterno: json['codigo_interno'] as String?,
        nome: json['nome'] as String,
        descricao: json['descricao'] as String?,
        marca: json['marca'] as String?,
        unidadeVenda: json['unidade_venda'] as String? ?? 'UN',
        unidadeCompra: json['unidade_compra'] as String? ?? 'UN',
        fatorConversao:
            (json['fator_conversao'] as num?)?.toDouble() ?? 1.0,
        estoqueAtual: (json['estoque_atual'] as num?)?.toDouble() ?? 0,
        estoqueMinimo: (json['estoque_minimo'] as num?)?.toDouble() ?? 0,
        estoqueMaximo: (json['estoque_maximo'] as num?)?.toDouble(),
        controlarEstoque: json['controlar_estoque'] as bool? ?? true,
        precoCusto: (json['preco_custo'] as num?)?.toDouble() ?? 0,
        precoVenda: (json['preco_venda'] as num).toDouble(),
        precoPromocional:
            (json['preco_promocional'] as num?)?.toDouble(),
        dataInicioPromocao: json['data_inicio_promocao'] != null
            ? DateTime.parse(json['data_inicio_promocao'] as String)
            : null,
        dataFimPromocao: json['data_fim_promocao'] != null
            ? DateTime.parse(json['data_fim_promocao'] as String)
            : null,
        margemLucro: (json['margem_lucro'] as num?)?.toDouble(),
        ncm: json['ncm'] as String?,
        origem: json['origem'] as int? ?? 0,
        cest: json['cest'] as String?,
        cfopPadrao: json['cfop_padrao'] as String?,
        csosnPadrao: json['csosn_padrao'] as String?,
        cstPadrao: json['cst_padrao'] as String?,
        icmsAliquota: (json['icms_aliquota'] as num?)?.toDouble() ?? 0.0,
        pisAliquota: (json['pis_aliquota'] as num?)?.toDouble() ?? 0.0,
        cofinsAliquota: (json['cofins_aliquota'] as num?)?.toDouble() ?? 0.0,
        dataCadastro: DateTime.parse(json['data_cadastro'] as String),
        dataUltimaCompra: json['data_ultima_compra'] != null
            ? DateTime.parse(json['data_ultima_compra'] as String)
            : null,
        dataUltimaVenda: json['data_ultima_venda'] != null
            ? DateTime.parse(json['data_ultima_venda'] as String)
            : null,
        fotoPrincipalUrl: json['foto_principal_url'] as String?,
        ativo: json['ativo'] as bool? ?? true,
        destacado: json['destacado'] as bool? ?? false,
        localizacao: json['localizacao'] as String?,
        dataVencimento: json['data_vencimento'] != null
            ? DateTime.parse(json['data_vencimento'] as String)
            : null,
        categoriaNome: json['categoria_nome'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'codigo_barras': codigoBarras,
        'codigo_interno': codigoInterno,
        'nome': nome,
        'descricao': descricao,
        'categoria_id': categoriaId,
        'unidade_venda': unidadeVenda,
        'controlar_estoque': controlarEstoque,
        'estoque_minimo': estoqueMinimo,
        'preco_custo': precoCusto,
        'preco_venda': precoVenda,
        'ncm': ncm,
        'origem': origem,
        'cest': cest,
        'cfop_padrao': cfopPadrao,
        'csosn_padrao': csosnPadrao,
        'cst_padrao': cstPadrao,
        'icms_aliquota': icmsAliquota,
        'pis_aliquota': pisAliquota,
        'cofins_aliquota': cofinsAliquota,
        'marca': marca,
        'localizacao': localizacao,
        'data_vencimento': dataVencimento?.toUtc().toIso8601String(),
        'foto_principal_url': fotoPrincipalUrl,
      };
}

class CriarProdutoRequest {
  final String? codigoBarras;
  final String? codigoInterno;
  final String nome;
  final String? descricao;
  final int? categoriaId;
  final String unidadeVenda;
  final bool controlarEstoque;
  final double estoqueMinimo;
  final double precoCusto;
  final double precoVenda;
  final double? precoPromocional;
  final DateTime? dataInicioPromocao;
  final DateTime? dataFimPromocao;
  final double? margemLucro;
  final String? ncm;
  final int origem;
  final String? cest;
  final String? cfopPadrao;
  final String? csosnPadrao;
  final String? cstPadrao;
  final double icmsAliquota;
  final double pisAliquota;
  final double cofinsAliquota;
  final String? marca;
  final String? localizacao;
  final DateTime? dataVencimento;
  final String? fotoPrincipalUrl;

  CriarProdutoRequest({
    this.codigoBarras,
    this.codigoInterno,
    required this.nome,
    this.descricao,
    this.categoriaId,
    this.unidadeVenda = 'UN',
    this.controlarEstoque = true,
    this.estoqueMinimo = 0,
    this.precoCusto = 0,
    required this.precoVenda,
    this.precoPromocional,
    this.dataInicioPromocao,
    this.dataFimPromocao,
    this.margemLucro,
    this.ncm,
    this.origem = 0,
    this.cest,
    this.cfopPadrao,
    this.csosnPadrao,
    this.cstPadrao,
    this.icmsAliquota = 0,
    this.pisAliquota = 0,
    this.cofinsAliquota = 0,
    this.marca,
    this.localizacao,
    this.dataVencimento,
    this.fotoPrincipalUrl,
  });

  Map<String, dynamic> toJson() => {
        'codigo_barras': codigoBarras,
        'codigo_interno': codigoInterno,
        'nome': nome,
        'descricao': descricao,
        'categoria_id': categoriaId,
        'unidade_venda': unidadeVenda,
        'controlar_estoque': controlarEstoque,
        'estoque_minimo': estoqueMinimo,
        'preco_custo': precoCusto,
        'preco_venda': precoVenda,
        'preco_promocional': precoPromocional,
        'data_inicio_promocao': dataInicioPromocao?.toUtc().toIso8601String(),
        'data_fim_promocao': dataFimPromocao?.toUtc().toIso8601String(),
        'margem_lucro': margemLucro,
        'ncm': ncm,
        'origem': origem,
        'cest': cest,
        'cfop_padrao': cfopPadrao,
        'csosn_padrao': csosnPadrao,
        'cst_padrao': cstPadrao,
        'icms_aliquota': icmsAliquota,
        'pis_aliquota': pisAliquota,
        'cofins_aliquota': cofinsAliquota,
        'marca': marca,
        'localizacao': localizacao,
        'data_vencimento': dataVencimento?.toUtc().toIso8601String(),
        'foto_principal_url': fotoPrincipalUrl,
      };

  CriarProdutoRequest copyWith({
    String? nome,
    String? descricao,
    String? codigoBarras,
    String? codigoInterno,
    int? categoriaId,
    String? unidadeVenda,
    double? precoCusto,
    double? precoVenda,
    double? precoPromocional,
    DateTime? dataInicioPromocao,
    DateTime? dataFimPromocao,
    double? margemLucro,
    String? ncm,
    int? origem,
    String? cest,
    String? cfopPadrao,
    String? csosnPadrao,
    String? cstPadrao,
    double? icmsAliquota,
    double? pisAliquota,
    double? cofinsAliquota,
    double? estoqueMinimo,
    bool? controlarEstoque,
    String? marca,
    String? localizacao,
    DateTime? dataVencimento,
    String? fotoPrincipalUrl,
  }) {
    return CriarProdutoRequest(
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codigoInterno: codigoInterno ?? this.codigoInterno,
      categoriaId: categoriaId ?? this.categoriaId,
      unidadeVenda: unidadeVenda ?? this.unidadeVenda,
      precoCusto: precoCusto ?? this.precoCusto,
      precoVenda: precoVenda ?? this.precoVenda,
      precoPromocional: precoPromocional ?? this.precoPromocional,
      dataInicioPromocao: dataInicioPromocao ?? this.dataInicioPromocao,
      dataFimPromocao: dataFimPromocao ?? this.dataFimPromocao,
      margemLucro: margemLucro ?? this.margemLucro,
      ncm: ncm ?? this.ncm,
      origem: origem ?? this.origem,
      cest: cest ?? this.cest,
      cfopPadrao: cfopPadrao ?? this.cfopPadrao,
      csosnPadrao: csosnPadrao ?? this.csosnPadrao,
      cstPadrao: cstPadrao ?? this.cstPadrao,
      icmsAliquota: icmsAliquota ?? this.icmsAliquota,
      pisAliquota: pisAliquota ?? this.pisAliquota,
      cofinsAliquota: cofinsAliquota ?? this.cofinsAliquota,
      estoqueMinimo: estoqueMinimo ?? this.estoqueMinimo,
      controlarEstoque: controlarEstoque ?? this.controlarEstoque,
      marca: marca ?? this.marca,
      localizacao: localizacao ?? this.localizacao,
      dataVencimento: dataVencimento ?? this.dataVencimento,
      fotoPrincipalUrl: fotoPrincipalUrl ?? this.fotoPrincipalUrl,
    );
  }
}

class ProdutoLookupResponse {
  final String nome;
  final String marca;
  final String ncm;
  final String cest;
  final String fotoUrl;
  final double preco;
  final String fonte;

  ProdutoLookupResponse({
    required this.nome,
    required this.marca,
    required this.ncm,
    required this.cest,
    required this.fotoUrl,
    required this.preco,
    required this.fonte,
  });

  factory ProdutoLookupResponse.fromJson(Map<String, dynamic> json) =>
      ProdutoLookupResponse(
        nome: json['nome'] as String? ?? '',
        marca: json['marca'] as String? ?? '',
        ncm: json['ncm'] as String? ?? '',
        cest: json['cest'] as String? ?? '',
        fotoUrl: json['foto_url'] as String? ?? '',
        preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
        fonte: json['fonte'] as String? ?? '',
      );
}
