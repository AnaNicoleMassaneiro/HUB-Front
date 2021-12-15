class ReportBody {
  late int quantidadeReservas;
  late int quantidadeItens;
  late double valorTotal;
  late String produto;

  ReportBody(
      {required this.quantidadeReservas,
        required this.quantidadeItens,
        required this.valorTotal,
        required this.produto});

  factory ReportBody.fromJson(Map<String, dynamic> json) {
    return ReportBody(
      quantidadeReservas: json['quantidadeReservas'],
      produto: json['produto'],
      quantidadeItens: json['quantidadeItens'],
      valorTotal: double.parse(json['valorTotal'].toString()),
    );
  }
}