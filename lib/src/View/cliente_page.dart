import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ClientePage extends StatefulWidget {
  const ClientePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ClientePageState createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  late GoogleMapController _controller;
  final Location _location = Location();
  final LatLng _initialcameraposition = const LatLng(-25.4340196, -49.2588484);
  var location = Location();
  late Map<String, double> userLocation;
  late LocationData minhaLocalizacao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ENTRAMOS NO CIENTE')),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      pegarLocalizacao();

      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(minhaLocalizacao.latitude ?? -25.4340196,
                  minhaLocalizacao.longitude ?? -49.2588484),
              zoom: 15),
        ),
      );
    });
  }

  void pegarLocalizacao() async {
    setState(() async {
      minhaLocalizacao = await location.getLocation();
    });
  }
}
