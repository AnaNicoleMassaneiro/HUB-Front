import 'dart:convert';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class api_search_produto {
  Future<http.Response> search(
      int? idVendedor, int? idProduto, String? nome) async {
    return http.post(
      Uri.parse(Endpoints.searchProduto),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "idProduto": idProduto,
        "nome": nome,
        "idVendedor": idVendedor
      }),
    );
  }
}
