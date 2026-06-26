import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/core/constants/api_endpoints.dart';
import 'package:unifytechxenoswebowner/domain/models/backup.dart';
import 'package:unifytechxenoswebowner/services/api_service.dart';

part 'backup_repository.g.dart';

@riverpod
BackupRepository backupRepository(BackupRepositoryRef ref) {
  return BackupRepository(ref.read(apiServiceProvider));
}

class BackupRepository {
  final ApiService _api;
  BackupRepository(this._api);

  Future<void> executeBackup() async {
    await _api.post(ApiEndpoints.backup);
  }

  Future<List<Backup>> getBackupHistory() async {
    final response = await _api.get(ApiEndpoints.backup);
    final data = response.data;
    if (data is List) {
      return data.map((e) => Backup.fromJson(e as Map<String, dynamic>)).toList();
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List).map((e) => Backup.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
