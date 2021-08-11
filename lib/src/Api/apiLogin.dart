import 'dart:convert';

import 'package:http/http.dart' as http;

class apiLogin {
  Future<http.Response> login(String usuario, String senha) async {
    return http.post(
      Uri.parse('http://192.168.100.62:5000/api/User/authenticate'),
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
