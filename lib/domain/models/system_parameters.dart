class SystemParameters {
  final double comissaoPadrao;
  final double ticketMedioAlvo;

  SystemParameters({
    required this.comissaoPadrao,
    required this.ticketMedioAlvo,
  });

  factory SystemParameters.fromJson(Map<String, dynamic> json) => SystemParameters(
        comissaoPadrao: (json['comissao_padrao'] ?? 0.0).toDouble(),
        ticketMedioAlvo: (json['ticket_medio_alvo'] ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'comissao_padrao': comissaoPadrao,
        'ticket_medio_alvo': ticketMedioAlvo,
      };

  SystemParameters copyWith({
    double? comissaoPadrao,
    double? ticketMedioAlvo,
  }) =>
      SystemParameters(
        comissaoPadrao: comissaoPadrao ?? this.comissaoPadrao,
        ticketMedioAlvo: ticketMedioAlvo ?? this.ticketMedioAlvo,
      );
}
