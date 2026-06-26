// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$backupHistoryHash() => r'174286e5b4ab035f3782f503897568defe341783';

/// See also [BackupHistory].
@ProviderFor(BackupHistory)
final backupHistoryProvider =
    AutoDisposeAsyncNotifierProvider<BackupHistory, List<Backup>>.internal(
      BackupHistory.new,
      name: r'backupHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$backupHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BackupHistory = AutoDisposeAsyncNotifier<List<Backup>>;
String _$backupExecutorHash() => r'4875b0cb49db35f5e7f3d6c2cad61b625d255231';

/// See also [BackupExecutor].
@ProviderFor(BackupExecutor)
final backupExecutorProvider =
    AutoDisposeNotifierProvider<BackupExecutor, AsyncValue<void>>.internal(
      BackupExecutor.new,
      name: r'backupExecutorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$backupExecutorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BackupExecutor = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
