import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/caixa_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/caixa.dart';

part 'caixa_provider.g.dart';

@riverpod
class CaixaSessions extends _$CaixaSessions {
  @override
  Future<List<SessaoCaixa>> build({String? inicio, String? fim}) async {
    return ref.read(caixaRepositoryProvider).sessoes(inicio: inicio, fim: fim);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(inicio: inicio, fim: fim));
  }
}

@riverpod
class CaixaMovements extends _$CaixaMovements {
  @override
  Future<List<CaixaMovimentacao>> build({String? inicio, String? fim}) async {
    return ref.read(caixaRepositoryProvider).movimentacoes(inicio: inicio, fim: fim);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(inicio: inicio, fim: fim));
  }
}

@riverpod
class TerminalsShowInactive extends _$TerminalsShowInactive {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

@riverpod
class PhysicalTerminals extends _$PhysicalTerminals {
  @override
  Future<List<CaixaFisico>> build() async {
    final showInactive = ref.watch(terminalsShowInactiveProvider);
    return ref.read(caixaRepositoryProvider).listarCaixasFisicos(
      status: showInactive ? 'inativos' : 'ativos',
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<bool> criar(Map<String, dynamic> data) async {
    try {
      await ref.read(caixaRepositoryProvider).criarCaixaFisico(data);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> atualizar(int id, Map<String, dynamic> data) async {
    try {
      await ref.read(caixaRepositoryProvider).atualizarCaixaFisico(id, data);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> excluir(int id) async {
    try {
      await ref.read(caixaRepositoryProvider).excluirCaixaFisico(id);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}

@riverpod
FutureOr<CaixaStatusResponse> caixaStatus(CaixaStatusRef ref) {
  return ref.read(caixaRepositoryProvider).status();
}
