import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:unifytechxenoswebowner/presentation/views/sales/widgets/tab_sidebar.dart';
import 'package:unifytechxenoswebowner/presentation/views/sales/widgets/vendas_history_view.dart';
import 'package:unifytechxenoswebowner/presentation/views/sales/widgets/caixa_sessions_view.dart';
import 'package:unifytechxenoswebowner/presentation/views/sales/widgets/caixa_movements_view.dart';

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});
  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  int _selectedTabIndex = 0;

  final List<TabItem> _tabs = [
    TabItem(
      title: 'Histórico de Vendas',
      subtitle: 'Log completo de transações',
      icon: Icons.receipt_long_rounded,
    ),
    TabItem(
      title: 'Sessões de Caixa',
      subtitle: 'Aberturas e fechamentos',
      icon: Icons.point_of_sale_rounded,
    ),
    TabItem(
      title: 'Sangrias & Suprimentos',
      subtitle: 'Movimentações de gaveta',
      icon: Icons.account_balance_wallet_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar de Navegação
          TabSidebar(
            tabs: _tabs,
            selectedIndex: _selectedTabIndex,
            onSelected: (index) => setState(() => _selectedTabIndex = index),
          ),
          const SizedBox(width: 24),
          // Conteúdo Ativo
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 24, right: 24, bottom: 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: KeyedSubtree(
                  key: ValueKey(_selectedTabIndex),
                  child: _buildActiveTab(theme),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTab(ThemeData theme) {
    switch (_selectedTabIndex) {
      case 0:
        return const VendasHistoryView();
      case 1:
        return const CaixaSessionsView();
      case 2:
        return const CaixaMovementsView();
      default:
        return const Center(child: Text('Em desenvolvimento'));
    }
  }
}
