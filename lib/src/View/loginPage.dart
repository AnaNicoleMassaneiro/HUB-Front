import 'dart:convert';

import 'package:flutter/material.dart';

import '../Api/apiLogin.dart';
import '../Widget/bezierContainer.dart';

import 'VendedorPage.dart';
import 'ClientePage.dart';
import 'signupPage.dart';

import 'Components/modalMessages.dart';
import 'Components/buttons.dart';
import 'Components/entryFields.dart';
import 'Components/labelsTexts.dart';
import '../Validations/formFieldValidations.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
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
        if (_loginFormKey.currentState.validate())
          _authenticate(user.text, senha.text);
      },
      child: new Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _userPasswordWidget() {
    return Column(
      children: <Widget>[
        entryFieldValidation("Email ou GRR", user, validateUsername),
        entryFieldValidation("Senha", senha, validatePassword, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  defaultTitle(this.context, "HUB UFPR"),
                  SizedBox(height: 50),
                  Form(
                    key: _loginFormKey,
                    child: (
                        _userPasswordWidget()
                    )
                  ),
                  _submitButton(),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Esqueceu a senha?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(height: height * .055),
                  linkedLabel(
                    this.context,
                    "Não tem uma conta?",
                    "Registrar",
                    SignUpPage()
                  ),
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
    var api = new apiLogin();
    api.login(user, senha).then((response) {
      setState(() {
        if (response.statusCode == 200) {
          final trataDados = jsonDecode(response.body).cast<String, dynamic>();

          if (trataDados["user"]["isVendedor"]) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VendedorPage()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ClientePage()));
          }
        } else {
          customMessageModal(
            this.context,
            "Falha ao autenticar: ",
            "Usuário e/ou senha incorretos. Por favor, tente novamente.",
            "Fechar"
          );
          throw Exception('Failed to load album');
        }
      });
    }, onError: (error) async {
      print(error);
      setState(() {});
    });
  }
}
