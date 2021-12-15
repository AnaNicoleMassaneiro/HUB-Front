class ReportHeader {
  late int totalReservas;
  late int quantidadeItens;
  late double ticketMedio;
  late double valorTotal;

  ReportHeader(
      {required this.totalReservas,
      required this.quantidadeItens,
      required this.ticketMedio,
      required this.valorTotal});

  factory ReportHeader.fromJson(Map<String, dynamic> json) {
    return ReportHeader(
      totalReservas: json['totalReservas'],
      valorTotal: double.parse(json['valorTotal'].toString()),
      quantidadeItens: json['quantidadeItens'],
      ticketMedio: double.parse(json['ticketMedio'].toString()),
    );
  }
}