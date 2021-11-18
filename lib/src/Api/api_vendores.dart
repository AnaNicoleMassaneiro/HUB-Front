import 'dart:convert';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiVendedores {
  Future<List<Map<String, dynamic>>> searchAll() async {
    final response = await http.get(Uri.parse(ReservaCreateEndpoints.buscarTodosVendedores));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["vendedores"]);
    } else {
      throw Exception('Failed to create MeusProdutos.');
    }
  }
}
