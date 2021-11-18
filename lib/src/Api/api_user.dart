import 'dart:convert';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiUser {
  Future<Map<String, dynamic>> searchId(int? id) async {
    final response = await http
        .get(Uri.parse(reservaCreateEndpoints.buscarUserPorId + id.toString()));

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body)["user"]);
    } else {
      throw Exception('Failed to create MeusProdutos.');
    }
  }
}
