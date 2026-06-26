import 'package:flutter/material.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/presentation/views/sales/widgets/sales_help_dialog.dart';

class TabItem {
  final String title;
  final String subtitle;
  final IconData icon;
  TabItem({required this.title, required this.subtitle, required this.icon});
}

class TabSidebar extends StatelessWidget {
  final List<TabItem> tabs;
  final int selectedIndex;
  final Function(int) onSelected;

  const TabSidebar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.5),
        border: Border(right: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vendas & Caixa',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Gestão Operacional',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline, color: AppTheme.primaryColor),
                  tooltip: 'Manual de Ajuda',
                  splashRadius: 24,
                  onPressed: () {
                    showDialog(context: context, builder: (_) => const SalesHelpDialog());
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final item = tabs[index];
                final isSelected = selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => onSelected(index),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.3) : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected ? AppTheme.primaryColor : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected ? AppTheme.primaryColor : null,
                                  ),
                                ),
                                Text(
                                  item.subtitle,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
