import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/Validations/form_field_validations.dart';
import 'package:hub/src/View/Components/entry_fields.dart';
import 'package:hub/src/View/Components/modal_message.dart';

import '../vendedor_page.dart';

class CadastrarProdutoPage extends StatefulWidget {
  CadastrarProdutoPage(
      {Key? key, required this.title, required this.idVendedor, this.idUser})
      : super(key: key);

  final String title;
  final int idVendedor;
  final int? idUser;

  @override
  _CadastrarProdutoPageState createState() => _CadastrarProdutoPageState();
}

class _CadastrarProdutoPageState extends State<CadastrarProdutoPage> {
  final TextEditingController preco = TextEditingController();
  final TextEditingController nome = TextEditingController();
  final TextEditingController descricao = TextEditingController();
  final TextEditingController qtdDisponivel = TextEditingController();

  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _registerProduct(double.parse(preco.text), nome.text,
                descricao.text, int.parse(qtdDisponivel.text));
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          child: const Text(
            "Cadastrar",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _cadastroForm() {
    return Column(
      children: <Widget>[
        entryFieldValidation("Nome", nome, validateName, placeholder: ''),
        entryFieldValidation("Preço", preco, validateNumber,
            placeholder: '', keyboard: TextInputType.number),
        entryFieldValidation("Descrição", descricao, validateName,
            placeholder: ''),
        entryFieldValidation(
            "Quantidade Disponível", qtdDisponivel, validateName,
            placeholder: '', keyboard: TextInputType.number),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Cadastar Produto'),
          backgroundColor: Colors.orange),
      body: SizedBox(
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: _cadastroForm(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerProduct(preco, nome, descricao, qtdDisponivel) async {
    var api = api_product();
    var ret = await api.register(
        widget.idVendedor, preco, nome, descricao, qtdDisponivel);

    if (ret.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            // ignore: prefer_const_constructors
            builder: (context) => VendedorPage(
                  title: '',
                  idVendedor: widget.idVendedor,
                  idUser: widget.idUser,
                )),
      );
      customMessageModal(
          context, "Sucesso!", "Produto cadastrado com sucesso", "OK");
    } else {
      customMessageModal(context, "Falha ao cadastrar produto: ",
          jsonDecode(ret.body)["msg"], "Fechar");
    }
  }
}
