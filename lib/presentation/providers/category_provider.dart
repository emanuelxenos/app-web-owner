import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/category_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/category.dart';
import 'package:unifytechxenoswebowner/domain/models/pagination.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'category_provider.g.dart';

class CategoryState {
  final int page;
  final int limit;
  final String search;
  final AsyncValue<PaginatedResponse<Categoria>> response;

  CategoryState({
    this.page = 1,
    this.limit = 50,
    this.search = '',
    this.response = const AsyncLoading(),
  });

  CategoryState copyWith({
    int? page,
    int? limit,
    String? search,
    AsyncValue<PaginatedResponse<Categoria>>? response,
  }) {
    return CategoryState(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      response: response ?? this.response,
    );
  }
}

@riverpod
class Categories extends _$Categories {
  @override
  CategoryState build() {
    // Schdedule initial load outside of build cycle
    Future.microtask(() => _load());
    return CategoryState();
  }

  Future<void> _load() async {
    final repo = ref.read(categoryRepositoryProvider);
    state = state.copyWith(response: const AsyncLoading());
    
    final result = await AsyncValue.guard(() => repo.listarCategorias(
      page: state.page,
      limit: state.limit,
      search: state.search,
    ));
    
    state = state.copyWith(response: result);
  }

  Future<void> refresh() => _load();

  void setPage(int page) {
    if (page < 1) return;
    state = state.copyWith(page: page);
    _load();
  }

  void setSearch(String search) {
    state = state.copyWith(search: search, page: 1);
    _load();
  }

  Future<(bool, String)> criar(CriarCategoriaRequest request) async {
    try {
      await ref.read(categoryRepositoryProvider).criarCategoria(request);
      await refresh();
      return (true, 'Categoria cadastrada com sucesso!');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> atualizar(int id, CriarCategoriaRequest request) async {
    try {
      await ref.read(categoryRepositoryProvider).atualizarCategoria(id, request);
      await refresh();
      return (true, 'Categoria atualizada com sucesso!');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }

  Future<(bool, String)> inativar(int id) async {
    try {
      await ref.read(categoryRepositoryProvider).inativarCategoria(id);
      await refresh();
      return (true, 'Categoria inativada com sucesso!');
    } catch (e) {
      return (false, ApiService.extractError(e));
    }
  }
}
