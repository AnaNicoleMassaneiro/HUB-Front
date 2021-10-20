import 'dart:convert';
import 'dart:io';
import 'package:hub/src/util/endpoints.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class api_product {
  Future<List<Map<String, dynamic>>> search(int? idVendedor) async {
    final response = await http.post(
      Uri.parse(Endpoints.searchProdutoPorVendedor),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, dynamic>{"sellerId": idVendedor, "returnActiveOnly": false}),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["produto"]);
    } else {
      throw Exception('Failed to create MeusProdutos.');
    }
  }

  Future<http.StreamedResponse> register(int idVendedor, double preco,
      String nome, String descricao, int qtdDisponivel, File? image) async {
    var request =
        http.MultipartRequest('Post', Uri.parse(Endpoints.registerProduct));

    request.fields['nome'] = nome;
    request.fields['isAtivo'] = "true";
    request.fields['preco'] = preco.toString();
    request.fields['descricao'] = descricao;
    request.fields['quantidadeDisponivel'] = qtdDisponivel.toString();
    request.fields['idVendedor'] = idVendedor.toString();

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
      File? image) async {
    var request = http.MultipartRequest(
        'Put', Uri.parse(Endpoints.updateProduct + idProduto.toString()));

    request.fields['nome'] = nome;
    request.fields['isAtivo'] = "true";
    request.fields['preco'] = preco.toString();
    request.fields['descricao'] = descricao;
    request.fields['quantidadeDisponivel'] = qtdDisponivel.toString();

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
      },
    );

    return response;
  }
}
