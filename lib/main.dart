import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/data/local/local_config.dart';
import 'package:unifytechxenoswebowner/presentation/providers/auth_provider.dart';
import 'package:unifytechxenoswebowner/presentation/views/shell/app_shell.dart';
import 'package:unifytechxenoswebowner/presentation/views/login/login_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/login/store_selection_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/super_admin/super_admin_screen.dart';
import 'package:unifytechxenoswebowner/services/license_service.dart';
import 'package:unifytechxenoswebowner/presentation/views/license/license_blocked_screen.dart';
import 'package:unifytechxenoswebowner/core/security/rbac.dart';
import 'package:unifytechxenoswebowner/presentation/views/dashboard/dashboard_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/products/products_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/categories/categories_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/customers/customers_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/stock/stock_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/sales/sales_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/purchases/purchases_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/finance/finance_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/reports/reports_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/settings/settings_screen.dart';
import 'package:unifytechxenoswebowner/presentation/views/settings/system_parameters_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final config = LocalConfig(prefs);

  runApp(
    ProviderScope(
      overrides: [
        localConfigProvider.overrideWithValue(config),
      ],
      child: const UnifyTechAdminApp(),
    ),
  );
}

class UnifyTechAdminApp extends ConsumerWidget {
  const UnifyTechAdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final localConfig = ref.watch(localConfigProvider);
    final licenseAsync = ref.watch(licenseNotifierProvider);

    final router = GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final isLogin = state.uri.toString() == '/login';
        final isLicenseBlocked = state.uri.toString() == '/license-blocked';
        
        final isSelectStore = state.uri.toString() == '/select-store';
        final isSuperAdmin = state.uri.toString() == '/super-admin';

        // If not authenticated, go to login
        if (!authState.isAuthenticated && !isLogin) {
          return '/login';
        }

        // If authenticated
        if (authState.isAuthenticated) {
          // Super Admin Logic
          if (authState.role == 'super_admin') {
            if (isLogin || isSelectStore || state.uri.toString() == '/') {
              return '/super-admin';
            }
            return null; // Super Admin can access anything, but defaults to /super-admin
          }

          // Regular Owner Logic
          final hasStore = localConfig.selectedStoreCnpj != null;
          if (!hasStore && !isSelectStore) {
             return '/select-store';
          }
          if (hasStore && isSelectStore) {
             return '/';
          }
          if (isLogin) {
             return hasStore ? '/' : '/select-store';
          }

          // RBAC check
          if (!isLogin && !isSelectStore) {
            final uriString = state.uri.toString();
            // Permit root
            if (uriString != '/' && !RBAC.canAccess(authState.role, uriString)) {
              return '/';
            }
          }
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/select-store',
          builder: (context, state) => const StoreSelectionScreen(),
        ),

        GoRoute(
          path: '/license-blocked',
          builder: (context, state) => const LicenseBlockedScreen(),
        ),
        GoRoute(
          path: '/super-admin',
          builder: (context, state) => const SuperAdminScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: '/produtos',
              builder: (context, state) => const ProductsScreen(),
            ),
            GoRoute(
              path: '/categorias',
              builder: (context, state) => const CategoriesScreen(),
            ),
            GoRoute(
              path: '/clientes',
              builder: (context, state) => const CustomersScreen(),
            ),
            GoRoute(
              path: '/estoque',
              builder: (context, state) => const StockScreen(),
            ),

            GoRoute(
              path: '/vendas',
              builder: (context, state) => const SalesScreen(),
            ),
            GoRoute(
              path: '/compras',
              builder: (context, state) => const PurchasesScreen(),
            ),
            GoRoute(
              path: '/financeiro',
              builder: (context, state) => const FinanceScreen(),
            ),
            GoRoute(
              path: '/relatorios',
              builder: (context, state) => const ReportsScreen(),
            ),
            GoRoute(
              path: '/configuracoes',
              builder: (context, state) => const SettingsScreen(),
            ),
            GoRoute(
              path: '/parametros',
              builder: (context, state) => const SystemParametersScreen(),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'UnifyTech Xenos - Admin',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const CustomScrollBehavior(),
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  const CustomScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    switch (axisDirectionToAxis(details.direction)) {
      case Axis.horizontal:
        return Scrollbar(
          controller: details.controller,
          thumbVisibility: true,
          trackVisibility: false,
          child: child,
        );
      case Axis.vertical:
        return Scrollbar(
          controller: details.controller,
          thumbVisibility: true,
          trackVisibility: false,
          child: child,
        );
    }
  }
}
