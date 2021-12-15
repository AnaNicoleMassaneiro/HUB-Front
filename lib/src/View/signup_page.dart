import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:hub/src/View/login_page.dart';
import 'package:hub/src/util/hub_colors.dart';

import '../Api/api_register.dart';

import 'Components/modal_message.dart';
import 'Components/buttons.dart';
import 'Components/entry_fields.dart';
import 'Components/labels_text.dart';
import '../Validations/form_field_validations.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.title}) : super(key: key);

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
  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  Widget passwordField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Senha",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              decoration: BoxDecoration(
                color: hubColors.lightGreyTextbox,
                border: Border.all(
                    color: hubColors.yellowExtraLight, // set border color
                    width: 2), // set border width
                borderRadius: const BorderRadius.all(
                    Radius.circular(5.0)), // set rounded corner radius
              ),
              child: TextFormField(
                validator: (value) {
                  var ret = validatePassword(value!);
                  if (ret != null) {
                    return ret;
                  } else {
                    if (confirmaSenha.text.trim().isEmpty) {
                      return null;
                    }
                    if (value.compareTo(confirmaSenha.text) == 0) {
                      return null;
                    } else {
                      return "Senhas não coincidem!";
                    }
                  }
                },
                controller: senha,
                obscureText: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  border: InputBorder.none,
                  labelText: null,
                ),
              ))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return !_loading
        ? ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _registerUser(nome.text, isChecked, senha.text,
                    confirmaSenha.text, grr.text, email.text);
                setState(() => _loading = true);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Text(
                "Registrar",
                style: TextStyle(fontSize: 20, color: hubColors.dark),
              ),
            ))
        : const CircularProgressIndicator();
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
          title: const Text("Eu sou um Vendedor"),
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
                    SizedBox(height: height * .1),
                    Image.asset("assets/yellowlogo.png",
                        width: 200, height: 200),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: _emailPasswordWidget(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _submitButton(),
                    linkedLabel(
                        this.context,
                        'Já tem uma conta?',
                        'Login',
                        const LoginPage(
                          title: '',
                        )),
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
          context,
          MaterialPageRoute(
              builder: (context) => const LoginPage(
                    title: '',
                  )));

      customMessageModal(
          context,
          "Sucesso!",
          "Seu cadastro foi realizado com sucesso. Agora você já pode efetuar seu login.",
          "OK");
    } else {
      _loading = false;

      customMessageModal(context, "Falha ao cadastrar usuário: ",
          jsonDecode(ret.body)["msg"], "Fechar");
    }
  }
}
