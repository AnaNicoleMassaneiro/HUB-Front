import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/util/endpoints.dart';

class ApiReport {
  Future<http.Response> generateReport(
      int idVendedor, String type, String interval) async {
    return http.post(
      Uri.parse(Endpoints.generateReport),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': userData.token!,
      },
      body: jsonEncode(<String, dynamic>{
        "idVendedor": idVendedor,
        "tipo": type,
        "dateFilter": interval
      }),
    );
  }
}
