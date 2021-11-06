import 'dart:typed_data';
import 'dart:convert';

class MeusProdutos {
  late int id;
  late String nome;
  late bool? isAtivo;
  late double preco;
  late double? nota = 0;
  late String descricao;
  late int quantidadeDisponivel;
  late Uint8List? imagem;

  MeusProdutos(
      {required this.id,
      required this.nome,
      this.isAtivo,
      required this.preco,
      this.nota,
      required this.descricao,
      required this.quantidadeDisponivel,
      this.imagem});

  factory MeusProdutos.fromJson(Map<String, dynamic> produto) {
    return MeusProdutos(
        id: produto["id"],
        nome: produto["nome"],
        descricao: produto["descricao"],
        isAtivo: produto["isAtivo"],
        nota: double.parse(produto['notaProduto'].toString()),
        preco: double.parse(produto["preco"].toString()),
        quantidadeDisponivel: produto["quantidadeDisponivel"],
        imagem: produto["imagem"] == null ?
        null :
        base64.decode(produto["imagem"])
    );
  }
}
