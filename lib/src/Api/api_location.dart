import 'dart:convert';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiLocation {
  Future<http.Response?> updateCurrentLocation(
      double? lat, double? lon, int idUser) async {
    if (lat != null && lon != null) {
      final uri = ReservaCreateEndpoints.updateLocation + idUser.toString();
      final response = await http.patch(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': "application/json; charset=UTF-8",
          },
          body:
              jsonEncode(<String, double>{'latitude': lat, 'longitude': lon}));

      return response;
    }
    return null;
  }

  Future<http.Response?> pegaVendedoresProximos(
      double? lat, double? lon) async {
    if (lat != null && lon != null) {
      const uri = ReservaCreateEndpoints.buscaPorLocalizacao;

      final response = await http.post(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': "application/json; charset=UTF-8",
          },
          body:
              jsonEncode(<String, double>{'latitude': lat, 'longitude': lon}));

      return response;
    }
    return null;
  }
}
