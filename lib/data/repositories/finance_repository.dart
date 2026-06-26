import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/core/constants/api_endpoints.dart';
import 'package:unifytechxenoswebowner/domain/models/account_payable.dart';
import 'package:unifytechxenoswebowner/domain/models/account_receivable.dart';
import 'package:unifytechxenoswebowner/domain/models/report.dart';
import 'package:unifytechxenoswebowner/domain/models/caixa.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';
import 'package:unifytechxenoswebowner/domain/models/pagination.dart';

part 'finance_repository.g.dart';

@riverpod
FinanceRepository financeRepository(FinanceRepositoryRef ref) {
  return FinanceRepository(ref.read(apiServiceProvider));
}

class FinanceRepository {
  final ApiService _api;
  FinanceRepository(this._api);

  Future<PaginatedResponse<ContaPagar>> contasPagar({int page = 1, int limit = 50, String? status, String? vencInicio, String? vencFim}) async {
    final response = await _api.get(
      ApiEndpoints.contasPagar,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (vencInicio != null) 'vencimento_inicio': vencInicio,
        if (vencFim != null) 'vencimento_fim': vencFim,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['total'] != null) {
      return PaginatedResponse.fromJson(data, (json) => ContaPagar.fromJson(json as Map<String, dynamic>));
    }
    // Fallback for unpaginated format
    List<ContaPagar> list = [];
    if (data is List) {
      list = data.map((e) => ContaPagar.fromJson(e as Map<String, dynamic>)).toList();
    } else if (data is Map && data['data'] is List) {
      list = (data['data'] as List).map((e) => ContaPagar.fromJson(e as Map<String, dynamic>)).toList();
    }
    return PaginatedResponse(success: true, data: list, total: list.length, page: 1, limit: list.length);
  }

  Future<void> criarContaPagar(CriarContaPagarRequest request) async {
    await _api.post(ApiEndpoints.contasPagar, data: request.toJson());
  }

  Future<void> pagarConta(int id, PagarContaRequest request) async {
    await _api.post(ApiEndpoints.contaPagarPagar(id), data: request.toJson());
  }

  Future<void> excluirContaPagar(int id) async {
    await _api.delete(ApiEndpoints.contaPagarDelete(id));
  }

  Future<PaginatedResponse<ContaReceber>> contasReceber({int page = 1, int limit = 50, String? status, String? vencInicio, String? vencFim}) async {
    final response = await _api.get(
      ApiEndpoints.contasReceber,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status,
        if (vencInicio != null) 'vencimento_inicio': vencInicio,
        if (vencFim != null) 'vencimento_fim': vencFim,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['total'] != null) {
      return PaginatedResponse.fromJson(data, (json) => ContaReceber.fromJson(json as Map<String, dynamic>));
    }
    // Fallback for unpaginated format
    List<ContaReceber> list = [];
    if (data is List) {
      list = data.map((e) => ContaReceber.fromJson(e as Map<String, dynamic>)).toList();
    } else if (data is Map && data['data'] is List) {
      list = (data['data'] as List).map((e) => ContaReceber.fromJson(e as Map<String, dynamic>)).toList();
    }
    return PaginatedResponse(success: true, data: list, total: list.length, page: 1, limit: list.length);
  }

  Future<void> criarContaReceber(CriarContaReceberRequest request) async {
    await _api.post(ApiEndpoints.contasReceber, data: request.toJson());
  }

  Future<void> receberConta(int id, ReceberContaRequest request) async {
    await _api.post(ApiEndpoints.contaReceberReceber(id), data: request.toJson());
  }

  Future<void> excluirContaReceber(int id) async {
    await _api.delete(ApiEndpoints.contaReceberDelete(id));
  }

  Future<PaginatedResponse<FluxoCaixaResponse>> fluxoCaixa({int page = 1, int limit = 50, String? dataInicio, String? dataFim}) async {
    final response = await _api.get(
      ApiEndpoints.fluxoCaixa,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (dataInicio != null) 'data_inicio': dataInicio,
        if (dataFim != null) 'data_fim': dataFim,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic> && data['total'] != null && data['data'] != null) {
      final fluxoResp = FluxoCaixaResponse.fromJson(data['data'] as Map<String, dynamic>);
      return PaginatedResponse<FluxoCaixaResponse>(
        success: data['success'] ?? true,
        data: [fluxoResp], // Wrapped in list since PaginatedResponse expects List<T>
        total: data['total'] ?? 0,
        page: data['page'] ?? 1,
        limit: data['limit'] ?? 50,
      );
    }
    
    // Fallback
    FluxoCaixaResponse resp;
    if (data is Map<String, dynamic> && data['data'] != null) {
      resp = FluxoCaixaResponse.fromJson(data['data'] as Map<String, dynamic>);
    } else if (data is Map<String, dynamic>) {
      resp = FluxoCaixaResponse.fromJson(data);
    } else {
      resp = FluxoCaixaResponse(items: [], totalEntrada: 0, totalSaida: 0, saldo: 0);
    }
    return PaginatedResponse(success: true, data: [resp], total: resp.items.length, page: 1, limit: resp.items.length);
  }
}
