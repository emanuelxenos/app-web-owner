import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'license_service.g.dart';

class LicenseStatus {
  final bool permitido;
  final String mensagem;
  final String validade;
  final String linkPagamento;
  final String statusFatura;
  final double valor;
  final int diasRestantes;

  LicenseStatus({
    required this.permitido,
    required this.mensagem,
    required this.validade,
    required this.linkPagamento,
    required this.statusFatura,
    required this.valor,
    required this.diasRestantes,
  });

  factory LicenseStatus.fromJson(Map<String, dynamic> json) {
    return LicenseStatus(
      permitido: json['permitido'] ?? false,
      mensagem: json['mensagem'] ?? '',
      validade: json['validade'] ?? '',
      linkPagamento: json['link_pagamento'] ?? '',
      statusFatura: json['status_fatura'] ?? '',
      valor: (json['valor'] ?? 0).toDouble(),
      diasRestantes: json['dias_restantes'] ?? 0,
    );
  }
}

@Riverpod(keepAlive: true)
class LicenseNotifier extends _$LicenseNotifier {
  @override
  FutureOr<LicenseStatus> build() async {
    return _fetchStatus(force: false);
  }

  Future<LicenseStatus> _fetchStatus({bool force = false}) async {
    try {
      final api = ref.read(apiServiceProvider);
      final String path = force ? '/api/licenca/status?force=true' : '/api/licenca/status';
      final response = await api.get(path);
      if (response.statusCode == 200) {
        return LicenseStatus.fromJson(response.data);
      }
      return LicenseStatus(
        permitido: false,
        mensagem: 'Erro desconhecido ao validar licença.',
        validade: '',
        linkPagamento: '',
        statusFatura: '',
        valor: 0,
        diasRestantes: 0,
      );
    } catch (e) {
      return LicenseStatus(
        permitido: false,
        mensagem: 'Erro de conexão com o servidor local.',
        validade: '',
        linkPagamento: '',
        statusFatura: '',
        valor: 0,
        diasRestantes: 0,
      );
    }
  }

  Future<void> revalidate() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchStatus(force: true));
  }
}
