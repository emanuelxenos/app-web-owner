import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/core/constants/api_endpoints.dart';
import 'package:unifytechxenoswebowner/domain/models/company.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'empresa_repository.g.dart';

@riverpod
EmpresaRepository empresaRepository(EmpresaRepositoryRef ref) {
  return EmpresaRepository(ref.read(apiServiceProvider));
}

class EmpresaRepository {
  final ApiService _api;
  EmpresaRepository(this._api);

  Future<Empresa> buscar() async {
    final response = await _api.get(ApiEndpoints.empresa);
    final data = response.data;
    
    if (data is Map<String, dynamic>) {
      // O backend retorna { "success": true, "data": { ... } }
      if (data.containsKey('data')) {
        return Empresa.fromJson(data['data'] as Map<String, dynamic>);
      }
      return Empresa.fromJson(data);
    }
    throw Exception('Formato de resposta inválido para Empresa');
  }

  Future<void> atualizar(Empresa empresa) async {
    await _api.put(ApiEndpoints.empresa, data: empresa.toJson());
  }

  Future<String> uploadLogo(String filePath) async {
    final formData = FormData.fromMap({
      'logo': await MultipartFile.fromFile(filePath),
    });

    final response = await _api.post('/api/empresa/logo', data: formData);
    final data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('data')) {
      final innerData = data['data'] as Map<String, dynamic>;
      if (innerData.containsKey('url')) {
        return innerData['url'] as String;
      }
    } else if (data is Map<String, dynamic> && data.containsKey('url')) {
      return data['url'] as String;
    }

    throw Exception('URL do logotipo não retornada pelo servidor');
  }

  Future<void> atualizarFiscal(Map<String, dynamic> fiscalData) async {
    await _api.put('/api/empresa/fiscal', data: fiscalData);
  }

  Future<void> uploadCertificado(String filePath) async {
    final formData = FormData.fromMap({
      'certificado': await MultipartFile.fromFile(filePath),
    });

    await _api.post('/api/empresa/certificado', data: formData);
  }
}
