String formatDocumento(String tipoPessoa, String? raw) {
  if (raw == null || raw.isEmpty) return '-';
  final v = raw.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
  if (tipoPessoa == 'F') {
    if (v.length != 11) return raw;
    return '${v.substring(0, 3)}.${v.substring(3, 6)}.${v.substring(6, 9)}-${v.substring(9)}';
  } else {
    if (v.length != 14) return raw;
    return '${v.substring(0, 2)}.${v.substring(2, 5)}.${v.substring(5, 8)}/${v.substring(8, 12)}-${v.substring(12)}';
  }
}
