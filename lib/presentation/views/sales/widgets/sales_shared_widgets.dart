import 'package:flutter/material.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';

Widget buildViewHeader({required String title, required IconData icon, List<Widget>? actions}) {
  return Row(
    children: [
      Icon(icon, size: 28, color: AppTheme.primaryColor),
      const SizedBox(width: 12),
      Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const Spacer(),
      if (actions != null) ...actions,
    ],
  );
}

class DateRangeButton extends StatelessWidget {
  final DateTime inicio;
  final DateTime fim;
  final Function(DateTime, DateTime) onChanged;

  const DateRangeButton({super.key, required this.inicio, required this.fim, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final currentRange = DateTimeRange(start: inicio, end: fim);
        final dateRange = await showDateRangePicker(
          context: context,
          initialDateRange: currentRange,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppTheme.primaryColor,
                onPrimary: Colors.white,
                surface: const Color(0xFF1E2145),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          ),
        );
        if (dateRange != null) {
          onChanged(dateRange.start, dateRange.end);
        }
      },
      icon: const Icon(Icons.calendar_month, size: 18),
      label: Text(
        '${Formatters.date(inicio)} - ${Formatters.date(fim)}',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

class MiniKpi extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const MiniKpi({super.key, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: color)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

Widget infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget receiptRow(String label, String value, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isBold ? Colors.black : Colors.black87, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(color: isBold ? Colors.black : Colors.black87, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    ),
  );
}
