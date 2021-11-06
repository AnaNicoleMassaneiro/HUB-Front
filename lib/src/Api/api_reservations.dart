import 'dart:convert';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiReservations {
  Future<http.Response> create(
      int idCliente, int idProduto, int quantidade, double lat, double lon
      ) async {

    return http.post(
      Uri.parse(Endpoints.createReservation),
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

  Future<List<Map<String, dynamic>>> getByCustomer(int id) async{
    final res = await http.get(
      Uri.parse(Endpoints.getReservationByCustomer + id.toString()),
    );

    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(res.body)["reservas"]);
    } else {
      throw Exception('Houve um erro ao buscar as Reservas!');
    }
  }

  Future<List<Map<String, dynamic>>> getBySeller(int id) async{
    final res = await http.get(
      Uri.parse(Endpoints.getReservationBySeller + id.toString()),
    );

    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(res.body)["reservas"]);
    } else {
      throw Exception('Houve um erro ao buscar as Reservas!');
    }
  }

  Future<http.Response> cancelReservation(int id) async{
    return await http.patch(
      Uri.parse(Endpoints.cancelReservation + id.toString())
    );
  }

  Future<http.Response> confirmReservation(int id) async{
    return await http.patch(
        Uri.parse(Endpoints.confirmReservation + id.toString())
    );
  }
}