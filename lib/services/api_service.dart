import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/core/constants/app_constants.dart';
import 'package:unifytechxenoswebowner/data/local/local_config.dart';

part 'api_service.g.dart';

@Riverpod(keepAlive: true)
ApiService apiService(ApiServiceRef ref) {
  final localConfig = ref.read(localConfigProvider);
  return ApiService(localConfig);
}

class ApiService {
  late Dio _dio;
  String? _token;
  final LocalConfig _localConfig;

  ApiService(this._localConfig) {
    _dio = Dio(BaseOptions(
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        if (kDebugMode) {
          print('→ ${options.method} ${options.uri}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('← ${response.statusCode} ${response.requestOptions.uri}');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          print('✗ ${error.response?.statusCode} ${error.requestOptions.uri}: ${error.message}');
        }
        handler.next(error);
      },
    ));
  }

  String get baseUrl {
    return 'http://localhost:9000';
  }

  String _buildPath(String path) {
    if (path.startsWith('/api/auth/login') || path.startsWith('/api/admin/') || path.startsWith('/health') || path.startsWith('/api/licenca/status')) {
      return '$baseUrl$path';
    }
    final cnpj = _localConfig.selectedStoreCnpj;
    if (cnpj != null && cnpj.isNotEmpty) {
      return '$baseUrl/api/proxy/$cnpj$path';
    }
    return '$baseUrl$path';
  }

  void setToken(String? token) {
    _token = token;
  }

  String? get token => _token;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get<T>(
      _buildPath(path),
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.post<T>(
      _buildPath(path),
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.put<T>(
      _buildPath(path),
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.delete<T>(
      _buildPath(path),
      queryParameters: queryParameters,
    );
  }

  Future<Response> download(
    String path,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.download(
      _buildPath(path),
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
    );
  }

  /// Test connection to the server
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get(
        '$baseUrl/health',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Extract error message from API response
  static String extractError(dynamic error) {
    if (error is DioException) {
      if (error.response?.data is Map) {
        final data = error.response!.data as Map;
        return data['error']?.toString() ??
            data['message']?.toString() ??
            'Erro desconhecido';
      } else if (error.response?.data is String && (error.response!.data as String).isNotEmpty) {
        return error.response!.data as String;
      }
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Tempo de conexão esgotado';
        case DioExceptionType.receiveTimeout:
          return 'Servidor demorou para responder';
        case DioExceptionType.connectionError:
          return 'Não foi possível conectar ao servidor';
        default:
          return error.message ?? 'Erro de conexão';
      }
    }
    return error.toString();
  }
}
