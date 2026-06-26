import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/empresa_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/company.dart';

part 'empresa_provider.g.dart';

@riverpod
class EmpresaState extends _$EmpresaState {
  @override
  FutureOr<Empresa> build() async {
    return ref.read(empresaRepositoryProvider).buscar();
  }

  Future<void> atualizarEmpresa(Empresa empresa) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(empresaRepositoryProvider).atualizar(empresa);
      return empresa;
    });
  }

  Future<void> atualizarFiscal(Map<String, dynamic> fiscalData) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(empresaRepositoryProvider).atualizarFiscal(fiscalData);
      return ref.read(empresaRepositoryProvider).buscar();
    });
  }

  Future<void> uploadCertificado(String filePath) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(empresaRepositoryProvider).uploadCertificado(filePath);
      return ref.read(empresaRepositoryProvider).buscar();
    });
  }
}
