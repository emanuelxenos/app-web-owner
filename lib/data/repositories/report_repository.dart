import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:typed_data';
import 'package:unifytechxenoswebowner/core/constants/api_endpoints.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';
import 'package:unifytechxenoswebowner/domain/models/report.dart';

part 'report_repository.g.dart';

@riverpod
ReportRepository reportRepository(ReportRepositoryRef ref) {
  return ReportRepository(ref.read(apiServiceProvider));
}

class ReportRepository {
  final ApiService _api;
  ReportRepository(this._api);

  Map<String, dynamic> _extractMapData(dynamic responseData) {
    if (responseData is Map) {
      if (responseData.containsKey('data') && responseData['data'] is Map) {
        return Map<String, dynamic>.from(responseData['data']);
      }
      return Map<String, dynamic>.from(responseData);
    }
    return {};
  }

  List<Map<String, dynamic>> _extractListData(dynamic responseData) {
    if (responseData is Map && responseData.containsKey('data')) {
      final list = responseData['data'];
      if (list is List) {
        return list.map((item) => Map<String, dynamic>.from(item as Map)).toList();
      }
    }
    if (responseData is List) {
      return responseData.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> vendasDia() async {
    final response = await _api.get(ApiEndpoints.relatorioVendasDia);
    return _extractMapData(response.data);
  }

  Future<Map<String, dynamic>> vendasMes() async {
    final response = await _api.get(ApiEndpoints.relatorioVendasMes);
    return _extractMapData(response.data);
  }

  Future<Map<String, dynamic>> vendasPeriodo(String dataInicio, String dataFim) async {
    final response = await _api.get(
      ApiEndpoints.relatorioVendasPeriodo,
      queryParameters: {'data_inicio': dataInicio, 'data_fim': dataFim},
    );
    return _extractMapData(response.data);
  }

  Future<List<Map<String, dynamic>>> maisVendidos({String periodo = '30d', int? categoriaId}) async {
    final response = await _api.get(
      ApiEndpoints.relatorioMaisVendidos,
      queryParameters: {
        'periodo': periodo,
        if (categoriaId != null && categoriaId > 0) 'categoria_id': categoriaId,
      },
    );
    return _extractListData(response.data);
  }

  Future<RelatorioEstoque> estoqueResumo() async {
    final response = await _api.get(ApiEndpoints.relatorioEstoqueResumo);
    return RelatorioEstoque.fromJson(_extractMapData(response.data));
  }

  Future<Map<String, dynamic>> financeiroResumo() async {
    final response = await _api.get(ApiEndpoints.relatorioFinanceiroResumo);
    return _extractMapData(response.data);
  }

  Future<Map<String, dynamic>> dre({int? mes, int? ano}) async {
    final response = await _api.get(ApiEndpoints.relatorioDRE, queryParameters: {
      if (mes != null) 'mes': mes,
      if (ano != null) 'ano': ano,
    });
    return _extractMapData(response.data);
  }

  Future<Map<String, dynamic>> inadimplencia() async {
    final response = await _api.get(ApiEndpoints.relatorioInadimplencia);
    return _extractMapData(response.data);
  }

  Future<Map<String, dynamic>> curvaABC() async {
    final response = await _api.get(ApiEndpoints.relatorioCurvaABC);
    return _extractMapData(response.data);
  }

  Future<Map<String, dynamic>> comissoes({int? mes, int? ano}) async {
    final response = await _api.get(ApiEndpoints.relatorioComissoes, queryParameters: {
      if (mes != null) 'mes': mes,
      if (ano != null) 'ano': ano,
    });
    return _extractMapData(response.data);
  }

  Future<List<Map<String, dynamic>>> rankingClientes() async {
    final response = await _api.get(ApiEndpoints.relatorioRankingClientes);
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> clientesInativos() async {
    final response = await _api.get(ApiEndpoints.relatorioClientesInativos);
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> clientesAusentes({int dias = 30}) async {
    final response = await _api.get(
      ApiEndpoints.relatorioClientesAusentes,
      queryParameters: {'dias': dias},
    );
    return _extractListData(response.data);
  }

  Future<Map<String, dynamic>> dreDetalhado({int? mes, int? ano}) async {
    final response = await _api.get(ApiEndpoints.relatorioDREDetalhado, queryParameters: {
      if (mes != null) 'mes': mes,
      if (ano != null) 'ano': ano,
    });
    return _extractMapData(response.data);
  }

  Future<List<Map<String, dynamic>>> projecaoCaixa() async {
    final response = await _api.get(ApiEndpoints.relatorioProjecaoCaixa);
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> cancelamentos() async {
    final response = await _api.get(ApiEndpoints.relatorioCancelamentos);
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> giroEstoque() async {
    final response = await _api.get(ApiEndpoints.relatorioGiroEstoque);
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> rupturaEstoque() async {
    final response = await _api.get(ApiEndpoints.relatorioRupturaEstoque);
    return _extractListData(response.data);
  }

  Future<void> exportarRelatorio(String formato, String savePath, String tipo, {Map<String, dynamic>? params}) async {
    String endpoint = ApiEndpoints.relatorioExportExcel;
    if (formato == 'pdf') {
      endpoint = ApiEndpoints.relatorioExportPdf;
    } else if (formato == 'txt') {
      endpoint = ApiEndpoints.relatorioExportBalanca;
    }
    
    final Map<String, dynamic> queryParams = {'tipo': tipo};
    if (params != null) {
      queryParams.addAll(params);
    }
    
    await _api.download(endpoint, savePath, queryParameters: queryParams);
  }

  Future<Uint8List> exportarRelatorioBytes(String formato, String tipo, {Map<String, dynamic>? params}) async {
    String endpoint = ApiEndpoints.relatorioExportExcel;
    if (formato == 'pdf') {
      endpoint = ApiEndpoints.relatorioExportPdf;
    } else if (formato == 'txt') {
      endpoint = ApiEndpoints.relatorioExportBalanca;
    }
    
    final Map<String, dynamic> queryParams = {'tipo': tipo};
    if (params != null) {
      queryParams.addAll(params);
    }
    
    return await _api.downloadBytes(endpoint, queryParameters: queryParams);
  }

  Future<void> imprimirEtiqueta(int produtoId, String savePath) async {
    await _api.download(
      ApiEndpoints.relatorioEtiqueta, 
      savePath, 
      queryParameters: {'id': produtoId},
    );
  }

  Future<Uint8List> imprimirEtiquetaBytes(int produtoId) async {
    return await _api.downloadBytes(
      ApiEndpoints.relatorioEtiqueta, 
      queryParameters: {'id': produtoId},
    );
  }

  Future<List<Map<String, dynamic>>> sugestaoCompra() async {
    final response = await _api.get(ApiEndpoints.relatorioSugestaoCompra);
    return _extractListData(response.data);
  }

  Future<void> imprimirEtiquetasLote(List<int> ids, String savePath) async {
    await _api.download(
      ApiEndpoints.relatorioEtiquetas,
      savePath,
      queryParameters: {'ids': ids.join(',')},
    );
  }

  Future<List<Map<String, dynamic>>> getPerformanceProduto(int id) async {
    final response = await _api.get(
      ApiEndpoints.relatorioPerformanceProduto,
      queryParameters: {'id': id},
    );
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> getAuditoriaEstoque(int id) async {
    final response = await _api.get(
      ApiEndpoints.relatorioAuditoriaEstoque,
      queryParameters: {'id': id},
    );
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> rankingOperadores({int? mes, int? ano}) async {
    final response = await _api.get(ApiEndpoints.relatorioRankingOperadores, queryParameters: {
      if (mes != null) 'mes': mes,
      if (ano != null) 'ano': ano,
    });
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> auditoriaGeral({String? search}) async {
    final response = await _api.get(ApiEndpoints.relatorioAuditoriaGeral, queryParameters: {
      if (search != null) 'search': search,
    });
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> vendasPorCategoria({int? mes, int? ano}) async {
    final response = await _api.get(ApiEndpoints.relatorioVendasCategoria, queryParameters: {
      if (mes != null) 'mes': mes,
      if (ano != null) 'ano': ano,
    });
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> contasPagarDetalhado({String? status}) async {
    final response = await _api.get(ApiEndpoints.relatorioContasPagarDetalhado, queryParameters: {
      if (status != null) 'status': status,
    });
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> produtosMargem() async {
    final response = await _api.get(ApiEndpoints.relatorioProdutosMargem);
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> vendasFluxoHorario({String? dataInicio, String? dataFim}) async {
    final response = await _api.get(ApiEndpoints.relatorioVendasFluxoHorario, queryParameters: {
      if (dataInicio != null) 'data_inicio': dataInicio,
      if (dataFim != null) 'data_fim': dataFim,
    });
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> vendasMeiosPagamento({String? dataInicio, String? dataFim}) async {
    final response = await _api.get(ApiEndpoints.relatorioMeiosPagamento, queryParameters: {
      if (dataInicio != null) 'data_inicio': dataInicio,
      if (dataFim != null) 'data_fim': dataFim,
    });
    return _extractListData(response.data);
  }

  Future<List<Map<String, dynamic>>> comprasVsVendas({String? dataInicio, String? dataFim}) async {
    final response = await _api.get(ApiEndpoints.relatorioComprasVendas, queryParameters: {
      if (dataInicio != null) 'data_inicio': dataInicio,
      if (dataFim != null) 'data_fim': dataFim,
    });
    return _extractListData(response.data);
  }
}


