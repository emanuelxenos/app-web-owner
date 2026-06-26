import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifytechxenoswebowner/core/constants/app_constants.dart';

part 'local_config.g.dart';

@Riverpod(keepAlive: true)
LocalConfig localConfig(LocalConfigRef ref) {
  // This will be overridden in main.dart with the actual instance
  throw UnimplementedError('localConfig must be overridden');
}

class LocalConfig {
  final SharedPreferences _prefs;

  LocalConfig(this._prefs);

  // Server config
  String get serverHost =>
      _prefs.getString(AppConstants.serverHostKey) ?? AppConstants.defaultHost;

  int get serverPort =>
      _prefs.getInt(AppConstants.serverPortKey) ?? AppConstants.defaultPort;

  bool get hasServerConfig =>
      _prefs.containsKey(AppConstants.serverHostKey);

  Future<void> setServer(String host, int port) async {
    await _prefs.setString(AppConstants.serverHostKey, host);
    await _prefs.setInt(AppConstants.serverPortKey, port);
  }

  // Auth token
  String? get token => _prefs.getString(AppConstants.tokenKey);

  Future<void> setToken(String token) async {
    await _prefs.setString(AppConstants.tokenKey, token);
  }

  Future<void> clearToken() async {
    await _prefs.remove(AppConstants.tokenKey);
  }

  bool get isLoggedIn => token != null && token!.isNotEmpty;

  // Selected Store
  String? get selectedStoreCnpj => _prefs.getString(AppConstants.selectedStoreKey);

  Future<void> setSelectedStoreCnpj(String cnpj) async {
    await _prefs.setString(AppConstants.selectedStoreKey, cnpj);
  }

  Future<void> clearSelectedStore() async {
    await _prefs.remove(AppConstants.selectedStoreKey);
  }

  // Theme
  bool get isDarkMode => _prefs.getBool(AppConstants.themeKey) ?? true;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(AppConstants.themeKey, value);
  }
}
