import 'dart:typed_data';
import 'dart:convert';

class MeusProdutos {
  late int id;
  late String nome;
  late bool? isAtivo;
  late double preco;
  late String descricao;
  late int quantidadeDisponivel;
  late Uint8List? imagem;

  MeusProdutos(
      {required this.id,
      required this.nome,
      this.isAtivo,
      required this.preco,
      required this.descricao,
      required this.quantidadeDisponivel,
      this.imagem});

  factory MeusProdutos.fromJson(Map<String, dynamic> json) {
    return MeusProdutos(
      id: json['id'],
      nome: json['nome'],
      isAtivo: json['isAtivo'],
      preco: json['preco'],
      descricao: json['descricao'],
      quantidadeDisponivel: json['quantidadeDisponivel'],
      imagem: base64Decode(json['imagem'])
    );
  }
}
