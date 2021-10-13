import 'package:flutter/material.dart';
import 'Components/mapa.dart';
import 'meus_produtos_page.dart';

class VendedorPage extends StatefulWidget {
  const VendedorPage({Key? key, required this.title}) : super(key: key);
  final String title;

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
      mapaComponent(this.context),
      MeusProdutosPage(),
      MeusProdutosPage(),
    ];

    return Scaffold(
        appBar: AppBar(title: const Text('Bem Vindo')),
        body: _telas[_indiceAtual],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: onTabTapped,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("localizacao")),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Meus Produtos")),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Null"))
          ],
        ));
  }

  void onTabTapped(int index) {
    print(index);
    setState(() {
      _indiceAtual = index;
    });
  }
}
