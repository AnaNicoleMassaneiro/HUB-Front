import 'dart:convert';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiRating {
  Future<http.Response> insertRating(
    int idProduto, int idCliente, int idVendedor, int nota,
    String titulo, String descricao, int tipoAvaliacao
  ) async {
    final response = await http.post(Uri.parse(Endpoints.insertRating),
      headers: <String, String>{
        'Content-Type': "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        "idProduto": idProduto,
        "idCliente": idCliente,
        "idVendedor": idVendedor,
        "nota": nota,
        "titulo": titulo,
        "descricao": descricao,
        "tipoAvaliacao": tipoAvaliacao
      })
    );

    return response;
  }
}