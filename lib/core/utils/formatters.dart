import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static final _numberFormat = NumberFormat.decimalPattern('pt_BR');
  static final _dateFormat = DateFormat('dd/MM/yyyy');
  static final _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final _timeFormat = DateFormat('HH:mm');
  static final _dateApiFormat = DateFormat('yyyy-MM-dd');

  static String currency(num value) => _currencyFormat.format(value);

  static String compactCurrency(num value) {
    return NumberFormat.compactCurrency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 1,
    ).format(value);
  }

  static String number(num value, {int decimals = 2}) {
    return value.toStringAsFixed(decimals).replaceAll('.', ',');
  }

  static String quantity(num value) {
    final doubleValue = value.toDouble();
    if (doubleValue == doubleValue.truncateToDouble()) {
      return doubleValue.toInt().toString();
    }
    return _numberFormat.format(doubleValue);
  }

  static String date(dynamic dt) {
    if (dt == null) return '-';
    if (dt is String) {
      try {
        final parsed = DateTime.parse(dt);
        return _dateFormat.format(parsed);
      } catch (_) {
        return dt;
      }
    }
    if (dt is DateTime) {
      return _dateFormat.format(dt);
    }
    return '-';
  }

  static String dateTime(DateTime? dt) {
    if (dt == null) return '-';
    return _dateTimeFormat.format(dt);
  }

  static String time(DateTime? dt) {
    if (dt == null) return '-';
    return _timeFormat.format(dt);
  }

  static String dateForApi(DateTime dt) => _dateApiFormat.format(dt);

  static String dateToIso(String ddMMyyyy) {
    try {
      final date = _dateFormat.parse(ddMMyyyy);
      return _dateApiFormat.format(date);
    } catch (_) {
      return ddMMyyyy;
    }
  }

  static DateTime? parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty || dateStr == '-') return null;
    try {
      return _dateFormat.parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  static String cpf(String? cpf) {
    if (cpf == null || cpf.length != 11) return cpf ?? '';
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  static String cnpj(String? cnpj) {
    if (cnpj == null || cnpj.length != 14) return cnpj ?? '';
    return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12)}';
  }

  static String phone(String? phone) {
    if (phone == null) return '';
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
    }
    if (digits.length == 10) {
      return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6)}';
    }
    return phone;
  }

  static String percentage(num value) => '${number(value)}%';

  static String statusVenda(String status) {
    switch (status.toLowerCase()) {
      case 'concluida':
        return 'Concluída';
      case 'cancelada':
        return 'Cancelada';
      case 'pendente':
        return 'Pendente';
      default:
        return status;
    }
  }

  static String statusConta(String status) {
    switch (status.toLowerCase()) {
      case 'aberta':
        return 'Aberta';
      case 'paga':
        return 'Paga';
      case 'recebida':
        return 'Recebida';
      case 'cancelada':
        return 'Cancelada';
      default:
        return status;
    }
  }

  static String statusCompra(String status) {
    switch (status.toLowerCase()) {
      case 'pendente':
        return 'Pendente';
      case 'recebida':
        return 'Recebida';
      case 'cancelada':
        return 'Cancelada';
      default:
        return status;
    }
  }
}
