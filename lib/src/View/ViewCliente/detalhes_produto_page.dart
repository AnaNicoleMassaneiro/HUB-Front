import 'package:flutter/material.dart';
import '../Class/meus_produtos.dart';
import '../ViewReserva/create_reserva.dart';

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.listaProdutos.imagem == null ?
                Image.asset("assets/product-icon.png", height: 250, fit: BoxFit.contain) :
                Image.memory(widget.listaProdutos.imagem!, height: 250, fit: BoxFit.contain)
              ,
              const Text("Produto",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              Text(widget.listaProdutos.nome.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24)),
              const Text("Nota",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              Text(widget.listaProdutos.nota.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24)),
              const Text("Preço",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              Text('R\$ ' + widget.listaProdutos.preco.toString().replaceAll(".", ","),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24)),
              const Text("Quantidade disponível",
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          CreateReserva(produto: widget.listaProdutos)
                      ));
                  },
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
