import 'dart:convert';

import 'package:flutter/material.dart';
import '../Class/meus_produtos.dart';

class DetalhesProdutoPage extends StatefulWidget {
  DetalhesProdutoPage({Key? key, required this.listaProdutos})
      : super(key: key);

  MeusProdutos listaProdutos;

  @override
  _DetalhesProdutoPageState createState() => _DetalhesProdutoPageState();
}

class _DetalhesProdutoPageState extends State<DetalhesProdutoPage> {
  late final String texto;
  TextEditingController controller = TextEditingController();
  List<Color> colors = [Colors.blue, Colors.green, Colors.yellow, Colors.pink];
  List<String> imagePath = [
    "images/shoe_blue.png",
    "images/shoe_green.png",
    "images/shoe_yellow.png",
    "images/shoe_pink.png"
  ];
  var selectedColor = Colors.blue;
  var isFavourite = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Detalhes do Produto'),
            backgroundColor: Colors.orange),
        body: SafeArea(
          child: Column(
            children: [
              header(),
            ],
          ),
        ));
  }

  Widget header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Text("Produto",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              Text(widget.listaProdutos.nome.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24)),
              const Text("Preço",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              Text(widget.listaProdutos.preco.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24)),
              const Text("Quantidade",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              Text(widget.listaProdutos.quantidadeDisponivel.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24)),
              const Text("Descrição",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              Text(widget.listaProdutos.descricao.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24)),
              ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    child: const Text(
                      "Avaliar",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )),
              ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    child: const Text(
                      "Reservar Produto",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
