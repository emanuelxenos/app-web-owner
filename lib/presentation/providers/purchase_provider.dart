import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/purchase_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/purchase.dart';
import 'package:unifytechxenoswebowner/presentation/providers/product_provider.dart';
import 'package:unifytechxenoswebowner/presentation/providers/stock_provider.dart';

import 'package:unifytechxenoswebowner/domain/models/pagination.dart';

part 'purchase_provider.g.dart';

class PurchaseFilters {
  final int? fornecedorId;
  final String? status;
  final String? notaFiscal;
  final DateTime? dataInicio;
  final DateTime? dataFim;
  final int page;
  final int limit;

  const PurchaseFilters({
    this.fornecedorId,
    this.status,
    this.notaFiscal,
    this.dataInicio,
    this.dataFim,
    this.page = 1,
    this.limit = 20,
  });

  PurchaseFilters copyWith({
    int? fornecedorId,
    bool clearFornecedor = false,
    String? status,
    String? notaFiscal,
    DateTime? dataInicio,
    DateTime? dataFim,
    int? page,
    int? limit,
  }) {
    return PurchaseFilters(
      fornecedorId: clearFornecedor ? null : (fornecedorId ?? this.fornecedorId),
      status: status ?? this.status,
      notaFiscal: notaFiscal ?? this.notaFiscal,
      dataInicio: dataInicio ?? this.dataInicio,
      dataFim: dataFim ?? this.dataFim,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}

@riverpod
class Purchases extends _$Purchases {
  @override
  FutureOr<PaginatedResponse<Compra>> build() async {
    final filters = ref.watch(purchaseFilterStateProvider);
    return _fetch(filters);
  }

  Future<PaginatedResponse<Compra>> _fetch(PurchaseFilters filters) async {
    return ref.read(purchaseRepositoryProvider).listar(
      fornecedorId: filters.fornecedorId,
      status: filters.status,
      notaFiscal: filters.notaFiscal,
      dataInicio: filters.dataInicio,
      dataFim: filters.dataFim,
      page: filters.page,
      limit: filters.limit,
    );
  }

  Future<void> refresh() async {
    final filters = ref.read(purchaseFilterStateProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(filters));
  }
}

@riverpod
class PurchaseActions extends _$PurchaseActions {
  @override
  bool build() => false;

  Future<(bool, String)> criar(CriarCompraRequest request) async {
    try {
      await ref.read(purchaseRepositoryProvider).criar(request);
      ref.invalidate(purchasesProvider);
      return (true, 'Compra registrada com sucesso');
    } catch (e) {
      return (false, 'Erro ao registrar compra: $e');
    }
  }

  Future<(bool, String)> receber(int id, ReceberCompraRequest request) async {
    try {
      await ref.read(purchaseRepositoryProvider).receber(id, request);
      ref.invalidate(purchasesProvider);
      ref.invalidate(productsProvider); 
      ref.invalidate(lowStockProvider);
      return (true, 'Compra marked as received');
    } catch (e) {
      return (false, 'Erro ao receber compra: $e');
    }
  }
}

@riverpod
Future<List<Compra>> supplierHistory(SupplierHistoryRef ref, int supplierId) async {
  if (supplierId == 0) return [];
  final paginated = await ref.read(purchaseRepositoryProvider).listar(
        fornecedorId: supplierId,
        limit: 1000,
      );
  return paginated.data;
}

@riverpod
class SupplierHistoryState extends _$SupplierHistoryState {
  @override
  PurchaseFilters build(int supplierId) {
    return const PurchaseFilters(limit: 10);
  }

  void setPage(int page) => state = state.copyWith(page: page);
  void setLimit(int limit) => state = state.copyWith(limit: limit, page: 1);
}

@riverpod
FutureOr<PaginatedResponse<Compra>> paginatedSupplierHistory(
  PaginatedSupplierHistoryRef ref,
  int supplierId,
) {
  final filters = ref.watch(supplierHistoryStateProvider(supplierId));
  return ref.read(purchaseRepositoryProvider).listar(
        fornecedorId: supplierId,
        page: filters.page,
        limit: filters.limit,
      );
}

@riverpod
class PurchaseFilterState extends _$PurchaseFilterState {
  @override
  PurchaseFilters build() => const PurchaseFilters();

  void setFornecedorId(int? id) => state = state.copyWith(
    fornecedorId: id,
    clearFornecedor: id == null,
    page: 1,
  );
  void setStatus(String? status) => state = state.copyWith(status: status, page: 1);
  void setNotaFiscal(String? nf) => state = state.copyWith(notaFiscal: nf, page: 1);
  void setRange(DateTimeRange? range) => state = state.copyWith(
    dataInicio: range?.start,
    dataFim: range?.end,
    page: 1,
  );
  void setPage(int page) => state = state.copyWith(page: page);
  void setLimit(int limit) => state = state.copyWith(limit: limit, page: 1);
  void clear() => state = const PurchaseFilters();
}

@riverpod
Future<Compra> purchaseDetail(PurchaseDetailRef ref, int id) {
  return ref.read(purchaseRepositoryProvider).buscarPorID(id);
}
