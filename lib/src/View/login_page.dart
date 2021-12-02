import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hub/src/SQLite/user_data_sqlite.dart';

import './Class/user_data.dart';
import '../Api/api_login.dart';
import '../Widget/bezier_container.dart';

import 'vendedor_page.dart';
import 'ViewCliente/cliente_page.dart';
import 'signup_page.dart';

import 'Components/modal_message.dart';
import 'Components/buttons.dart';
import 'Components/entry_fields.dart';
import 'Components/labels_text.dart';
import '../Validations/form_field_validations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_loginFormKey.currentState!.validate()) {
          _authenticate(user.text, senha.text);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.transparent,
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  Widget _userPasswordWidget() {
    return Column(
      children: <Widget>[
        entryFieldValidation("Email ou GRR", user, validateUsername,
            placeholder: ''),
        entryFieldValidation("Senha", senha, validatePassword,
            isPassword: true, placeholder: ''),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer()),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  defaultTitle(this.context, "HUB UFPR"),
                  const SizedBox(height: 50),
                  Form(key: _loginFormKey, child: (_userPasswordWidget())),
                  _submitButton(),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: const Text('Esqueceu a senha?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(height: height * .055),
                  linkedLabel(
                      this.context,
                      "Não tem uma conta?",
                      "Registrar",
                      const SignUpPage(
                        title: '',
                      )),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: defaultBackButton(this.context)),
        ],
      ),
    ));
  }

  void _authenticate(user, senha) {
    var api = apiLogin();

    api.login(user, senha).then((response) {
      setState(() {
        if (response.statusCode == 200) {
          final trataDados = jsonDecode(response.body).cast<String, dynamic>();

          userData.idUser = trataDados["user"]["id"];
          userData.token = trataDados["token"];

          if (trataDados["user"]["isVendedor"]) {
            userData.idVendedor = trataDados["idVendedor"];

            userDataSqlite.insertUserData(userData.toMap());

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => VendedorPage(
                        title: ''
                    )
                ),
                    (r) => false
            );
          } else {
            userData.idCliente = trataDados["idCliente"];
            userDataSqlite.insertUserData(userData.toMap());

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ClientePage(
                  title: ''
                )
              ),
              (r) => false
            );
          }
        } else {
          customMessageModal(
              context,
              "Falha ao autenticar: ",
              "Usuário e/ou senha incorretos. Por favor, tente novamente.",
              "Fechar");
        }
      });
    }, onError: (error) async {
      setState(() {});
    });
  }
}
