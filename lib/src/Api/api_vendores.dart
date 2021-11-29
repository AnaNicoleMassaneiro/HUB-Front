import 'dart:convert';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiVendedores {
  Future<List<Map<String, dynamic>>> searchAll() async {
    final response = await http.get(Uri.parse(Endpoints.buscarTodosVendedores));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["vendedores"]);
    } else {
      throw Exception('Failed to create MeusProdutos.');
    }
  }

  Future<List<Map<String, dynamic>>> getFormasDePagamentoBySeller(int idVendedor) async {
    final response = await http.get(Uri.parse(
      Endpoints.getPaymentModesBySeller + idVendedor.toString())
    );

    if (response.statusCode == 200){
      return List<Map<String, dynamic>>.from(
        json.decode(response.body)["formasDePagamento"]
      );
    }
    else if (response.statusCode == 404){
      return <Map<String, dynamic>>[];
    }
    else {
      throw Exception(response.body);
    }

  }
}
