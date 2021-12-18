import 'dart:convert';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiRating {
  Future<http.Response> insertRating(
      int idProduto,
      int idCliente,
      int idVendedor,
      int nota,
      String titulo,
      String descricao,
      int tipoAvaliacao) async {
    final response = await http.post(Uri.parse(Endpoints.insertRating),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userData.token!,
        },
        body: jsonEncode(<String, dynamic>{
          "idProduto": idProduto,
          "idCliente": idCliente,
          "idVendedor": idVendedor,
          "nota": nota,
          "titulo": titulo,
          "descricao": descricao,
          "tipoAvaliacao": tipoAvaliacao
        }));

    return response;
  }

  Future<List<Map<String, dynamic>>> getProductRatings(int idProduct) async {
    final response = await http.get(
      Uri.parse(Endpoints.getProductRatings + idProduct.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userData.token!,
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["avaliacoes"]);
    } else {
      return <Map<String, dynamic>>[];
    }
  }

  Future<List<Map<String, dynamic>>> getSellerRatings(int idVendedor) async {
    final response = await http.get(
      Uri.parse(Endpoints.getSellerRatings + idVendedor.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userData.token!,
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["avaliacoes"]);
    } else if (response.statusCode == 404) {
      return <Map<String, dynamic>>[];
    } else {
      throw Exception('Failed to get product avaliations.');
    }
  }
}
