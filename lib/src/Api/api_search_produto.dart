import 'dart:convert';
import 'package:hub/src/View/Class/meus_produtos.dart';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class api_search_produto {
  Future<List<Map<String, dynamic>>> search(
      int? idVendedor, int? idProduto, String? nome) async {
    final response = await http.post(
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

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["produtos"]);
    } else {
      throw Exception('Failed to create MeusProdutos.');
    }
  }
}
