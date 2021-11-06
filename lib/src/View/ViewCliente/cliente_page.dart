import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../Components/mapa.dart';
import 'buscar_page.dart';
import 'minhas_reservas_page.dart';
import '../Class/user_data.dart';

class ClientePage extends StatefulWidget {
  ClientePage(
      {Key? key, required this.title})
      : super(key: key);

  final String title;
  final int idCliente = userData.idCliente!;
  final int idUser = userData.idUser!;

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
      const BuscarPage(),
      const MinhasReservasPage()
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
                icon: Icon(Icons.person), label: "Localização"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Buscar"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Minhas Reservas")
          ],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}
