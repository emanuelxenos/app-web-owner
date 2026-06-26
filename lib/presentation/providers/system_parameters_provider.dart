import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/system_parameters_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/system_parameters.dart';

part 'system_parameters_provider.g.dart';

@Riverpod(keepAlive: true)
class SystemParametersState extends _$SystemParametersState {
  @override
  FutureOr<SystemParameters> build() {
    return ref.read(systemParametersRepositoryProvider).getParameters();
  }

  Future<void> updateParameters(SystemParameters params) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(systemParametersRepositoryProvider).updateParameters(params);
      state = AsyncValue.data(params);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
