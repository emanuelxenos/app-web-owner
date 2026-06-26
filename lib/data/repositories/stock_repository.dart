import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/core/constants/api_endpoints.dart';
import 'package:unifytechxenoswebowner/domain/models/stock_movement.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'stock_repository.g.dart';

@riverpod
StockRepository stockRepository(StockRepositoryRef ref) {
  return StockRepository(ref.read(apiServiceProvider));
}

class StockRepository {
  final ApiService _api;
  StockRepository(this._api);

  dynamic _extractData(dynamic responseData) {
    if (responseData is Map && responseData.containsKey('data')) {
      return responseData['data'];
    }
    return responseData;
  }

  Future<List<EstoqueBaixoResponse>> estoqueBaixo() async {
    final response = await _api.get(ApiEndpoints.estoqueBaixo);
    final data = _extractData(response.data);
    if (data is List) {
      return data.map((e) => EstoqueBaixoResponse.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> ajustarEstoque(AjusteEstoqueRequest request) async {
    await _api.post(ApiEndpoints.estoqueAjuste, data: request.toJson());
  }

  Future<void> criarInventario(CriarInventarioRequest request) async {
    await _api.post(ApiEndpoints.estoqueInventario, data: request.toJson());
  }

  Future<List<EstoqueMovimentacao>> listarMovimentacoes({int? produtoId, DateTime? inicio, DateTime? fim, String? tipo}) async {
    final Map<String, dynamic> params = {};
    if (produtoId != null) params['produto_id'] = produtoId;
    if (inicio != null) params['data_inicio'] = inicio.toIso8601String().split('T')[0];
    if (fim != null) params['data_fim'] = fim.toIso8601String().split('T')[0];
    if (tipo != null && tipo.isNotEmpty) params['tipo'] = tipo;

    final response = await _api.get(ApiEndpoints.estoqueMovimentacoes, queryParameters: params);
    final data = _extractData(response.data);
    if (data is List) {
      return data.map((e) => EstoqueMovimentacao.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<Inventario>> listarInventarios({DateTime? inicio, DateTime? fim}) async {
    final Map<String, dynamic> params = {};
    if (inicio != null) params['inicio'] = inicio.toIso8601String().split('T')[0];
    if (fim != null) params['fim'] = fim.toIso8601String().split('T')[0];

    final response = await _api.get(ApiEndpoints.estoqueInventarios, queryParameters: params);
    final data = _extractData(response.data);
    if (data is List) {
      return data.map((e) => Inventario.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Inventario> buscarInventarioPorId(int id) async {
    final response = await _api.get('${ApiEndpoints.estoqueInventario}/$id');
    return Inventario.fromJson(_extractData(response.data) as Map<String, dynamic>);
  }

  Future<bool> atualizarItemInventario(int inventarioId, int produtoId, double quantidade) async {
    try {
      await _api.put(
        '${ApiEndpoints.estoqueInventario}/$inventarioId/item/$produtoId',
        data: {'quantidade': quantidade},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> finalizarInventario(int id, String observacoes) async {
    try {
      await _api.put('${ApiEndpoints.estoqueInventario}/$id',
          data: {'observacoes': observacoes});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<EstoqueLote>> listarLotes(int produtoId) async {
    final response = await _api.get(ApiEndpoints.estoqueLotePorProduto(produtoId));
    final data = _extractData(response.data);
    if (data is List) {
      return data.map((e) => EstoqueLote.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<EstoqueLocalizacao>> listarLocalizacoes() async {
    final response = await _api.get(ApiEndpoints.estoqueLocalizacoes);
    final data = _extractData(response.data);
    if (data is List) {
      return data.map((e) => EstoqueLocalizacao.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> registrarPerda(AjusteEstoqueRequest request) async {
    await _api.post(ApiEndpoints.estoquePerda, data: request.toJson());
  }
}

