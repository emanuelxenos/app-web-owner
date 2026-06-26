import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/core/constants/api_endpoints.dart';
import 'package:unifytechxenoswebowner/domain/models/sale.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'sale_repository.g.dart';

@riverpod
SaleRepository saleRepository(SaleRepositoryRef ref) {
  return SaleRepository(ref.read(apiServiceProvider));
}

class SaleRepository {
  final ApiService _api;
  SaleRepository(this._api);

  Future<List<Venda>> vendasDia({String? inicio, String? fim}) async {
    final Map<String, dynamic> queryParameters = {};
    if (inicio != null) queryParameters['data_inicio'] = inicio;
    if (fim != null) queryParameters['data_fim'] = fim;

    final response = await _api.get(
      ApiEndpoints.vendasDia,
      queryParameters: queryParameters,
    );
    final data = response.data;
    if (data is List) {
      return data.map((e) => Venda.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).map((e) => Venda.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Venda> buscarPorId(int id) async {
    final response = await _api.get(ApiEndpoints.vendaPorId(id));
    final data = response.data;
    if (data is Map && data.containsKey('data')) {
      return Venda.fromJson(data['data'] as Map<String, dynamic>);
    }
    return Venda.fromJson(data as Map<String, dynamic>);
  }

  Future<void> cancelar(int id, CancelarVendaRequest request) async {
    await _api.post(ApiEndpoints.vendaCancelar(id), data: request.toJson());
  }

  Future<Map<String, dynamic>> emitirNFe(Map<String, dynamic> requestData) async {
    final response = await _api.post(ApiEndpoints.emitirNFe, data: requestData);
    return response.data as Map<String, dynamic>;
  }
}
