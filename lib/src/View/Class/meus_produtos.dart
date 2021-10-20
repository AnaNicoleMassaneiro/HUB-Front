class MeusProdutos {
  late int id;
  late String nome;
  late bool? isAtivo;
  late double preco;
  late String descricao;
  late int quantidadeDisponivel;

  MeusProdutos(
      {required this.id,
      required this.nome,
      this.isAtivo,
      required this.preco,
      required this.descricao,
      required this.quantidadeDisponivel});

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
