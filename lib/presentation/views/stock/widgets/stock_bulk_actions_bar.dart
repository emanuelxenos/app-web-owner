import 'package:flutter/material.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';

class StockBulkActionsBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onPrintLabels;
  final VoidCallback onCancel;

  const StockBulkActionsBar({
    super.key,
    required this.selectedCount,
    required this.onPrintLabels,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.glassBoxShadow,
      ),
      child: Row(
        children: [
          Text(
            '$selectedCount itens selecionados',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onPrintLabels,
            icon: const Icon(Icons.print_rounded, size: 18),
            label: const Text('Imprimir Etiquetas (Lote)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
