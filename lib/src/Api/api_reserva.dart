import 'dart:convert';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class apiReservar {
  Future<http.Response> create(
      idCliente, idProduto, quantidadeDesejada, latitude, longitude) async {
    final response = await http.post(Uri.parse(reservaCreateEndpoints.reservaCreate),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, dynamic>{
          "idCliente": idCliente,
          "idProduto": idProduto,
          "quantidadeDesejada": quantidadeDesejada,
          "latitude": latitude,
          "longitude": longitude
        }));

    return response;
  }
}
