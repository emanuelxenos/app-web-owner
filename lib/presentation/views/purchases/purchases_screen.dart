import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/purchase_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';
import 'package:unifytechxenoswebowner/presentation/views/purchases/suppliers_tab.dart';
import 'package:unifytechxenoswebowner/presentation/views/purchases/history_tab.dart';
import 'package:unifytechxenoswebowner/presentation/views/purchases/supplier_analytics_tab.dart';
import 'package:unifytechxenoswebowner/presentation/views/purchases/widgets/purchase_form_dialog.dart';
import 'package:unifytechxenoswebowner/presentation/views/purchases/widgets/purchases_help_dialog.dart';
import 'package:unifytechxenoswebowner/domain/models/purchase.dart';

class PurchasesScreen extends ConsumerWidget {
  const PurchasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Compras', style: theme.textTheme.headlineLarge),
                        const SizedBox(height: 4),
                        Text('Gestão de suprimentos e fornecedores', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const PurchasesHelpDialog(),
                      );
                    },
                    icon: const Icon(Icons.help_outline_rounded, color: Colors.teal),
                    tooltip: 'Manual de Compras',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.teal.withOpacity(0.1),
                      hoverColor: Colors.teal.withOpacity(0.2),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Tabs
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppTheme.primaryColor,
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(text: 'HISTÓRICO DE COMPRAS'),
                  Tab(text: 'FORNECEDORES'),
                  Tab(text: 'CONSULTAS POR FORNECEDOR'),
                ],
              ),
              const SizedBox(height: 16),
              // Content
              Expanded(
                child: TabBarView(
                  children: [
                    // History Tab
                    const HistoryTab(),
                    // Suppliers Tab
                    const SuppliersTab(),
                    // Analytics Tab
                    const SupplierAnalyticsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
