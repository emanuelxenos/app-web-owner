import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/core/constants/api_endpoints.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';
import 'package:unifytechxenoswebowner/domain/models/pagination.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';
import 'package:dio/dio.dart';

part 'product_repository.g.dart';

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepository(ref.read(apiServiceProvider));
}

class ProductRepository {
  final ApiService _api;

  ProductRepository(this._api);

  dynamic _extractData(dynamic responseData) {
    if (responseData is Map && responseData.containsKey('data')) {
      return responseData['data'];
    }
    return responseData;
  }

  Future<PaginatedResponse<Produto>> listar({
    int page = 1,
    int limit = 50,
    int? categoriaId,
    String? search,
    bool baixoEstoque = false,
    bool vencendo = false,
  }) async {
    final response = await _api.get(
      ApiEndpoints.produtos,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (categoriaId != null) 'categoria_id': categoriaId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (baixoEstoque) 'baixo_estoque': true,
        if (vencendo) 'vencendo': true,
      },
    );
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Produto.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<List<Produto>> buscar(String query) async {
    final response = await _api.get(
      ApiEndpoints.produtosBusca,
      queryParameters: {'nome': query},
    );
    final data = _extractData(response.data);
    if (data is List) {
      return data
          .map((e) => Produto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is Map<String, dynamic>) {
      return [Produto.fromJson(data)];
    }
    return [];
  }

  Future<Produto> buscarPorId(int id) async {
    final response = await _api.get(ApiEndpoints.produtoPorId(id));
    final data = _extractData(response.data);
    return Produto.fromJson(data as Map<String, dynamic>);
  }

  Future<Produto> criar(CriarProdutoRequest request) async {
    final response = await _api.post(
      ApiEndpoints.produtos,
      data: request.toJson(),
    );
    final data = _extractData(response.data);
    return Produto.fromJson(data as Map<String, dynamic>);
  }

  Future<void> atualizar(int id, CriarProdutoRequest request) async {
    await _api.put(
      ApiEndpoints.produtoPorId(id),
      data: request.toJson(),
    );
  }

  Future<void> inativar(int id) async {
    await _api.delete(ApiEndpoints.produtoPorId(id));
  }

  Future<String> uploadFoto(List<int> bytes, String fileName) async {
    final formData = FormData.fromMap({
      'foto': MultipartFile.fromBytes(bytes, filename: fileName),
    });

    final response = await _api.post(
      ApiEndpoints.produtosUpload,
      data: formData,
    );

    final data = _extractData(response.data);
    if (data is Map && data.containsKey('url')) {
      return data['url'] as String;
    }
    
    throw Exception('Resposta do servidor inválida: URL não encontrada');
  }

  Future<Map<String, dynamic>> importarPlanilha(List<int> bytes, String fileName) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
    });

    final response = await _api.post(
      ApiEndpoints.produtosImportar,
      data: formData,
    );

    final data = _extractData(response.data);
    if (data is Map<String, dynamic>) {
      return data;
    }
    
    throw Exception('Resposta do servidor inválida');
  }

  Future<void> atualizarPrecosLote(List<Map<String, dynamic>> updates) async {
    await _api.put(
      ApiEndpoints.produtosBulkPreco,
      data: {'updates': updates},
    );
  }

  Future<ProdutoLookupResponse> lookupExternal(String ean) async {
    final response = await _api.get(ApiEndpoints.produtoLookup(ean));
    final data = _extractData(response.data);
    return ProdutoLookupResponse.fromJson(data as Map<String, dynamic>);
  }
}
