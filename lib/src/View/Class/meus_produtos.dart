import 'dart:ffi';

class MeusProdutos {
  late String? id;
  late String nome;
  late bool? isAtivo;
  late Float? preco;
  late String? descricao;
  late int? quantidadeDisponivel;

  MeusProdutos(
      {this.id,
      required this.nome,
      this.isAtivo,
      this.preco,
      this.descricao,
      this.quantidadeDisponivel});
}
