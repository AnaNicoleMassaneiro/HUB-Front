import 'dart:convert';

import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class apiRegister {
  Future<http.Response> create(String name, bool isChecked, String senha,
      String confirmSenha, String grr, String email) async {
    return http.post(
      Uri.parse(Endpoints.create),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "nome": name,
        "isVendedor": isChecked,
        "senha": senha,
        "confirmacaoSenha": confirmSenha,
        "grr": grr,
        "email": email
      }),
    );
  }
}
