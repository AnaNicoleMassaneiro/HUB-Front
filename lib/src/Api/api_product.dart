import 'dart:convert';
import 'dart:io';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class api_product {
  Future<List<Map<String, dynamic>>> searchAll() async {
    final response = await http
        .get(Uri.parse(Endpoints.searchProductAll), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': userData.token!
    });

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["produtos"]);
    } else if (response.statusCode == 404) {
      return <Map<String, dynamic>>[];
    } else {
      throw Exception('Houve um erro ao buscar todos os produtos.');
    }
  }

  Future<List<Map<String, dynamic>>> search(int? idVendedor) async {
    final response = await http.post(
      Uri.parse(Endpoints.searchProdutoPorVendedor),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userData.token!
      },
      body: jsonEncode(
          <String, dynamic>{"sellerId": idVendedor, "returnActiveOnly": false}),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["produtos"]);
    } else if (response.statusCode == 404) {
      return <Map<String, dynamic>>[];
    } else {
      throw Exception('Houve um erro ao buscar os produtos do vendedor.');
    }
  }

  Future<List<Map<String, dynamic>>> searchActiveOnly(int? idVendedor) async {
    final response = await http.post(
      Uri.parse(Endpoints.searchProdutoPorVendedor),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userData.token!
      },
      body: jsonEncode(
          <String, dynamic>{"sellerId": idVendedor, "returnActiveOnly": true}),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["produtos"]);
    } else if (response.statusCode == 404) {
      return <Map<String, dynamic>>[];
    } else {
      throw Exception('Houve um erro ao buscar os produtos do vendedor.');
    }
  }

  Future<http.StreamedResponse> register(int idVendedor, double preco,
      String nome, String descricao, int qtdDisponivel, File? image) async {
    var request = http.MultipartRequest(
        'Post', Uri.parse(Endpoints.registerProduct));

    request.fields['nome'] = nome;
    request.fields['isAtivo'] = "true";
    request.fields['preco'] = preco.toString();
    request.fields['descricao'] = descricao;
    request.fields['quantidadeDisponivel'] = qtdDisponivel.toString();
    request.fields['idVendedor'] = idVendedor.toString();

    request.headers['Authorization'] = userData.token!;
    request.headers['Content-Type'] = 'application/json; charset=UTF-8';

    if (image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('ProductImage', image.path));
    }

    return request.send();
  }

  Future<http.StreamedResponse> update(
      int idProduto,
      int idVendedor,
      double preco,
      String nome,
      String descricao,
      int qtdDisponivel,
      bool isAtivo,
      File? image,
      bool isKeepImage) async {
    var request = http.MultipartRequest(
        'Put', Uri.parse(Endpoints.updateProduct + idProduto.toString()));

    request.fields['nome'] = nome;
    request.fields['isAtivo'] = "true";
    request.fields['preco'] = preco.toString();
    request.fields['descricao'] = descricao;
    request.fields['quantidadeDisponivel'] = qtdDisponivel.toString();
    request.fields['isAtivo'] = isAtivo.toString();
    request.fields['isKeepImage'] = isKeepImage.toString();

    request.headers['Authorization'] = userData.token!;
    request.headers['Content-Type'] = 'application/json; charset=UTF-8';

    if (image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('ProductImage', image.path));
    }

    return request.send();
  }

  Future<http.Response> delete(id) async {
    final http.Response response = await http.delete(
      Uri.parse(Endpoints.deleteProduct + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userData.token!,
      },
    );

    return response;
  }

  Future<Map<String, dynamic>> getById(int idProduto) async {
    final response = await http.get(
      Uri.parse(Endpoints.searchProductById + idProduto.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userData.token!
      }
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
          json.decode(response.body)["produto"]);
    } else if (response.statusCode == 404) {
      return <String, dynamic>{};
    } else {
      throw Exception('Houve um erro ao buscar os produtos do vendedor.');
    }
  }
}
