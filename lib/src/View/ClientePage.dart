import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Widget/bezierContainer.dart';

class ClientePage extends StatefulWidget {
  ClientePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ClientePageState createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  int _indiceAtual = 0;
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);

  Position _currentPosition;

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Voltar',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'CLIENTE',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(title: const Text('ENTRAMOS NO CIENTE')),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("localizacao")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket), title: Text("Meus pedidos")),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), title: Text("Favoritos")),
          ],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

}

