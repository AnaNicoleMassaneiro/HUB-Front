import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'lista_produtos_page.dart';
import 'lista_vendedores_page.dart';

class BuscarPage extends StatefulWidget {
  const BuscarPage({Key? key}) : super(key: key);

  @override
  _BuscarPageState createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  @override
  void initState() {
    super.initState();

    buscaVendedores();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
          onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListaProdutosPage())),
              },
          child: Card(
              child: Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/produto.jpeg"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Buscar Produtos'),
            ),
          ))),
      GestureDetector(
          onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ListaVendedoresPage())),
              },
          child: Card(
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('images/produto.jpeg'))),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Buscar Vendedores'),
              ),
            ),
          ))
    ]);
  }

  void buscaVendedores() {}
}
