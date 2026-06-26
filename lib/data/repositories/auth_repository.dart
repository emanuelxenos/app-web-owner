import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/core/constants/api_endpoints.dart';
import 'package:unifytechxenoswebowner/domain/models/user.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.read(apiServiceProvider));
}

class AuthRepository {
  final ApiService _api;

  AuthRepository(this._api);

  Future<UsuarioLoginResponse> login(UsuarioLoginRequest request) async {
    final response = await _api.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    return UsuarioLoginResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<bool> healthCheck() async {
    return _api.testConnection();
  }
}
