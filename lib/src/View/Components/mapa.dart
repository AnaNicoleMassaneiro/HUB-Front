import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hub/src/SQLite/user_data_sqlite.dart';
import 'package:location/location.dart';
import '../../Api/api_location.dart';
import '../Class/user_data.dart';

Widget mapaComponent(BuildContext context, int idUser) {
  late GoogleMapController _controller;
  final Location _location = Location();
  const LatLng _initialcameraposition = LatLng(-25.4340196, -49.2588484);
  var location = Location();
  late LocationData minhaLocalizacao;

  Future<void> pegaVendedoresProximos() async {
    var api = ApiLocation();
    minhaLocalizacao = await location.getLocation();  

    api
        .pegaVendedoresProximos(minhaLocalizacao.latitude ?? -25.4340196,
            minhaLocalizacao.longitude ?? -49.2588484)
        .then((response) {
      if (response == null) {
        throw Exception("Houve um erro ao atualizar a localização!");
      } else if (response.statusCode != 200) {
        print("Houve um erro ao atualizar a localização: " + response.body);
      } else {
        print("\t\t>>>Atualizando localização...");
      }
    });
  }

  void pegarLocalizacao() async {
    var api = ApiLocation();
    minhaLocalizacao = await location.getLocation();

    userData.curLocationLat = minhaLocalizacao.latitude;
    userData.curLocationLon = minhaLocalizacao.longitude;

    userDataSqlite.updateUserData(userData.toMap());

    api.updateCurrentLocation(
        minhaLocalizacao.latitude, minhaLocalizacao.longitude, idUser)
    .then((response) {
      if (response == null){
        throw Exception("Houve um erro ao atualizar a localização!");
      } else if (response.statusCode != 200) {
        throw Exception(
            "Houve um erro ao atualizar a localização: " + response.body);
      } else {
        print("\t\t>>>Atualizando localização...");
      }
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      print(l);
      pegarLocalizacao();
      pegaVendedoresProximos();

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

  return SizedBox(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Stack(
      children: [
        GoogleMap(
          initialCameraPosition:
              const CameraPosition(target: _initialcameraposition),
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
        ),
      ],
    ),
  );
}
