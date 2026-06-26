import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/domain/models/fiscal_nota.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

final fiscalRepositoryProvider = Provider<FiscalRepository>((ref) {
  return FiscalRepository(ref.read(apiServiceProvider));
});

class FiscalRepository {
  final ApiService _api;
  FiscalRepository(this._api);

  Future<List<FiscalNota>> listarNotas({String tipo = 'NFE'}) async {
    final response = await _api.get(
      '/api/fiscal/notas',
      queryParameters: {'tipo': tipo},
    );
    final data = response.data;
    if (data is Map && data['success'] == true && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => FiscalNota.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> importarXML(String xmlContent) async {
    final response = await _api.post(
      '/api/fiscal/importar-xml',
      data: {'xml': xmlContent},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> cancelarNFe(String chave, String justificativa) async {
    final response = await _api.post(
      '/api/fiscal/cancelar',
      data: {
        'chave': chave,
        'justificativa': justificativa,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<String> obterDANFETexto(int id) async {
    final response = await _api.get('/api/fiscal/notas/$id/danfe');
    final data = response.data;
    if (data is Map && data['success'] == true) {
      return data['danfe_texto'] as String? ?? '';
    }
    return '';
  }
}
