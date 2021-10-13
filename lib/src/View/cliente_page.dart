import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'Components/mapa.dart';

class ClientePage extends StatefulWidget {
  const ClientePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ClientePageState createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  var location = Location();
  late Map<String, double> userLocation;
  late LocationData minhaLocalizacao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ENTRAMOS NO CIENTE')),
      body:  mapaComponent(this.context),
    );
  }
}
