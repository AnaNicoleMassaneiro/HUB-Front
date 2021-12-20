import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:hub/src/Api/api_vendores.dart';
import 'package:hub/src/View/Class/forma_de_pagamento.dart';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:hub/src/util/hub_colors.dart';

class MinhasFormasDePagamentoPage extends StatefulWidget {
  const MinhasFormasDePagamentoPage({Key? key}) : super(key: key);

  @override
  _MinhasFormasDePagamentoPageState createState() =>
      _MinhasFormasDePagamentoPageState();
}

class _MinhasFormasDePagamentoPageState
    extends State<MinhasFormasDePagamentoPage> {
  late List<FormaDePagamento> userPayment = [];
  late List<FormaDePagamento> payment = [];
  late Future<List<Map<String, dynamic>>> futurePayment;
  late Future<List<Map<String, dynamic>>> futureMyPayment;
  bool _isLoading = false;

  Future<List<Map<String, dynamic>>> buscaMinhasFormasDePagamento() {
    var api = ApiVendedores();

    userPayment.clear();

    return api.getFormasDePagamentoBySeller(userData.idVendedor!);
  }

  Future<List<Map<String, dynamic>>> buscaFormasDePagamento() {
    var api = ApiVendedores();

    payment.clear();

    return api.listFormasDePagamento();
  }

  @override
  void initState() {
    super.initState();

    futureMyPayment = buscaMinhasFormasDePagamento();
    futurePayment = buscaFormasDePagamento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Minhas Formas de Pagamento'),
            flexibleSpace: Container(
              decoration: hubColors.appBarGradient(),
            )),
        body: FutureBuilder(
          future: Future.wait([futurePayment, futureMyPayment]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData && !_isLoading) {
              userPayment.clear();
              payment.clear();

              for (var p in snapshot.data![1]) {
                userPayment.add(FormaDePagamento.fromJson(p));
              }

              for (var p in snapshot.data![0]) {
                payment.add(FormaDePagamento.fromJson(p));
              }

              return Column(
                children: [pageHeader(), pageBody()],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  pageHeader(),
                  const Center(child: CircularProgressIndicator()),
                ],
              );
            }
          },
        ));
  }

  Widget pageHeader() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        "Aqui você pode selecionar quais formas de pagamento você aceita."
        " Os clientes podem vê-las no seu perfil.",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 16,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget pageBody() {
    return Expanded(child: ListView.builder(
        itemCount: payment.length,
        itemBuilder: (context, i) {
          return SwitchListTile(
            value: isPaymentAccepted(payment[i].id),
            onChanged: (bool v) {
              setState(() => _isLoading = true );
              addOrRemovePaymentMode(payment[i].id);
            },
            secondary:
                Image.asset(payment[i].icone, width: 50, fit: BoxFit.contain),
            title: Text(
              payment[i].descricao,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
          );
        }));
  }

  void addOrRemovePaymentMode(int idFormaPagamento) async {
    var api = ApiVendedores();

    Response response;

    if (isPaymentAccepted(idFormaPagamento)) {
      response = await api.removeFormaPagamento(
          idFormaPagamento, userData.idVendedor!);
    } else {
      response =
          await api.addFormaPagamento(idFormaPagamento, userData.idVendedor!);
    }

    if (response.statusCode == 200) {
      futureMyPayment = buscaMinhasFormasDePagamento();

      for (var p in await futureMyPayment) {
        userPayment.add(FormaDePagamento.fromJson(p));
      }

      setState(() => _isLoading = false);
    } else {
      setState(() => _isLoading = false);
      customMessageModal(
          context,
          "Erro",
          "Ocorreu um erro ao salvar sua alteração: " +
              jsonDecode(response.body)["msg"],
          "Fechar");
    }
  }

  bool isPaymentAccepted(int id) {
    for (var f in userPayment) {
      if (f.id == id) {
        return true;
      }
    }
    return false;
  }
}
