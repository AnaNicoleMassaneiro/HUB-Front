import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class VendedorPage extends StatefulWidget {
  const VendedorPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _VendedorPageState createState() => _VendedorPageState();
}

class _VendedorPageState extends State<VendedorPage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  late GoogleMapController _controller;
  final Location _location = Location();
  final LatLng _initialcameraposition = const LatLng(-25.4340196, -49.2588484);
  var location = Location();
  late Map<String, double> userLocation;
  late LocationData minhaLocalizacao;
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Bem Vindo')),
        body: SizedBox(
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("localizacao")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket),
                title: Text("Meus produtos")),
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
