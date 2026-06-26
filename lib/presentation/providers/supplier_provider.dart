import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/supplier_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/supplier.dart';

part 'supplier_provider.g.dart';

@riverpod
class Suppliers extends _$Suppliers {
  @override
  FutureOr<List<Fornecedor>> build() async {
    final incluirInativos = ref.watch(supplierInactivesProvider);
    return _fetch(incluirInativos);
  }

  Future<List<Fornecedor>> _fetch(bool incluirInativos) async {
    return ref.read(supplierRepositoryProvider).listar(incluirInativos: incluirInativos);
  }

  Future<void> refresh() async {
    final incluirInativos = ref.read(supplierInactivesProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetch(incluirInativos));
  }

  Future<(bool, String)> criar(CriarFornecedorRequest request) async {
    try {
      await ref.read(supplierRepositoryProvider).criar(request);
      await refresh();
      return (true, 'Fornecedor cadastrado com sucesso');
    } catch (e) {
      return (false, 'Erro ao cadastrar fornecedor: $e');
    }
  }

  Future<(bool, String)> atualizar(int id, CriarFornecedorRequest request) async {
    try {
      await ref.read(supplierRepositoryProvider).atualizar(id, request);
      await refresh();
      return (true, 'Fornecedor atualizado com sucesso');
    } catch (e) {
      return (false, 'Erro ao atualizar fornecedor: $e');
    }
  }

  Future<(bool, String)> inativar(int id) async {
    try {
      await ref.read(supplierRepositoryProvider).inativar(id);
      await refresh();
      return (true, 'Fornecedor inativado com sucesso');
    } catch (e) {
      return (false, 'Erro ao inativar fornecedor: $e');
    }
  }
}

@riverpod
List<Fornecedor> filteredSuppliers(FilteredSuppliersRef ref) {
  final suppliersAsync = ref.watch(suppliersProvider);
  final query = ref.watch(supplierSearchProvider).toLowerCase();

  return suppliersAsync.maybeWhen(
    data: (list) {
      if (query.isEmpty) return list;
      return list.where((s) => 
        s.razaoSocial.toLowerCase().contains(query) ||
        (s.nomeFantasia?.toLowerCase().contains(query) ?? false) ||
        (s.cnpj?.contains(query) ?? false)
      ).toList();
    },
    orElse: () => [],
  );
}

class SupplierPaginationFilters {
  final int page;
  final int limit;

  const SupplierPaginationFilters({this.page = 1, this.limit = 10});

  SupplierPaginationFilters copyWith({int? page, int? limit}) {
    return SupplierPaginationFilters(
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}

@riverpod
class SupplierPaginationState extends _$SupplierPaginationState {
  @override
  SupplierPaginationFilters build() => const SupplierPaginationFilters();

  void setPage(int page) => state = state.copyWith(page: page);
  void setLimit(int limit) => state = state.copyWith(limit: limit, page: 1);
  void reset() => state = const SupplierPaginationFilters();
}

@riverpod
List<Fornecedor> paginatedFilteredSuppliers(PaginatedFilteredSuppliersRef ref) {
  final filtered = ref.watch(filteredSuppliersProvider);
  final filters = ref.watch(supplierPaginationStateProvider);
  
  final start = (filters.page - 1) * filters.limit;
  if (start >= filtered.length) return [];
  
  final end = start + filters.limit;
  return filtered.sublist(start, end > filtered.length ? filtered.length : end);
}

@riverpod
class SupplierSearch extends _$SupplierSearch {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
class SupplierInactives extends _$SupplierInactives {
  @override
  bool build() => false;

  void toggle() => state = !state;
  void set(bool value) => state = value;
}

@Riverpod(keepAlive: true)
class SelectedSupplierAnalytics extends _$SelectedSupplierAnalytics {
  @override
  int? build() => null;

  void select(int? id) => state = id;
}
