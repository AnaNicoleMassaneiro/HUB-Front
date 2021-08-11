import 'dart:convert';

import 'package:http/http.dart' as http;

class apiRegister {
  Future<http.Response> create(String name, String user, String senha, String confirmSenha, String grr, String email) async {
    return http.post(
      Uri.parse('http://192.168.100.62:5000/api/User/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "nome": name,
        "usuario": user,
        "senha": senha,
        "confirmacaoSenha": confirmSenha,
        "grr": grr,
        "email": email
      }),
    );
  }
}
