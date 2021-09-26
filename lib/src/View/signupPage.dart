import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_login_signup/src/Widget/bezierContainer.dart';
import 'package:flutter_login_signup/src/View/loginPage.dart';

import '../Api/apiRegister.dart';
import '../Widget/bezierContainer.dart';

import 'Components/modalMessages.dart';
import 'Components/buttons.dart';
import 'Components/entryFields.dart';
import 'Components/labelsTexts.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  final TextEditingController nome = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController grr = TextEditingController();
  final TextEditingController confirmaSenha = TextEditingController();
  bool isChecked = false;

  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        _registerUser(
        nome.text, isChecked, senha.text, confirmaSenha.text, grr.text, email.text);
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
          'Registrar',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      )
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        simpleEntryField("Nome", nome),
        simpleEntryField("GRR", grr, keyboard: TextInputType.number),
        simpleEntryField("Email", email, placeholder: "email@ufpr.br"),
        simpleEntryField("Senha", senha, isPassword: true),
        simpleEntryField("Confirmação de senha", confirmaSenha, isPassword: true),
        CheckboxListTile(
          title: Text("Eu sou um Vendedor"),
          value: isChecked,
          onChanged: (newValue) {
            setState(() {
              isChecked = newValue;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
        ),
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
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    defaultTitle(this.context, "HUB UFPR"),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                    linkedLabel(
                        this.context,
                        'Já tem uma conta?',
                        'Login',
                        LoginPage()
                    ),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: defaultBackButton(this.context)),
          ],
        ),
      ),
    );
  }

  void _registerUser(nome, isChecked, senha, confirmaSenha, grr, email) async {
    var api = new apiRegister();
    var ret = await api.create(
        nome, isChecked, senha, confirmaSenha, grr, email);

    if (ret.statusCode == 200) {
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage())
      );

      customMessageModal(
          this.context,
          "Sucesso!",
          "Seu cadastro foi realizado com sucesso. Agora você já pode efetuar seu login.",
          "OK"
      );
    }
    else {
      customMessageModal(
        this.context,
        "Falha ao cadastrar usuário: ",
        jsonDecode(ret.body)["msg"],
        "Fechar"
      );
    }
  }
}
