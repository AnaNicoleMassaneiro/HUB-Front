import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hub/src/View/Class/vendedores.dart';
import 'package:hub/src/View/ViewCliente/detalhes_vendedor_page.dart';
import 'package:location/location.dart';
import '../../Api/api_location.dart';
import '../Class/user_data.dart';

class MapComponent extends StatefulWidget {
  const MapComponent({Key? key}) : super(key: key);

  @override
  _MapComponentState createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  late GoogleMapController _controller;
  late LocationData locationData;
  var location = Location();
  late LatLng _cameraPosition;
  late Future<LocationData> futureLocationData;
  late List<Vendedores> vendedores = <Vendedores>[];
  List<Marker> _markers = <Marker>[];

  Future<void> pegaVendedoresProximos(double lat, double lon) async {
    var api = ApiLocation();
    List<Marker> markers = <Marker>[];

    api.pegaVendedoresProximos(lat, lon).then((response) {
      if (response == null) {
        throw Exception("Houve um erro ao buscar vendedores próximos!");
      } else if (response.statusCode != 200) {
        throw Exception(
            "Houve um erro ao buscar vendedores próximos: " + response.body);
      } else {
        vendedores.clear();

        var listaJson = List<Map<String, dynamic>>.from(
            json.decode(response.body)["vendedores"]);

        for (var v in listaJson) {
          vendedores.add(Vendedores.fromJson(v));
        }

        for (var m in vendedores) {
          markers.add(Marker(
            markerId: MarkerId('Marker ' + m.id.toString()),
            position: LatLng(m.latitude!, m.longitude!),
            infoWindow: InfoWindow(
                title: m.name,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetalhesVendedorPage(idVendedor: m.id)))),
          ));
        }
      }

      if (mounted) {
        setState(() {
          _markers.clear();
          _markers = markers;
        });
      }
    });
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    pegaVendedoresProximos(userData.curLocationLat!, userData.curLocationLon!);
    _controller = controller;

    const secs = Duration(seconds: 30);
    Timer.periodic(secs, (Timer t2) async {
      if (mounted) {
        pegaVendedoresProximos(
            userData.curLocationLat!, userData.curLocationLon!);
      }
      else {
        t2.cancel();
      }
    });
  }

  void updateMapPosition(LatLng pos) {
    _controller.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 16));
  }

  @override
  void initState() {
    super.initState();

    futureLocationData = location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureLocationData,
      builder: (context, AsyncSnapshot<LocationData> snapshot) {
        if (snapshot.hasData) {
          locationData = snapshot.data!;
          _cameraPosition =
              LatLng(locationData.latitude!, locationData.longitude!);

          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                GoogleMap(
                  mapToolbarEnabled: false,
                  initialCameraPosition:
                      CameraPosition(target: _cameraPosition, zoom: 16),
                  mapType: MapType.normal,
                  onMapCreated: onMapCreated,
                  myLocationEnabled: true,
                  markers: Set<Marker>.of(_markers),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
