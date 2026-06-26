import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/customer_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/customer.dart';
import 'package:unifytechxenoswebowner/domain/models/sale.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'customer_provider.g.dart';

final customerPageProvider = StateProvider<int>((ref) => 0);
final customerItemsPerPageProvider = StateProvider<int>((ref) => 10);
final customerSortFieldProvider = StateProvider<String?>((ref) => null);
final customerSortAscendingProvider = StateProvider<bool>((ref) => true);

// Advanced filter providers
final customerFilterTipoPessoaProvider = StateProvider<String?>((ref) => null);
final customerFilterLimiteMinProvider = StateProvider<double?>((ref) => null);
final customerFilterLimiteMaxProvider = StateProvider<double?>((ref) => null);
final customerFilterInadimplenteProvider = StateProvider<bool>((ref) => false);

class PaginatedCustomersResult {
  final List<Cliente> clientes;
  final int total;

  PaginatedCustomersResult({required this.clientes, required this.total});
}

@riverpod
class CustomerStatsNotifier extends _$CustomerStatsNotifier {
  @override
  FutureOr<ClienteStats> build() async {
    return ref.read(customerRepositoryProvider).obterEstatisticas();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(customerRepositoryProvider).obterEstatisticas());
  }
}

@riverpod
class Customers extends _$Customers {
  @override
  FutureOr<PaginatedCustomersResult> build() async {
    final incluirInativos = ref.watch(customerInactivesProvider);
    final page = ref.watch(customerPageProvider);
    final limit = ref.watch(customerItemsPerPageProvider);
    final search = ref.watch(customerSearchProvider);
    final sortBy = ref.watch(customerSortFieldProvider);
    final ascending = ref.watch(customerSortAscendingProvider);
    final sortOrder = ascending ? 'asc' : 'desc';
    final tipoPessoa = ref.watch(customerFilterTipoPessoaProvider);
    final limiteMin = ref.watch(customerFilterLimiteMinProvider);
    final limiteMax = ref.watch(customerFilterLimiteMaxProvider);
    final inadimplente = ref.watch(customerFilterInadimplenteProvider);
    return _fetch(incluirInativos, page + 1, limit, search, sortBy, sortOrder,
        tipoPessoa: tipoPessoa, limiteMin: limiteMin, limiteMax: limiteMax, inadimplente: inadimplente);
  }

  Future<PaginatedCustomersResult> _fetch(
      bool incluirInativos, int page, int limit, String search, String? sortBy, String? sortOrder, {
      String? tipoPessoa, double? limiteMin, double? limiteMax, bool inadimplente = false}) async {
    final (list, total) = await ref
        .read(customerRepositoryProvider)
        .listarPaginado(
            incluirInativos: incluirInativos,
            page: page,
            limit: limit,
            search: search,
            sortBy: sortBy,
            sortOrder: sortOrder,
            tipoPessoa: tipoPessoa,
            limiteMin: limiteMin,
            limiteMax: limiteMax,
            inadimplente: inadimplente);
    return PaginatedCustomersResult(clientes: list, total: total);
  }

  Future<void> refresh() async {
    final incluirInativos = ref.read(customerInactivesProvider);
    final page = ref.read(customerPageProvider);
    final limit = ref.read(customerItemsPerPageProvider);
    final search = ref.read(customerSearchProvider);
    final sortBy = ref.read(customerSortFieldProvider);
    final ascending = ref.read(customerSortAscendingProvider);
    final sortOrder = ascending ? 'asc' : 'desc';
    final tipoPessoa = ref.read(customerFilterTipoPessoaProvider);
    final limiteMin = ref.read(customerFilterLimiteMinProvider);
    final limiteMax = ref.read(customerFilterLimiteMaxProvider);
    final inadimplente = ref.read(customerFilterInadimplenteProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(
        incluirInativos, page + 1, limit, search, sortBy, sortOrder,
        tipoPessoa: tipoPessoa, limiteMin: limiteMin, limiteMax: limiteMax, inadimplente: inadimplente));
  }

  Future<(bool, String)> criar(CriarClienteRequest request) async {
    try {
      await ref.read(customerRepositoryProvider).criar(request);
      await refresh();
      ref.read(customerStatsNotifierProvider.notifier).refresh();
      return (true, 'Cliente cadastrado com sucesso');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> atualizar(int id, CriarClienteRequest request) async {
    try {
      await ref.read(customerRepositoryProvider).atualizar(id, request);
      await refresh();
      ref.read(customerStatsNotifierProvider.notifier).refresh();
      return (true, 'Cliente atualizado com sucesso');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> inativar(int id) async {
    try {
      await ref.read(customerRepositoryProvider).inativar(id);
      await refresh();
      ref.read(customerStatsNotifierProvider.notifier).refresh();
      return (true, 'Cliente inativado com sucesso');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> inativarEmLote(List<int> ids) async {
    try {
      await ref.read(customerRepositoryProvider).inativarEmLote(ids);
      await refresh();
      ref.read(customerStatsNotifierProvider.notifier).refresh();
      return (true, 'Clientes inativados com sucesso');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> ajustarLimitesEmLote(List<int> ids, String tipo, double valor) async {
    try {
      await ref.read(customerRepositoryProvider).ajustarLimitesEmLote(ids, tipo, valor);
      await refresh();
      ref.read(customerStatsNotifierProvider.notifier).refresh();
      return (true, 'Limites ajustados com sucesso');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> amortizarDivida(int id, int vendaId, double valor) async {
    try {
      await ref.read(customerRepositoryProvider).amortizar(id, vendaId, valor);
      await refresh();
      ref.read(customerStatsNotifierProvider.notifier).refresh();
      return (true, 'Dívida amortizada com sucesso');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }
}

@riverpod
List<Cliente> filteredCustomers(FilteredCustomersRef ref) {
  final customersAsync = ref.watch(customersProvider);

  return customersAsync.maybeWhen(
    data: (res) => res.clientes,
    orElse: () => [],
  );
}

@riverpod
class CustomerSearch extends _$CustomerSearch {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
class CustomerInactives extends _$CustomerInactives {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}

@riverpod
Future<List<Venda>> customerHistory(CustomerHistoryRef ref, int clienteId) async {
  final data = await ref.read(customerRepositoryProvider).listarCompras(clienteId);
  return data.map((e) => Venda.fromJson(e as Map<String, dynamic>)).toList();
}

@riverpod
Future<List<AmortizacaoHistorico>> customerAmortizations(CustomerAmortizationsRef ref, int clienteId) async {
  final data = await ref.read(customerRepositoryProvider).listarAmortizacoes(clienteId);
  return data.map((e) => AmortizacaoHistorico.fromJson(e as Map<String, dynamic>)).toList();
}
