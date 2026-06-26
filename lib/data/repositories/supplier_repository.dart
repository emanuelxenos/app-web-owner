import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/core/constants/api_endpoints.dart';
import 'package:unifytechxenoswebowner/domain/models/supplier.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'supplier_repository.g.dart';

@riverpod
SupplierRepository supplierRepository(SupplierRepositoryRef ref) {
  return SupplierRepository(ref.read(apiServiceProvider));
}

class SupplierRepository {
  final ApiService _api;

  SupplierRepository(this._api);
  
  dynamic _extractData(dynamic responseData) {
    if (responseData is Map && responseData.containsKey('data')) {
      return responseData['data'];
    }
    return responseData;
  }

  Future<List<Fornecedor>> listar({bool incluirInativos = false}) async {
    final response = await _api.get(
      ApiEndpoints.fornecedores,
      queryParameters: {'incluir_inativos': incluirInativos},
    );
    final data = _extractData(response.data);
    if (data is List) {
      return data.map((e) => Fornecedor.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Fornecedor> criar(CriarFornecedorRequest request) async {
    final response = await _api.post(ApiEndpoints.fornecedores, data: request.toJson());
    final data = _extractData(response.data);
    return Fornecedor.fromJson(data as Map<String, dynamic>);
  }

  Future<void> atualizar(int id, CriarFornecedorRequest request) async {
    await _api.put(ApiEndpoints.fornecedorPorId(id), data: request.toJson());
  }

  Future<void> inativar(int id) async {
    await _api.delete(ApiEndpoints.fornecedorPorId(id));
  }
}
