import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hub/src/Api/apiRegister.dart';
import 'package:hub/src/Validations/form_field_validations.dart';
import 'package:hub/src/View/Components/buttons.dart';
import 'package:hub/src/View/Components/entry_fields.dart';
import 'package:hub/src/View/Components/labels_text.dart';
import 'package:hub/src/View/Components/modal_message.dart';

import 'package:hub/src/Widget/bezier_container.dart';
import 'package:hub/src/View/login_page.dart';

class CadastrarProdutoPage extends StatefulWidget {
  CadastrarProdutoPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CadastrarProdutoPageState createState() => _CadastrarProdutoPageState();
}

class _CadastrarProdutoPageState extends State<CadastrarProdutoPage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  final TextEditingController nome = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController grr = TextEditingController();
  final TextEditingController confirmaSenha = TextEditingController();
  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _registerUser(nome.text, isChecked, senha.text, confirmaSenha.text,
                grr.text, email.text);
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
        entryFieldValidation("Preço", nome, validateName, placeholder: ''),
        entryFieldValidation("Descrição", nome, validateName, placeholder: ''),
        entryFieldValidation("Quantidade Disponível", nome, validateName,
            placeholder: ''),
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

  void _registerUser(nome, isChecked, senha, confirmaSenha, grr, email) async {
    var api = apiRegister();
    var ret =
        await api.create(nome, isChecked, senha, confirmaSenha, grr, email);

    if (ret.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(
                    title: '',
                  )));

      customMessageModal(
          context,
          "Sucesso!",
          "Seu cadastro foi realizado com sucesso. Agora você já pode efetuar seu login.",
          "OK");
    } else {
      customMessageModal(context, "Falha ao cadastrar usuário: ",
          jsonDecode(ret.body)["msg"], "Fechar");
    }
  }
}
