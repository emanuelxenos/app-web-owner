

class Backup {
  final int idBackup;
  final int empresaId;
  final String nomeArquivo;
  final String caminho;
  final int? tamanho;
  final DateTime dataBackup;
  final String tipo;
  final String status;
  final String? observacoes;
  final int? usuarioId;

  Backup({
    required this.idBackup,
    required this.empresaId,
    required this.nomeArquivo,
    required this.caminho,
    this.tamanho,
    required this.dataBackup,
    required this.tipo,
    required this.status,
    this.observacoes,
    this.usuarioId,
  });

  factory Backup.fromJson(Map<String, dynamic> json) {
    return Backup(
      idBackup: json['id_backup'],
      empresaId: json['empresa_id'],
      nomeArquivo: json['nome_arquivo'],
      caminho: json['caminho'],
      tamanho: json['tamanho'],
      dataBackup: DateTime.parse(json['data_backup']),
      tipo: json['tipo'] ?? 'automatico',
      status: json['status'] ?? 'sucesso',
      observacoes: json['observacoes'],
      usuarioId: json['usuario_id'],
    );
  }
}
