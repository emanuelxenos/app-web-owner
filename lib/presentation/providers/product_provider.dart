import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/product_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';
import 'package:unifytechxenoswebowner/domain/models/pagination.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'product_provider.g.dart';

class ProductState {
  final int page;
  final int limit;
  final int? categoriaId;
  final String search;
  final bool onlyLowStock;
  final bool onlyExpiring;
  final bool onlyReposition;
  final AsyncValue<PaginatedResponse<Produto>> response;

  ProductState({
    this.page = 1,
    this.limit = 50,
    this.categoriaId,
    this.search = '',
    this.onlyLowStock = false,
    this.onlyExpiring = false,
    this.onlyReposition = false,
    this.response = const AsyncLoading(),
  });

  ProductState copyWith({
    int? page,
    int? limit,
    int? categoriaId,
    bool clearCategoria = false,
    String? search,
    bool? onlyLowStock,
    bool? onlyExpiring,
    bool? onlyReposition,
    AsyncValue<PaginatedResponse<Produto>>? response,
  }) {
    return ProductState(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      categoriaId: clearCategoria ? null : (categoriaId ?? this.categoriaId),
      search: search ?? this.search,
      onlyLowStock: onlyLowStock ?? this.onlyLowStock,
      onlyExpiring: onlyExpiring ?? this.onlyExpiring,
      onlyReposition: onlyReposition ?? this.onlyReposition,
      response: response ?? this.response,
    );
  }
}

@riverpod
class Products extends _$Products {
  @override
  ProductState build() {
    Future.microtask(() => _load());
    return ProductState();
  }

  Future<void> _load() async {
    state = state.copyWith(response: const AsyncLoading());
    final repo = ref.read(productRepositoryProvider);
    
    final result = await AsyncValue.guard(() => repo.listar(
      page: state.page,
      limit: state.limit,
      categoriaId: state.categoriaId,
      search: state.search,
      baixoEstoque: state.onlyLowStock || state.onlyReposition,
      vencendo: state.onlyExpiring,
    ));
    
    state = state.copyWith(response: result);
  }

  Future<void> refresh() => _load();

  void setPage(int page) {
    if (page < 1) return;
    state = state.copyWith(page: page);
    _load();
  }

  void setCategoria(int? catId) {
    state = state.copyWith(
      categoriaId: catId,
      clearCategoria: catId == null,
      page: 1,
    );
    _load();
  }

  void setSearch(String query) {
    state = state.copyWith(search: query, page: 1);
    _load();
  }

  void setFilterLowStock(bool value) {
    state = state.copyWith(onlyLowStock: value, page: 1);
    _load();
  }

  void setFilterExpiring(bool value) {
    state = state.copyWith(onlyExpiring: value, page: 1);
    _load();
  }

  void setFilterReposition(bool value) {
    state = state.copyWith(onlyReposition: value, page: 1);
    _load();
  }

  Future<(bool, String)> criar(CriarProdutoRequest request) async {
    try {
      await ref.read(productRepositoryProvider).criar(request);
      await refresh();
      return (true, 'Produto cadastrado com sucesso!');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> atualizar(int id, CriarProdutoRequest request) async {
    try {
      await ref.read(productRepositoryProvider).atualizar(id, request);
      await refresh();
      return (true, 'Produto atualizado com sucesso!');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> inativar(int id) async {
    try {
      await ref.read(productRepositoryProvider).inativar(id);
      await refresh();
      return (true, 'Produto inativado com sucesso!');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String, String?)> uploadFoto(List<int> bytes, String fileName) async {
    try {
      final url = await ref.read(productRepositoryProvider).uploadFoto(bytes, fileName);
      return (true, 'Upload realizado!', url);
    } catch (e) {
      return (false, ApiService.extractError(e), null);
    }
  }

  Future<(bool, String, Map<String, dynamic>?)> importarPlanilha(List<int> bytes, String fileName) async {
    try {
      final result = await ref.read(productRepositoryProvider).importarPlanilha(bytes, fileName);
      await refresh();
      final importados = result['importados'] ?? 0;
      final ignorados = result['ignorados'] ?? 0;
      return (true, 'Importação finalizada: $importados importados, $ignorados ignorados', result);
    } catch (e) {
      return (false, ApiService.extractError(e), null);
    }
  }

  Future<(bool, String)> atualizarPrecosLote(List<Map<String, dynamic>> updates) async {
    try {
      await ref.read(productRepositoryProvider).atualizarPrecosLote(updates);
      await refresh();
      return (true, 'Preços atualizados com sucesso!');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<ProdutoLookupResponse?> lookupExternal(String ean) async {
    try {
      return await ref.read(productRepositoryProvider).lookupExternal(ean);
    } catch (e) {
      return null;
    }
  }
}

@riverpod
class ProductSearch extends _$ProductSearch {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
AsyncValue<List<Produto>> filteredProducts(FilteredProductsRef ref) {
  final productsState = ref.watch(productsProvider);
  final query = ref.watch(productSearchProvider).toLowerCase();

  return productsState.response.when(
    data: (paginated) {
      final products = paginated.data;
      if (query.isEmpty) return AsyncValue.data(products);
      final filtered = products.where((p) {
        return p.nome.toLowerCase().contains(query) ||
            (p.codigoBarras?.toLowerCase().contains(query) ?? false) ||
            (p.categoriaNome?.toLowerCase().contains(query) ?? false);
      }).toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncLoading(),
    error: (e, s) => AsyncError(e, s),
  );
}
