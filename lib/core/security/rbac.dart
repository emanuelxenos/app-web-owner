class RBAC {
  static const owner = 'owner';
  static const admin = 'admin';
  static const gerente = 'gerente';
  static const supervisor = 'supervisor';
  static const caixa = 'caixa';

  static const Map<String, List<String>> rolePermissions = {
    owner: ['*'],
    admin: ['*'],
    gerente: [
      '/',
      '/produtos',
      '/categorias',
      '/clientes',
      '/estoque',
      '/vendas',
      '/nfe',
      '/terminais',
      '/compras',
      '/financeiro',
      '/relatorios',
    ], // gerente não tem acesso a parâmetros e configurações
    supervisor: [
      '/',
      '/produtos',
      '/categorias',
      '/clientes',
      '/estoque',
      '/vendas',
      '/nfe',
      '/terminais',
      '/compras',
      '/financeiro',
      '/relatorios',
    ], // supervisor não tem acesso a parâmetros e configurações
  };

  static bool canAccess(String? role, String path) {
    if (role == null) return false;
    final normalizedRole = role.toLowerCase();

    if (normalizedRole == owner || normalizedRole == admin || normalizedRole == gerente) return true;

    final permissions = rolePermissions[normalizedRole] ?? ['/'];

    for (var allowed in permissions) {
      if (allowed == '*') return true;
      if (allowed == '/' && path == '/') return true;
      if (allowed != '/' && path.startsWith(allowed)) return true;
    }

    return false;
  }
}
