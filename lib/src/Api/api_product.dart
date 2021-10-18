import 'dart:convert';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class api_product {
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

  Future<http.Response> register(int? idVendedor, double? preco, String? nome,
      String descricao, int qtdDisponivel) async {
    return await http.post(
      Uri.parse(Endpoints.registerProduct),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "nome": nome,
        "status": true,
        "preco": preco,
        "descricao": descricao,
        "quantidadeDisponivel": qtdDisponivel,
        "idVendedor": idVendedor
      }),
    );
  }
}
