import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/stock_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/stock_movement.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'stock_provider.g.dart';

@riverpod
class LowStock extends _$LowStock {
  @override
  Future<List<EstoqueBaixoResponse>> build() async {
    return ref.read(stockRepositoryProvider).estoqueBaixo();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(stockRepositoryProvider).estoqueBaixo());
  }
}

@riverpod
class StockMovements extends _$StockMovements {
  @override
  Future<List<EstoqueMovimentacao>> build({int? produtoId, DateTime? inicio, DateTime? fim, String? tipo}) async {
    return ref.read(stockRepositoryProvider).listarMovimentacoes(
      produtoId: produtoId,
      inicio: inicio,
      fim: fim,
      tipo: tipo,
    );
  }
}

@riverpod
class Inventories extends _$Inventories {
  @override
  Future<List<Inventario>> build({DateTime? inicio, DateTime? fim}) async {
    return ref.read(stockRepositoryProvider).listarInventarios(
      inicio: inicio,
      fim: fim,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(stockRepositoryProvider).listarInventarios(
      inicio: inicio,
      fim: fim,
    ));
  }
}

@riverpod
Future<Inventario> inventoryDetails(InventoryDetailsRef ref, int id) async {
  return ref.watch(stockRepositoryProvider).buscarInventarioPorId(id);
}

@riverpod
class StockActions extends _$StockActions {
  @override
  bool build() => false;

  Future<(bool, String)> ajustar(AjusteEstoqueRequest request) async {
    try {
      await ref.read(stockRepositoryProvider).ajustarEstoque(request);
      ref.invalidate(lowStockProvider);
      return (true, 'Estoque ajustado com sucesso!');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> criarInventario(CriarInventarioRequest request) async {
    try {
      await ref.read(stockRepositoryProvider).criarInventario(request);
      ref.invalidate(inventoriesProvider);
      return (true, 'Inventário criado com sucesso!');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> atualizarItemInventario(int invId, int prodId, double quantity) async {
    try {
      final success = await ref.read(stockRepositoryProvider).atualizarItemInventario(invId, prodId, quantity);
      if (success) {
        ref.invalidate(inventoryDetailsProvider(invId));
        return (true, 'Item atualizado!');
      }
      return (false, 'Erro ao atualizar item');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> finalizarInventario(int id, String observacoes) async {
    try {
      final success = await ref.read(stockRepositoryProvider).finalizarInventario(id, observacoes);
      if (success) {
        ref.invalidate(inventoriesProvider);
        ref.invalidate(inventoryDetailsProvider(id));
        return (true, 'Inventário finalizado e estoque atualizado!');
      }
      return (false, 'Erro ao finalizar inventário');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }
}
