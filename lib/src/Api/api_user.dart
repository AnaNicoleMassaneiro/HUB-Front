import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hub/src/util/endpoints.dart';

class ApiUser {
  Future<Map<String, dynamic>> searchId(int? id) async {
    final response =
        await http.get(Uri.parse(Endpoints.buscarUserPorId + id.toString()));

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body)["user"]);
    } else {
      throw Exception('Falha ao buscar o usuário X-X.');
    }
  }

  Future<http.Response> updateUserName(int? id, String name) async {
    return await http.patch(Uri.parse(
        Endpoints.updateUserName + name.toString() + '/' + id.toString()));
  }

  Future<http.Response> updatePassword(int? id, String senha, confSenha) async {
    return await http.patch(
      Uri.parse(Endpoints.atualizarSenha + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "newPassword": senha,
        "confirmNewPassword": confSenha
      }),
    );
  }
}
