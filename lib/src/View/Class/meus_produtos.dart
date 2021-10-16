class MeusProdutos {
  late String? id;
  late String nome;
  late bool? isAtivo;
  late int? preco;
  late String? descricao;
  late int? quantidadeDisponivel;

  MeusProdutos(
      {this.id,
      required this.nome,
      this.isAtivo,
      this.preco,
      this.descricao,
      this.quantidadeDisponivel});

  factory MeusProdutos.fromJson(Map<String, dynamic> json) {
    return MeusProdutos(
      id: json['id'],
      nome: json['nome'],
      isAtivo: json['isAtivo'],
      preco: json['preco'],
      descricao: json['descricao'],
      quantidadeDisponivel: json['quantidadeDisponivel'],
    );
  }
}
