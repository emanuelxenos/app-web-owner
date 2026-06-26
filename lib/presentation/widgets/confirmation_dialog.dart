import 'package:flutter/material.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final VoidCallback? onConfirm;
  final bool isDangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.confirmColor,
    this.onConfirm,
    this.isDangerous = false,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDangerous: isDangerous,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = confirmColor ??
        (isDangerous ? AppTheme.accentRed : AppTheme.primaryColor);

    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: effectiveColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDangerous ? Icons.warning_amber_rounded : Icons.help_outline,
              color: effectiveColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(title, style: theme.textTheme.titleLarge),
        ],
      ),
      content: Text(message, style: theme.textTheme.bodyLarge),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.pop(context, true);
          },
          style: ElevatedButton.styleFrom(backgroundColor: effectiveColor),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
