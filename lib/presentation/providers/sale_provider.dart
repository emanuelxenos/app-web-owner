import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/sale_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/sale.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'sale_provider.g.dart';

@riverpod
class SalesHistory extends _$SalesHistory {
  @override
  Future<List<Venda>> build({String? inicio, String? fim}) async {
    return ref.read(saleRepositoryProvider).vendasDia(inicio: inicio, fim: fim);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(inicio: inicio, fim: fim));
  }
}

@riverpod
class SaleDetail extends _$SaleDetail {
  @override
  Future<Venda?> build(int id) async {
    return ref.read(saleRepositoryProvider).buscarPorId(id);
  }
}

@riverpod
class SaleActions extends _$SaleActions {
  @override
  bool build() => false;

  Future<(bool, String)> cancelar(int id, CancelarVendaRequest request) async {
    try {
      await ref.read(saleRepositoryProvider).cancelar(id, request);
      ref.invalidate(salesHistoryProvider);
      return (true, 'Venda cancelada com sucesso!');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }
}
