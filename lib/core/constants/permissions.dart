enum UserProfile {
  admin,
  gerente,
  supervisor,
  caixa;

  static UserProfile fromString(String value) {
    return UserProfile.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => UserProfile.caixa,
    );
  }

  String get displayName {
    switch (this) {
      case UserProfile.admin:
        return 'Administrador';
      case UserProfile.gerente:
        return 'Gerente';
      case UserProfile.supervisor:
        return 'Supervisor';
      case UserProfile.caixa:
        return 'Operador de Caixa';
    }
  }

  int get level {
    switch (this) {
      case UserProfile.admin:
        return 4;
      case UserProfile.gerente:
        return 3;
      case UserProfile.supervisor:
        return 2;
      case UserProfile.caixa:
        return 1;
    }
  }

  bool hasAccessTo(UserProfile required) => level >= required.level;
}

class Permissions {
  Permissions._();

  static bool canManageProducts(UserProfile profile) =>
      profile.hasAccessTo(UserProfile.gerente);

  static bool canManageStock(UserProfile profile) =>
      profile.hasAccessTo(UserProfile.gerente);

  static bool canManagePurchases(UserProfile profile) =>
      profile.hasAccessTo(UserProfile.gerente);

  static bool canManageFinance(UserProfile profile) =>
      profile.hasAccessTo(UserProfile.gerente);

  static bool canViewReports(UserProfile profile) =>
      profile.hasAccessTo(UserProfile.supervisor);

  static bool canManageUsers(UserProfile profile) =>
      profile.hasAccessTo(UserProfile.admin);

  static bool canManageSettings(UserProfile profile) =>
      profile.hasAccessTo(UserProfile.admin);

  static bool canBackup(UserProfile profile) =>
      profile.hasAccessTo(UserProfile.admin);
}
