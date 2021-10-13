import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  var location = Location();
  late Map<String, double> userLocation;
  late LocationData minhaLocalizacao;
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _telas = [
      mapaComponent(this.context),
      MeusProdutosPage("Minha conta"),
      MeusProdutosPage("Meus pedidos"),
    ];

    return Scaffold(
        appBar: AppBar(title: const Text('Bem Vindo')),
        body: _telas[_indiceAtual],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: onTabTapped,
          items: [
            bottomNavigationBar(Icons.shopping_basket, Text("localizacao")),
            bottomNavigationBar(Icons.shopping_basket, Text("localizacao")),
            bottomNavigationBar(Icons.favorite, Text("localizacao"))
          ],
        ));
  }

  BottomNavigationBarItem bottomNavigationBar(IconData icon, Text text) {
    return const BottomNavigationBarItem(
        icon: Icon(Icons.person), title: Text("localizacao"));
  }

  void onTabTapped(int index) {
    print(index);
    setState(() {
      _indiceAtual = index;
    });
  }
}
