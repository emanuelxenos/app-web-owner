import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/presentation/providers/finance_provider.dart';

class DateFilterButton extends ConsumerWidget {
  final ({DateTime? start, DateTime? end}) filters;
  const DateFilterButton({super.key, required this.filters});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = filters.start == null
        ? 'Filtrar por Período'
        : '${Formatters.date(filters.start!)} - ${Formatters.date(filters.end!)}';

    return OutlinedButton.icon(
      onPressed: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          initialDateRange: filters.start != null
              ? DateTimeRange(start: filters.start!, end: filters.end!)
              : null,
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppTheme.primaryColor,
                surface: const Color(0xFF1C2039),
              ),
            ),
            child: child!,
          ),
        );
        if (range != null) {
          ref
              .read(financialFiltersProvider.notifier)
              .setRange(range.start, range.end);
        }
      },
      icon: const Icon(Icons.date_range_rounded),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white70,
        side: const BorderSide(color: Colors.white24),
      ),
    );
  }
}
