import 'package:flutter/material.dart';
import 'Components/mapa.dart';
import 'ViewProduto/cadastrar_produto_page.dart';
import 'ViewProduto/meus_produtos_page.dart';

class VendedorPage extends StatefulWidget {
  const VendedorPage(
      {Key? key, required this.title, required this.idVendedor, required this.idUser})
      : super(key: key);
  final String title;
  final int idVendedor;
  final int idUser;

  @override
  _VendedorPageState createState() => _VendedorPageState();
}

class _VendedorPageState extends State<VendedorPage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  late Map<String, double> userLocation;
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _telas = [
      mapaComponent(this.context, widget.idUser),
      MeusProdutosPage(
        idVendedor: widget.idVendedor,
        idUser: widget.idUser
      ),
      MeusProdutosPage(
        idVendedor: widget.idVendedor,
        idUser: widget.idUser
      ),
    ];

    return Scaffold(
        appBar: AppBar(
            title: const Text('Área do vendedor'),
            backgroundColor: Colors.orange),
        body: _telas[_indiceAtual],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CadastrarProdutoPage(
                        title: '',
                        idVendedor: widget.idVendedor,
                        idUser: widget.idUser)));
          },
          child: const Icon(Icons.plus_one),
          backgroundColor: Colors.blue,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: onTabTapped,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Localização"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Meus Produtos"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Null")
          ],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}
