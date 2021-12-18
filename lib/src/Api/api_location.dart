import 'dart:convert';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiLocation {
  Future<http.Response?> updateCurrentLocation(
      double? lat, double? lon, int idUser) async {
    if (lat != null && lon != null) {
      final uri = Endpoints.updateLocation + idUser.toString();
      final response = await http.patch(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': userData.token!
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
      const uri = Endpoints.buscaPorLocalizacao;

      final response = await http.post(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': userData.token!
          },
          body:
              jsonEncode(<String, double>{'latitude': lat, 'longitude': lon}));

      return response;
    }
    return null;
  }
}
