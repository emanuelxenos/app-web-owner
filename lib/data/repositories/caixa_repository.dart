import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/core/constants/api_endpoints.dart';
import 'package:unifytechxenoswebowner/domain/models/caixa.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'caixa_repository.g.dart';

@riverpod
CaixaRepository caixaRepository(CaixaRepositoryRef ref) {
  return CaixaRepository(ref.read(apiServiceProvider));
}

class CaixaRepository {
  final ApiService _api;
  CaixaRepository(this._api);

  Future<List<SessaoCaixa>> sessoes({String? inicio, String? fim}) async {
    final Map<String, dynamic> queryParameters = {};
    if (inicio != null) queryParameters['data_inicio'] = inicio;
    if (fim != null) queryParameters['data_fim'] = fim;

    final response = await _api.get(
      ApiEndpoints.caixaSessoes,
      queryParameters: queryParameters,
    );
    final data = response.data;
    if (data is List) {
      return data.map((e) => SessaoCaixa.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).map((e) => SessaoCaixa.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<CaixaMovimentacao>> movimentacoes({String? inicio, String? fim}) async {
    final Map<String, dynamic> queryParameters = {};
    if (inicio != null) queryParameters['data_inicio'] = inicio;
    if (fim != null) queryParameters['data_fim'] = fim;

    final response = await _api.get(
      ApiEndpoints.caixaMovimentacoes,
      queryParameters: queryParameters,
    );
    final data = response.data;
    if (data is List) {
      return data.map((e) => CaixaMovimentacao.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).map((e) => CaixaMovimentacao.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<CaixaStatusResponse> status() async {
    final response = await _api.get(ApiEndpoints.caixaStatus);
    return CaixaStatusResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<CaixaFisico>> listarCaixasFisicos({String status = 'ativos'}) async {
    final response = await _api.get(
      ApiEndpoints.caixaFisicos,
      queryParameters: {'status': status},
    );
    final data = response.data['data'];
    if (data is List) {
      return data.map((e) => CaixaFisico.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<CaixaFisico> criarCaixaFisico(Map<String, dynamic> data) async {
    final response = await _api.post(ApiEndpoints.caixaFisicos, data: data);
    return CaixaFisico.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> atualizarCaixaFisico(int id, Map<String, dynamic> data) async {
    await _api.put('${ApiEndpoints.caixaFisicos}/$id', data: data);
  }

  Future<void> excluirCaixaFisico(int id) async {
    await _api.delete('${ApiEndpoints.caixaFisicos}/$id');
  }
}
