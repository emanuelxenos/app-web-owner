import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/user_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/user.dart';

part 'user_management_provider.g.dart';

@riverpod
class UserManagement extends _$UserManagement {
  @override
  FutureOr<List<Usuario>> build() async {
    return ref.read(userRepositoryProvider).listar();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(userRepositoryProvider).listar());
  }

  Future<void> criarUsuario(CriarUsuarioRequest req) async {
    await ref.read(userRepositoryProvider).criar(req);
    await refresh();
  }

  Future<void> atualizarUsuario(int id, CriarUsuarioRequest req) async {
    await ref.read(userRepositoryProvider).atualizar(id, req);
    await refresh();
  }

  Future<void> inativarUsuario(int id) async {
    await ref.read(userRepositoryProvider).inativar(id);
    await refresh();
  }
}
