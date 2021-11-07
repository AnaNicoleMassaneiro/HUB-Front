import 'dart:convert';

import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiReservations {
  Future<http.Response> create(
      int idCliente, int idProduto, int quantidade, double lat, double lon
      ) async {

    return http.post(
      Uri.parse(reservaCreateEndpoints.createReservation),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "idCliente": idCliente,
        "idProduto": idProduto,
        "quantidadeDesejada": quantidade,
        "latitude": lat,
        "longitude": lon
      }),
    );
  }
}
