import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

Widget mapaComponent(BuildContext context) {
  late GoogleMapController _controller;
  final Location _location = Location();
  const LatLng _initialcameraposition = const LatLng(-25.4340196, -49.2588484);
  var location = Location();
  late LocationData minhaLocalizacao;

/*   void pegarLocalizacao() async {
    minhaLocalizacao = await location.getLocation();
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

 */  return SizedBox(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Stack(
     /*  children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: _initialcameraposition),
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
        ),
      ], */
    ),
  );
}
