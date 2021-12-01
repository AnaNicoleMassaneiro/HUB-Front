import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:hub/src/Api/api_vendores.dart';
import 'package:hub/src/View/Class/forma_de_pagamento.dart';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/View/Components/modal_message.dart';

class MinhasFormasDePagamentoPage extends StatefulWidget {
  const MinhasFormasDePagamentoPage({Key? key}) : super(key: key);

  @override
  _MinhasFormasDePagamentoPageState createState() =>
      _MinhasFormasDePagamentoPageState();
}

class _MinhasFormasDePagamentoPageState
    extends State<MinhasFormasDePagamentoPage> {
  List<FormaDePagamento> userPayment = [];
  List<FormaDePagamento> payment = [];

  void buscaMinhasFormasDePagamento() {
    var api = ApiVendedores();

    userPayment.clear();

    api.getFormasDePagamentoBySeller(userData.idVendedor!).then((response) {
      for (var p in response) {
        setState(() {
          userPayment.add(FormaDePagamento.fromJson(p));
        });
      }
    }, onError: (error) async {
      setState(() {});
    });
  }

  void buscaFormasDePagamento() {
    var api = ApiVendedores();

    payment.clear();

    api.listFormasDePagamento().then((response) {
      for (var p in response) {
        setState(() {
          payment.add(FormaDePagamento.fromJson(p));
        });
      }
    }, onError: (error) async {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    buscaMinhasFormasDePagamento();
    buscaFormasDePagamento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Minhas Formas de Pagamento'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFFD600), Color(0xFFFBC02D)]),
              ),
            )),
        body: SizedBox(
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Aqui você selecionar quais formas de pagamento você aceita."
                          " Os clientes podem vê-las no seu perfil.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                              itemCount: payment.length,
                              itemBuilder: (context, i) {
                                return SwitchListTile(
                                  value: isPaymentAccepted(payment[i].id),
                                  onChanged: (bool v) {
                                    addOrRemovePaymentMode(payment[i].id);
                                  },
                                  secondary: Image.asset(payment[i].icone,
                                      width: 50, fit: BoxFit.contain),
                                  title: Text(
                                    payment[i].descricao,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300),
                                  ),
                                );
                              }))),
                ],
              ),
            ],
          ),
        ));
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
      setState(() {
        buscaMinhasFormasDePagamento();
      });
    } else {
      print(response.statusCode.toString());
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
