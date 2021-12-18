import 'dart:convert';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

class ApiVendedores {
  Future<List<Map<String, dynamic>>> searchAll() async {
    final response = await http.get(Uri.parse(Endpoints.buscarTodosVendedores),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userData.token!,
        });

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["vendedores"]);
    } else {
      throw Exception('Erro ao buscar vendedores!');
    }
  }

  Future<Map<String, dynamic>> searchById(int idVendedor) async {
    final response = await http.get(
        Uri.parse(Endpoints.buscarVendedorPorId + idVendedor.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userData.token!,
        });

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body)["vendedor"]);
    } else {
      throw Exception('Erro ao buscar vendedor!');
    }
  }

  Future<List<Map<String, dynamic>>> getFormasDePagamentoBySeller(
      int idVendedor) async {
    final response = await http.get(
        Uri.parse(Endpoints.getPaymentModesBySeller + idVendedor.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userData.token!,
        });

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["formasDePagamento"]);
    } else if (response.statusCode == 404) {
      return <Map<String, dynamic>>[];
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<Map<String, dynamic>>> listFormasDePagamento() async {
    final response = await http
        .get(Uri.parse(Endpoints.listPaymentModes), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userData.token!,
    });

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["formasDePagamento"]);
    } else if (response.statusCode == 404) {
      return <Map<String, dynamic>>[];
    } else {
      throw Exception(response.body);
    }
  }

  Future<http.Response> addFormaPagamento(
      int idFormaPagamento, int idVendedor) async {
    final response = await http.post(Uri.parse(Endpoints.addPaymentModes),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userData.token!,
        },
        body: jsonEncode(<String, dynamic>{
          'idFormaDePagamento': idFormaPagamento,
          'idVendedor': idVendedor
        }));

    return response;
  }

  Future<http.Response> removeFormaPagamento(
      int idFormaPagamento, int idVendedor) async {
    final response = await http.delete(Uri.parse(Endpoints.removePaymentModes),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userData.token!,
        },
        body: jsonEncode(<String, dynamic>{
          'idFormaDePagamento': idFormaPagamento,
          'idVendedor': idVendedor
        }));

    return response;
  }

  Future<http.Response> addToFavorites(int idVendedor, int idCliente) async {
    return await http.post(
      Uri.parse(Endpoints.addToFavorites),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userData.token!,
      },
      body: jsonEncode(
          <String, dynamic>{"idCliente": idCliente, "idVendedor": idVendedor}),
    );
  }

  Future<bool> isFavorite(int idCliente, int idVendedor) async {
    var response = await http.post(
      Uri.parse(Endpoints.isFavorite),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userData.token!,
      },
      body: jsonEncode(
          <String, dynamic>{"idCliente": idCliente, "idVendedor": idVendedor}),
    );

    return jsonDecode(response.body)["isFavorite"];
  }

  Future<http.Response> removeFromFavorites(
      int idVendedor, int idCliente) async {
    return await http.delete(
      Uri.parse(Endpoints.removeFromFavorites),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userData.token!,
      },
      body: jsonEncode(
          <String, dynamic>{"idCliente": idCliente, "idVendedor": idVendedor}),
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites(int idCliente) async {
    final response = await http.get(
        Uri.parse(Endpoints.getFavorites + idCliente.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': userData.token!,
        });

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["favoritos"]);
    } else if (response.statusCode == 404) {
      return <Map<String, dynamic>>[];
    } else {
      throw Exception(response.body);
    }
  }

  Future<http.Response> updateSellerStatus(
      int idVendedor, bool isAtivo, bool isOpen) async {
    return await http.patch(
      Uri.parse(Endpoints.atualizarStatusVendedor),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userData.token!,
      },
      body: jsonEncode(<String, dynamic>{
        "idVendedor": idVendedor,
        "isOpen": isOpen,
        "isAtivo": isAtivo
      }),
    );
  }
}
