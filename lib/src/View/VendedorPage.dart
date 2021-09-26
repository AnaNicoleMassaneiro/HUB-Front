import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Widget/bezierContainer.dart';

class VendedorPage extends StatefulWidget {
  VendedorPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _VendedorPageState createState() => _VendedorPageState();
}

class _VendedorPageState extends State<VendedorPage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  int _indiceAtual = 0;
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);

  Position _currentPosition;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(title: const Text('ENTRAMOS NO VENDEDOR')),
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

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        print(position);
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}

