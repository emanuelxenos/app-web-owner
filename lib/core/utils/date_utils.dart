import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static DateTime get today => DateTime.now();

  static DateTime get startOfDay =>
      DateTime(today.year, today.month, today.day);

  static DateTime get endOfDay =>
      DateTime(today.year, today.month, today.day, 23, 59, 59);

  static DateTime get startOfMonth =>
      DateTime(today.year, today.month, 1);

  static DateTime get endOfMonth =>
      DateTime(today.year, today.month + 1, 0, 23, 59, 59);

  static DateTime get startOfYear =>
      DateTime(today.year, 1, 1);

  static DateTime daysAgo(int days) =>
      today.subtract(Duration(days: days));

  static String formatRange(DateTime start, DateTime end) {
    final df = DateFormat('dd/MM/yyyy');
    return '${df.format(start)} - ${df.format(end)}';
  }

  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Agora';
    if (diff.inMinutes < 60) return 'Há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Há ${diff.inHours}h';
    if (diff.inDays == 1) return 'Ontem';
    if (diff.inDays < 7) return 'Há ${diff.inDays} dias';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String apiDate(DateTime dt) =>
      DateFormat('yyyy-MM-dd').format(dt);

  static DateTime? parseApiDate(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
}
