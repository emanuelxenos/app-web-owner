import 'package:flutter/material.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';

class ProductBulkActionsBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClearSelection;
  final VoidCallback onPrintLabels;
  final VoidCallback onEditPrices;
  final VoidCallback? onInactivateAll;

  const ProductBulkActionsBar({
    super.key,
    required this.selectedCount,
    required this.onClearSelection,
    required this.onPrintLabels,
    required this.onEditPrices,
    this.onInactivateAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2039),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: const Border(
          top: BorderSide(color: Colors.white10),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.5)),
            ),
            child: Text(
              '$selectedCount itens selecionados',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: onClearSelection,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Limpar'),
            style: TextButton.styleFrom(foregroundColor: Colors.white54),
          ),
          const Spacer(),
          Wrap(
            spacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: onPrintLabels,
                icon: const Icon(Icons.print_outlined),
                label: const Text('IMPRIMIR ETIQUETAS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: onEditPrices,
                icon: const Icon(Icons.price_change_rounded),
                label: const Text('REAJUSTAR PREÇOS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent.withValues(alpha: 0.8),
                  foregroundColor: Colors.white,
                ),
              ),
              if (onInactivateAll != null)
                OutlinedButton.icon(
                  onPressed: onInactivateAll,
                  icon: const Icon(Icons.block),
                  label: const Text('INATIVAR SELECIONADOS'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.accentRed,
                    side: const BorderSide(color: AppTheme.accentRed),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
