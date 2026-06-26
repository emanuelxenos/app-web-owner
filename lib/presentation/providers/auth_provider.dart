import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/local/local_config.dart';
import 'package:unifytechxenoswebowner/data/repositories/auth_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/user.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'auth_provider.g.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? role;
  final String? token;
  final List<StoreInfo> stores;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.role,
    this.token,
    this.stores = const [],
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? role,
    String? token,
    List<StoreInfo>? stores,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      role: role ?? this.role,
      token: token ?? this.token,
      stores: stores ?? this.stores,
      errorMessage: errorMessage,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  AuthState build() {
    // Try to restore session from local storage
    final localConfig = ref.read(localConfigProvider);
    final savedToken = localConfig.token;
    if (savedToken != null && savedToken.isNotEmpty) {
      // Set token on API service
      ref.read(apiServiceProvider).setToken(savedToken);
      // We don't have user info saved, so we stay unauthenticated
      // until login is performed or token is validated
      return const AuthState(status: AuthStatus.unauthenticated);
    }
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final authRepo = ref.read(authRepositoryProvider);
      final response = await authRepo.login(
        UsuarioLoginRequest(email: email, password: password),
      );

      // Save token
      final localConfig = ref.read(localConfigProvider);
      await localConfig.setToken(response.token);

      // Set token on API service
      ref.read(apiServiceProvider).setToken(response.token);

      state = AuthState(
        status: AuthStatus.authenticated,
        role: response.role,
        token: response.token,
        stores: response.stores,
      );
      return true;
    } catch (e) {
      final errorMsg = ApiService.extractError(e);
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: errorMsg,
      );
      return false;
    }
  }

  Future<void> logout() async {
    final localConfig = ref.read(localConfigProvider);
    await localConfig.clearToken();
    ref.read(apiServiceProvider).setToken(null);
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}
