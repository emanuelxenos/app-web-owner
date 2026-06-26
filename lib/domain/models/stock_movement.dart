class EstoqueMovimentacao {
  final int idMovimentacao;
  final int empresaId;
  final int produtoId;
  final String tipoMovimentacao;
  final double quantidade;
  final double saldoAnterior;
  final double saldoAtual;
  final String? origemTipo;
  final int? origemId;
  final DateTime dataMovimentacao;
  final int? usuarioId;
  final String? observacao;
  final String? produtoNome;
  final String? loteFabricante;

  EstoqueMovimentacao({
    required this.idMovimentacao,
    required this.empresaId,
    required this.produtoId,
    required this.tipoMovimentacao,
    required this.quantidade,
    required this.saldoAnterior,
    required this.saldoAtual,
    this.origemTipo,
    this.origemId,
    required this.dataMovimentacao,
    this.usuarioId,
    this.observacao,
    this.produtoNome,
    this.loteFabricante,
  });

  factory EstoqueMovimentacao.fromJson(Map<String, dynamic> json) =>
      EstoqueMovimentacao(
        idMovimentacao: json['id_movimentacao'] as int,
        empresaId: json['empresa_id'] as int,
        produtoId: json['produto_id'] as int,
        tipoMovimentacao: json['tipo_movimentacao'] as String,
        quantidade: (json['quantidade'] as num).toDouble(),
        saldoAnterior: (json['saldo_anterior'] as num).toDouble(),
        saldoAtual: (json['saldo_atual'] as num).toDouble(),
        origemTipo: json['origem_tipo'] as String?,
        origemId: json['origem_id'] as int?,
        dataMovimentacao:
            DateTime.parse(json['data_movimentacao'] as String),
        usuarioId: json['usuario_id'] as int?,
        observacao: json['observacao'] as String?,
        produtoNome: json['produto_nome'] as String?,
        loteFabricante: json['lote_fabricante'] as String?,
      );
}

class Inventario {
  final int idInventario;
  final int empresaId;
  final String codigo;
  final String? descricao;
  final DateTime dataInicio;
  final DateTime? dataFim;
  final DateTime? dataFechamento;
  final String status;
  final String? observacoes;
  final int? usuarioId;
  final List<InventarioItem> itens;

  Inventario({
    required this.idInventario,
    required this.empresaId,
    required this.codigo,
    this.descricao,
    required this.dataInicio,
    this.dataFim,
    this.dataFechamento,
    this.status = 'aberto',
    this.observacoes,
    this.usuarioId,
    this.itens = const [],
  });

  factory Inventario.fromJson(Map<String, dynamic> json) => Inventario(
        idInventario: json['id_inventario'] as int,
        empresaId: json['empresa_id'] as int,
        codigo: json['codigo'] as String,
        descricao: json['descricao'] as String?,
        dataInicio: DateTime.parse(json['data_inicio'] as String),
        dataFim: json['data_fim'] != null
            ? DateTime.parse(json['data_fim'] as String)
            : null,
        dataFechamento: json['data_fechamento'] != null
            ? DateTime.parse(json['data_fechamento'] as String)
            : null,
        status: json['status'] as String? ?? 'aberto',
        observacoes: json['observacoes'] as String?,
        usuarioId: json['usuario_id'] as int?,
        itens: json['itens'] != null
            ? (json['itens'] as List)
                .map((e) =>
                    InventarioItem.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
      );
}

class InventarioItem {
  final int idInventarioItem;
  final int inventarioId;
  final int produtoId;
  final double quantidadeSistema;
  final double? quantidadeFisica;
  final double? diferenca;
  final bool contado;
  final DateTime? dataContagem;
  final String? observacao;
  final String? produtoNome;

  InventarioItem({
    required this.idInventarioItem,
    required this.inventarioId,
    required this.produtoId,
    required this.quantidadeSistema,
    this.quantidadeFisica,
    this.diferenca,
    this.contado = false,
    this.dataContagem,
    this.observacao,
    this.produtoNome,
  });

  factory InventarioItem.fromJson(Map<String, dynamic> json) =>
      InventarioItem(
        idInventarioItem: json['id_inventario_item'] as int,
        inventarioId: json['inventario_id'] as int,
        produtoId: json['produto_id'] as int,
        quantidadeSistema:
            (json['quantidade_sistema'] as num).toDouble(),
        quantidadeFisica:
            (json['quantidade_fisica'] as num?)?.toDouble(),
        diferenca: (json['diferenca'] as num?)?.toDouble(),
        contado: json['contado'] as bool? ?? false,
        dataContagem: json['data_contagem'] != null
            ? DateTime.parse(json['data_contagem'] as String)
            : null,
        observacao: json['observacao'] as String?,
        produtoNome: json['produto_nome'] as String?,
      );
}

class AjusteEstoqueRequest {
  final int produtoId;
  final double quantidade;
  final String tipo;
  final String motivo;
  final String? loteFabricante;
  final DateTime? dataVencimento;
  final int? localizacaoId;

