import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/core/constants/api_endpoints.dart';
import 'package:unifytechxenoswebowner/domain/models/customer.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'customer_repository.g.dart';

@riverpod
CustomerRepository customerRepository(CustomerRepositoryRef ref) {
  return CustomerRepository(ref.read(apiServiceProvider));
}

class CustomerRepository {
  final ApiService _api;

  CustomerRepository(this._api);

  dynamic _extractData(dynamic responseData) {
    if (responseData is Map && responseData.containsKey('data')) {
      return responseData['data'];
    }
    return responseData;
  }

  Future<List<Cliente>> listar({bool incluirInativos = false}) async {
    final response = await _api.get(
      ApiEndpoints.clientes,
      queryParameters: {'incluir_inativos': incluirInativos},
    );
    final data = _extractData(response.data);
    if (data is List) {
      return data
          .map((e) => Cliente.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<(List<Cliente>, int)> listarPaginado({
    bool incluirInativos = false,
    required int page,
    required int limit,
    String? search,
    String? sortBy,
    String? sortOrder,
    String? tipoPessoa,
    double? limiteMin,
    double? limiteMax,
    bool inadimplente = false,
  }) async {
    final response = await _api.get(
      ApiEndpoints.clientes,
      queryParameters: {
        'incluir_inativos': incluirInativos,
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'q': search,
        if (sortBy != null && sortBy.isNotEmpty) 'sort': sortBy,
        if (sortOrder != null && sortOrder.isNotEmpty) 'order': sortOrder,
        if (tipoPessoa != null && tipoPessoa.isNotEmpty) 'tipo_pessoa': tipoPessoa,
        if (limiteMin != null) 'limite_min': limiteMin,
        if (limiteMax != null) 'limite_max': limiteMax,
        if (inadimplente) 'inadimplente': 'true',
      },
    );
    final dynamic body = response.data;
    final dynamic data = body is Map ? body['data'] : null;
    final int total = body is Map && body.containsKey('total') ? (body['total'] as num).toInt() : 0;
    
    if (data is List) {
      final list = data
          .map((e) => Cliente.fromJson(e as Map<String, dynamic>))
          .toList();
      return (list, total);
    }
    return (<Cliente>[], 0);
  }

  Future<ClienteStats> obterEstatisticas() async {
    final response = await _api.get('${ApiEndpoints.clientes}/stats');
    final data = _extractData(response.data);
    return ClienteStats.fromJson(data as Map<String, dynamic>);
  }

  Future<void> inativarEmLote(List<int> ids) async {
    await _api.post('${ApiEndpoints.clientes}/bulk/inativar', data: {'ids': ids});
  }

  Future<void> ajustarLimitesEmLote(List<int> ids, String tipo, double valor) async {
    await _api.post(
      '${ApiEndpoints.clientes}/bulk/limite',
      data: {
        'ids': ids,
        'tipo': tipo,
        'valor': valor,
      },
    );
  }

  Future<Cliente> criar(CriarClienteRequest request) async {
    final response =
        await _api.post(ApiEndpoints.clientes, data: request.toJson());
    final data = _extractData(response.data);
    return Cliente.fromJson(data as Map<String, dynamic>);
  }

  Future<void> atualizar(int id, CriarClienteRequest request) async {
    await _api.put(ApiEndpoints.clientePorId(id), data: request.toJson());
  }

  Future<void> inativar(int id) async {
    await _api.delete(ApiEndpoints.clientePorId(id));
  }

  Future<void> amortizar(int id, int vendaId, double valor) async {
    await _api.post('${ApiEndpoints.clientePorId(id)}/amortizar', data: {'valor': valor, 'venda_id': vendaId});
  }

  Future<List<dynamic>> listarCompras(int id) async {
    final response = await _api.get('${ApiEndpoints.clientePorId(id)}/compras');
    final data = _extractData(response.data);
    if (data is List) {
      return data;
    }
    return [];
  }

  Future<List<dynamic>> listarAmortizacoes(int id) async {
    final response = await _api.get('${ApiEndpoints.clientePorId(id)}/amortizacoes');
    final data = _extractData(response.data);
    if (data is List) {
      return data;
    }
    return [];
  }

  Future<List<int>> exportarClientes({
    String format = 'csv',
    String? search,
    String? tipoPessoa,
    double? limiteMin,
    double? limiteMax,
    bool inadimplente = false,
    List<int>? ids,
  }) async {
    final response = await _api.get<List<int>>(
      '${ApiEndpoints.clientes}/export',
      queryParameters: {
        'format': format,
        if (search != null && search.isNotEmpty) 'search': search,
        if (tipoPessoa != null && tipoPessoa.isNotEmpty) 'tipo_pessoa': tipoPessoa,
        if (limiteMin != null) 'limite_min': limiteMin,
        if (limiteMax != null) 'limite_max': limiteMax,
        if (inadimplente) 'inadimplente': 'true',
      },
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data ?? [];
  }
}
