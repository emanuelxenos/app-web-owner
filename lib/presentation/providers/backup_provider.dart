import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/backup_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/backup.dart';

part 'backup_provider.g.dart';

@riverpod
class BackupHistory extends _$BackupHistory {
  @override
  FutureOr<List<Backup>> build() async {
    return ref.read(backupRepositoryProvider).getBackupHistory();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(backupRepositoryProvider).getBackupHistory());
  }
}

@riverpod
class BackupExecutor extends _$BackupExecutor {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> executeBackup() async {
    state = const AsyncLoading();
    try {
      await ref.read(backupRepositoryProvider).executeBackup();
      state = const AsyncData(null);
      ref.read(backupHistoryProvider.notifier).refresh();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