  AjusteEstoqueRequest({
    required this.produtoId,
    required this.quantidade,
    required this.tipo,
    required this.motivo,
    this.loteFabricante,
    this.dataVencimento,
    this.localizacaoId,
  });

  Map<String, dynamic> toJson() => {
        'produto_id': produtoId,
        'quantidade': quantidade,
        'tipo': tipo,
        'motivo': motivo,
        'lote_fabricante': loteFabricante,
        'data_vencimento': dataVencimento?.toIso8601String(),
        'localizacao_id': localizacaoId,
      };
}

class CriarInventarioRequest {
  final String codigo;
  final String descricao;
  final String dataInicio;
  final int? categoriaId;

  CriarInventarioRequest({
    required this.codigo,
    required this.descricao,
    required this.dataInicio,
    this.categoriaId,
  });

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'descricao': descricao,
        'data_inicio': dataInicio,
        'categoria_id': categoriaId,
      };
}

class EstoqueBaixoResponse {
  final int idProduto;
  final String nome;
  final double estoqueAtual;
  final double estoqueMinimo;

  EstoqueBaixoResponse({
    required this.idProduto,
    required this.nome,
    required this.estoqueAtual,
    required this.estoqueMinimo,
  });

  factory EstoqueBaixoResponse.fromJson(Map<String, dynamic> json) =>
      EstoqueBaixoResponse(
        idProduto: json['id_produto'] as int,
        nome: json['nome'] as String,
        estoqueAtual: (json['estoque_atual'] as num).toDouble(),
        estoqueMinimo: (json['estoque_minimo'] as num).toDouble(),
      );
}

class EstoqueLocalizacao {
  final int idLocalizacao;
  final int empresaId;
  final String codigo;
  final String nome;
  final String? descricao;
  final bool ativo;

  EstoqueLocalizacao({
    required this.idLocalizacao,
    required this.empresaId,
    required this.codigo,
    required this.nome,
    this.descricao,
    this.ativo = true,
  });

  factory EstoqueLocalizacao.fromJson(Map<String, dynamic> json) =>
      EstoqueLocalizacao(
        idLocalizacao: json['id_localizacao'] as int,
        empresaId: json['empresa_id'] as int,
        codigo: json['codigo'] as String,
        nome: json['nome'] as String,
        descricao: json['descricao'] as String?,
        ativo: json['ativo'] as bool? ?? true,
      );
}

class EstoqueLote {
  final int idLote;
  final int empresaId;
  final int produtoId;
  final int? localizacaoId;
  final String loteInterno;
  final String? loteFabricante;
  final double quantidadeInicial;
  final double quantidadeAtual;
  final DateTime? dataFabricacao;
  final DateTime? dataVencimento;
  final DateTime? dataRecebimento;
  final String status;
  final String? observacao;
  final String? localizacaoNome;

  EstoqueLote({
    required this.idLote,
    required this.empresaId,
    required this.produtoId,
    this.localizacaoId,
    required this.loteInterno,
    this.loteFabricante,
    required this.quantidadeInicial,
    required this.quantidadeAtual,
    this.dataFabricacao,
    this.dataVencimento,
    this.dataRecebimento,
    required this.status,
    this.observacao,
    this.localizacaoNome,
  });

  factory EstoqueLote.fromJson(Map<String, dynamic> json) => EstoqueLote(
        idLote: json['id_lote'] as int,
        empresaId: json['empresa_id'] as int,
        produtoId: json['produto_id'] as int,
        localizacaoId: json['localizacao_id'] as int?,
        loteInterno: json['lote_interno'] as String,
        loteFabricante: json['lote_fabricante'] as String?,
        quantidadeInicial: (json['quantidade_inicial'] as num).toDouble(),
        quantidadeAtual: (json['quantidade_atual'] as num).toDouble(),
        dataFabricacao: json['data_fabricacao'] != null
            ? DateTime.parse(json['data_fabricacao'] as String)
            : null,
        dataVencimento: json['data_vencimento'] != null
            ? DateTime.parse(json['data_vencimento'] as String)
            : null,
        dataRecebimento: json['data_recebimento'] != null
            ? DateTime.parse(json['data_recebimento'] as String)
            : null,
        status: json['status'] as String? ?? 'ativo',
        observacao: json['observacao'] as String?,
        localizacaoNome: json['localizacao_nome'] as String?,
      );
}
