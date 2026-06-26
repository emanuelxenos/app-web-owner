class AppConstants {
  AppConstants._();

  static const String appName = 'UnifyTech Xenos';
  static const String appSubtitle = 'Sistema de Gestão de Mercado';
  static const String appVersion = '1.0.0';

  static const int defaultPort = 8080;
  static const String defaultHost = 'localhost';

  static const String tokenKey = 'auth_token';
  static const String serverHostKey = 'server_host';
  static const String serverPortKey = 'server_port';
  static const String themeKey = 'theme_mode';
  static const String selectedStoreKey = 'selected_store_cnpj';

  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const int maxRetries = 3;
}
