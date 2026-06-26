class Validators {
  Validators._();

  static String? required(String? value, {String field = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field é obrigatório';
    }
    return null;
  }

  static String? minLength(String? value, int min, {String field = 'Campo'}) {
    if (value == null || value.length < min) {
      return '$field deve ter no mínimo $min caracteres';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? cpf(String? value) {
    if (value == null || value.isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length != 11) return 'CPF inválido';
    return null;
  }

  static String? cnpj(String? value) {
    if (value == null || value.isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.length != 14) return 'CNPJ inválido';
    return null;
  }

  static String? positiveNumber(String? value, {String field = 'Valor'}) {
    if (value == null || value.isEmpty) return '$field é obrigatório';
    final number = double.tryParse(value.replaceAll(',', '.'));
    if (number == null || number < 0) {
      return '$field deve ser um número positivo';
    }
    return null;
  }

  static String? price(String? value, {String field = 'Preço'}) {
    if (value == null || value.isEmpty) return '$field é obrigatório';
    final number = double.tryParse(value.replaceAll(',', '.'));
    if (number == null || number <= 0) {
      return '$field deve ser maior que zero';
    }
    return null;
  }

  static String? ipAddress(String? value) {
    if (value == null || value.isEmpty) return 'IP é obrigatório';
    if (value == 'localhost') return null;
    final regex = RegExp(
        r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$');
    if (!regex.hasMatch(value)) {
      return 'Endereço IP inválido';
    }
    return null;
  }

  static String? port(String? value) {
    if (value == null || value.isEmpty) return 'Porta é obrigatória';
    final port = int.tryParse(value);
    if (port == null || port < 1 || port > 65535) {
      return 'Porta inválida (1-65535)';
    }
    return null;
  }
}
