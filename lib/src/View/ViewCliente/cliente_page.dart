import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../Components/mapa.dart';
import 'buscar_page.dart';

class ClientePage extends StatefulWidget {
  const ClientePage(
      {Key? key, required this.title, required this.idCliente, required this.idUser})
      : super(key: key);
  final String title;
  final int idCliente;
  final int idUser;

  @override
  _ClientePageState createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  var location = Location();
  late Map<String, double> userLocation;
  late LocationData minhaLocalizacao;
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _telas = [
      mapaComponent(this.context, widget.idUser),
      const BuscarPage()
    ];

    return Scaffold(
        appBar: AppBar(
            title: const Text('Área do cliente'),
            backgroundColor: Colors.orange),
        body: _telas[_indiceAtual],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: onTabTapped,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "localizacao"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Buscar"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "null")
          ],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}
