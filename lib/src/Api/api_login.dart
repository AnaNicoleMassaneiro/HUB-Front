import 'dart:convert';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class apiLogin {
  Future<http.Response> login(String usuario, String senha) async {
    final response = await http.post(Uri.parse(reservaCreateEndpoints.autenticate),
        headers: <String, String>{
          'Content-Type': "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, String>{'usuario': usuario, 'senha': senha}));

    return response;
  }
}
