import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hub/src/SQLite/user_data_sqlite.dart';
import 'package:hub/src/util/hub_colors.dart';

import './Class/user_data.dart';
import '../Api/api_login.dart';

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
  bool _loading = false;

  final _loginFormKey = GlobalKey<FormState>();

  Widget _submitButton() {
    return !_loading
        ? ElevatedButton(
            onPressed: () {
              if (_loginFormKey.currentState!.validate()) {
                _authenticate(user.text, senha.text);
              }
              setState(() => _loading = true);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.transparent,
              ),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20, color: hubColors.dark),
              ),
            ),
          )
        : const CircularProgressIndicator();
  }

  Widget _userPasswordWidget() {
    return Column(
      children: <Widget>[
        entryFieldValidation("Email ou GRR", user, validateUsername,
            placeholder: ''),
        entryFieldValidation("Senha", senha, validatePassword,
            isPassword: true, placeholder: ''),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  Image.asset("assets/yellowlogo.png", width: 200, height: 200),
                  const SizedBox(height: 40),
                  Form(key: _loginFormKey, child: (_userPasswordWidget())),
                  _submitButton(),
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
          final user = jsonDecode(response.body).cast<String, dynamic>();

          userData.idUser = user["user"]["id"];
          userData.idCliente = user["idCliente"];
          userData.isVendedor = user["user"]["isVendedor"];
          userData.token = user["token"];

          if (userData.isVendedor!) {
            userData.idVendedor = user["idVendedor"];
            userData.isVendedorProfileActive = true;

            userDataSqlite.insertUserData(userData.toMap());

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => VendedorPage()),
                (r) => false);
          } else {
            userData.isVendedorProfileActive = false;
            userDataSqlite.insertUserData(userData.toMap());

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ClientePage()),
                (r) => false);
          }
        } else {
          _loading = false;
          customMessageModal(
              context,
              "Falha ao autenticar: ",
              "Usuário e/ou senha incorretos. Por favor, tente novamente.",
              "Fechar");
        }
      });
    }, onError: (error) async {
      _loading = false;

      setState(() {
        customMessageModal(
            context,
            "Falha ao autenticar: ",
            "Verifique sua conexão com a internet ou entre em contato com o administrador",
            "Fechar");
      });
    });
  }
}
