import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:hub/src/Widget/bezier_container.dart';
import 'package:hub/src/View/login_page.dart';

import '../Api/apiRegister.dart';
import '../Widget/bezier_container.dart';

import 'Components/modal_message.dart';
import 'Components/buttons.dart';
import 'Components/entry_fields.dart';
import 'Components/labels_text.dart';
import '../Validations/form_field_validations.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, required this.title}) : super(key: key);

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

  final _formKey = GlobalKey<FormState>();

  Widget passwordField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Senha",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            validator: (value) {
              var ret = validatePassword(value!);
              if (ret != null)
                return ret;
              else {
                if (confirmaSenha.text == null || confirmaSenha.text.isEmpty)
                  return null;
                if (value.compareTo(confirmaSenha.text) == 0)
                  return null;
                else
                  return "Senhas não coincidem!";
              }
            },
            controller: senha,
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
          )
        ],
      ),
    );
  }

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
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          child: const Text(
            "Registrar",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        entryFieldValidation("Nome", nome, validateName, placeholder: ''),
        entryFieldValidation("GRR", grr, validateGRR,
            keyboard: TextInputType.number, placeholder: ''),
        entryFieldValidation("Email", email, validateEmail,
            placeholder: "email@ufpr.br"),
        passwordField(),
        entryFieldValidation(
            "Confirmação de senha", confirmaSenha, validatePassword,
            isPassword: true, placeholder: ''),
        CheckboxListTile(
          title: Text("Eu sou um Vendedor"),
          value: isChecked,
          onChanged: (newValue) {
            setState(() {
              isChecked = newValue!;
            });
          },
          controlAffinity:
              ListTileControlAffinity.leading, //  <-- leading Checkbox
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
                    Form(
                      key: _formKey,
                      child: _emailPasswordWidget(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                    linkedLabel(this.context, 'Já tem uma conta?', 'Login',
                        LoginPage(title: '',)),
                  ],
                ),
              ),
            ),
            Positioned(
                top: 40, left: 0, child: defaultBackButton(this.context)),
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
          context, MaterialPageRoute(builder: (context) => LoginPage(title: '',)));

      customMessageModal(
          this.context,
          "Sucesso!",
          "Seu cadastro foi realizado com sucesso. Agora você já pode efetuar seu login.",
          "OK");
    } else {
      customMessageModal(this.context, "Falha ao cadastrar usuário: ",
          jsonDecode(ret.body)["msg"], "Fechar");
    }
  }
}
