import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hub/src/SQLite/user_data_sqlite.dart';
import 'package:hub/src/View/Class/vendedores.dart';
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
  late LatLng _cameraPosition = const LatLng(-25.45648199644755, -49.23578677552287);
  late List<Vendedores> vendedores = <Vendedores>[];
  List<Marker> _markers = <Marker>[];

  Future<void> pegaVendedoresProximos(LocationData l) async {
    var api = ApiLocation();
    List<Marker> markers = <Marker>[];

    api
        .pegaVendedoresProximos(l.latitude, l.longitude)
        .then((response) {
      if (response == null) {
        throw Exception("Houve um erro ao buscar vendedores próximos!");
      } else if (response.statusCode != 200) {
        print("Houve um erro ao buscar vendedores próximos " + response.body);
      } else {
        var listaJson = List<Map<String, dynamic>>.from(json.decode(response.body)["vendedores"]);

        for (var v in listaJson){
          vendedores.add(Vendedores.fromJson(v));
        }

        for (var m in vendedores) {
          markers.add(Marker(
              markerId: MarkerId('Marker ' + m.id.toString()),
              position: LatLng(m.latitude!, m.longitude!),
              infoWindow: InfoWindow(title: m.name)
          ));
        }

        print("\t\t>>>Atualizando localização... Vendedores próximos");
      }

      if (mounted) {
        setState(() {
          _markers = markers;

          _cameraPosition = LatLng(
              l.latitude!,
              l.longitude!
          );
        });
      }
    });
  }

  void pegarLocalizacao(LocationData l) async {
    var api = ApiLocation();

    userData.curLocationLat = l.latitude;
    userData.curLocationLon = l.longitude;

    userDataSqlite.updateUserData(userData.toMap());
    api
        .updateCurrentLocation(
        l.latitude,
        l.longitude,
        userData.idUser!
    )
        .then((response) {
      if (response == null) {
        throw Exception("Houve um erro ao atualizar a localização!");
      } else if (response.statusCode != 200) {
        throw Exception(
            "Houve um erro ao atualizar a localização: " + response.body);
      } else {
        print("\t\t>>>Atualizando localização do usuário...");
      }
    }
    );

    if (mounted){
      setState(() {
        _cameraPosition = LatLng(
            l.latitude!,
            l.longitude!
        );

        updateMapPosition(_cameraPosition);
      });
    }
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    locationData = await location.getLocation();

    pegarLocalizacao(locationData);
    pegaVendedoresProximos(locationData);
    _controller = controller;

    location.onLocationChanged.listen((l) {
      if (mounted){
        locationData = l;
        pegarLocalizacao(l);
        pegaVendedoresProximos(l);
        updateMapPosition(LatLng(_cameraPosition.latitude, _cameraPosition.longitude));
      }
    });
  }

  void updateMapPosition(LatLng pos) {
    _controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(
          pos.latitude,
          pos.longitude
        ),
      16)
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _cameraPosition,
              zoom: 16
            ),
            mapType: MapType.normal,
            onMapCreated: onMapCreated,
            myLocationEnabled: true,
            markers: Set<Marker>.of(_markers),
          ),
        ],
      ),
    );
  }
}