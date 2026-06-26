import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/presentation/providers/auth_provider.dart';
import 'package:unifytechxenoswebowner/services/license_service.dart';
import 'package:unifytechxenoswebowner/core/security/rbac.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentPath = GoRouterState.of(context).uri.toString();
    final theme = Theme.of(context);
    final licenseAsync = ref.watch(licenseNotifierProvider);

    Widget? banner;
    if (licenseAsync is AsyncData) {
      final license = licenseAsync.value!;
      if (license.permitido && license.diasRestantes <= 5 && license.diasRestantes >= 0 && license.validade.isNotEmpty) {
        banner = Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: AppTheme.accentRed.withOpacity(0.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Atenção: Sua licença expira em ${license.diasRestantes} dia(s). Regularize para evitar o bloqueio do sistema.',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      body: Column(
        children: [
          if (banner != null) banner,
          Expanded(
            child: Row(
              children: [
                // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: _isExpanded ? 260 : 72,
            decoration: BoxDecoration(
              gradient: AppTheme.sidebarGradient,
              border: Border(
                right: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    // Logo
                    Container(
                      height: 70,
                      padding: EdgeInsets.symmetric(
                        horizontal: _isExpanded ? 20 : 12,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.store_rounded,
                                color: Colors.white, size: 22),
                          ),
                          if (_isExpanded) ...[
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'UnifyTech',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Admin',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Nav Items
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              if (RBAC.canAccess(authState.role, '/'))
                                _NavItem(
                                  icon: Icons.dashboard_rounded,
                                  label: 'Dashboard',
                                  isActive: currentPath == '/',
                                  isExpanded: _isExpanded,
                                  onTap: () => context.go('/'),
                                ),
                              if (RBAC.canAccess(authState.role, '/produtos'))
                                _NavItem(
                                  icon: Icons.inventory_2_rounded,
                                  label: 'Produtos',
                                  isActive: currentPath.startsWith('/produtos'),
                                  isExpanded: _isExpanded,
                                  onTap: () => context.go('/produtos'),
                                ),
                              if (RBAC.canAccess(authState.role, '/categorias'))
                                _NavItem(
                                  icon: Icons.category_rounded,
                                  label: 'Categorias',
                                  isActive: currentPath.startsWith('/categorias'),
                                  isExpanded: _isExpanded,
                                  onTap: () => context.go('/categorias'),
                                ),
                              if (RBAC.canAccess(authState.role, '/clientes'))
                                _NavItem(
                                  icon: Icons.people_alt_rounded,
                                  label: 'Clientes',
                                  isActive: currentPath.startsWith('/clientes'),
                                  isExpanded: _isExpanded,
                                  onTap: () => context.go('/clientes'),
                                ),
                              if (RBAC.canAccess(authState.role, '/estoque'))
                                _NavItem(
                                  icon: Icons.warehouse_rounded,
                                  label: 'Estoque',
                                  isActive: currentPath.startsWith('/estoque'),
                                  isExpanded: _isExpanded,
                                  onTap: () => context.go('/estoque'),
                                ),
                              if (RBAC.canAccess(authState.role, '/vendas'))
                                _NavItem(
                                  icon: Icons.point_of_sale_rounded,
                                  label: 'Vendas',
                                  isActive: currentPath.startsWith('/vendas'),
                                  isExpanded: _isExpanded,
                                  onTap: () => context.go('/vendas'),
                                ),
                              if (RBAC.canAccess(authState.role, '/compras'))
                                _NavItem(
                                  icon: Icons.local_shipping_rounded,
                                  label: 'Compras',
                                  isActive: currentPath.startsWith('/compras'),
                                  isExpanded: _isExpanded,
                                  onTap: () => context.go('/compras'),
                                ),
                              if (RBAC.canAccess(authState.role, '/financeiro'))
                                _NavItem(
                                  icon: Icons.account_balance_wallet_rounded,
                                  label: 'Financeiro',
                                  isActive: currentPath.startsWith('/financeiro'),
                                  isExpanded: _isExpanded,
                                  onTap: () => context.go('/financeiro'),
                                ),
                              if (RBAC.canAccess(authState.role, '/relatorios'))
                                _NavItem(
                                  icon: Icons.bar_chart_rounded,
                                  label: 'Relatórios',
                                  isActive: currentPath.startsWith('/relatorios'),
                                  isExpanded: _isExpanded,
                                  onTap: () => context.go('/relatorios'),
                                ),
                              if (RBAC.canAccess(authState.role, '/parametros') || RBAC.canAccess(authState.role, '/configuracoes')) ...[
                                const SizedBox(height: 8),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _isExpanded ? 16 : 8),
                                  child: const Divider(height: 1),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (RBAC.canAccess(authState.role, '/parametros'))
                                _NavItem(
                                  icon: Icons.tune_rounded,
                                  label: 'Parâmetros',
                                  isActive: currentPath.startsWith('/parametros'),
                                  isExpanded: _isExpanded,
                                  onTap: () => context.go('/parametros'),
                                ),
                              if (RBAC.canAccess(authState.role, '/configuracoes'))
                                _NavItem(
                                  icon: Icons.settings_rounded,
                                  label: 'Configurações',
                                  isActive: currentPath.startsWith('/configuracoes'),
                                  isExpanded: _isExpanded,
                                  onTap: () => context.go('/configuracoes'),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // User area & Toggle (Only show fixed part if enough height)
                    if (constraints.maxHeight > 200) ...[
                      const Divider(height: 1),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: _isExpanded ? 16 : 12,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  AppTheme.primaryColor.withValues(alpha: 0.2),
                              child: Text(
                                'D',
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (_isExpanded) ...[
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Dono',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      authState.role?.toUpperCase() ?? '',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white60,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    ref.read(authProvider.notifier).logout(),
                                icon: const Icon(Icons.logout_rounded, size: 18),
                                tooltip: 'Sair',
                                color: Colors.white70,
                              ),
                            ],
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _isExpanded = !_isExpanded),
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Icon(
                            _isExpanded ? Icons.chevron_left : Icons.chevron_right,
                            color: Colors.white54,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          // Content
          Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isExpanded;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = AppTheme.primaryColor;
    final isHighlighted = widget.isActive || _hovering;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isExpanded ? 12 : 8,
        vertical: 2,
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isExpanded ? 14 : 0,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              gradient: widget.isActive
                  ? LinearGradient(
                      colors: [
                        activeColor.withValues(alpha: 0.15),
                        activeColor.withValues(alpha: 0.05),
                      ],
                    )
                  : null,
              color: _hovering && !widget.isActive
                  ? activeColor.withValues(alpha: 0.06)
                  : null,
              borderRadius: BorderRadius.circular(10),
              border: widget.isActive
                  ? Border.all(color: activeColor.withValues(alpha: 0.2))
                  : null,
            ),
            child: Row(
              mainAxisAlignment: widget.isExpanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  color: isHighlighted
                      ? activeColor
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                if (widget.isExpanded) ...[
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: isHighlighted
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
