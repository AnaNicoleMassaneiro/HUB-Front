import 'dart:convert';

import 'package:flutter_login_signup/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class apiLogin {
  Future<http.Response> login(String usuario, String senha) async {
    return http.post(
      Uri.parse(Endpoints.autenticate),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'usuario': usuario,
        'senha': senha
      }),
    );
  }
}
