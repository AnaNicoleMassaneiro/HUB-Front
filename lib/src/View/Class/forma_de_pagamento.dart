class FormaDePagamento {
  late int id;
  late String descricao;
  late String icone;

  FormaDePagamento({
    required this.id,
    required this.descricao,
    required this.icone
  });

  factory FormaDePagamento.fromJson(Map<String, dynamic> payment) {

    return FormaDePagamento(
      id: payment["idFormaPagamento"],
      descricao: payment["descricao"],
      icone: payment["icone"]
    );
  }
}
