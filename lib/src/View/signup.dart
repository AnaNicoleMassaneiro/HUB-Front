import 'package:flutter/material.dart';
import 'package:flutter_login_signup/src/View/VendedorPage.dart';
import 'package:flutter_login_signup/src/Widget/bezierContainer.dart';
import 'package:flutter_login_signup/src/View/loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../Api/apiRegister.dart';
import '../Widget/bezierContainer.dart';

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

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Voltar',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controllertxt, {String placeholder = null, bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controllertxt,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  labelText: placeholder,
                  filled: true))
        ],
      ),
    );
  }

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

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Já tem uma conta?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'HUB UFPR',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
        ));
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Nome", nome),
        _entryField("GRR", grr, placeholder: "GRRXXXXXXX  "),
        _entryField("Email", email, placeholder: "email@ufpr.br"),
        _entryField("Senha", senha, isPassword: true),
        _entryField("Confirmação de senha", confirmaSenha, isPassword: true),
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
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  void _registerUser(nome, isChecked, senha, confirmaSenha, grr, email) async {
    var api = new apiRegister();
    var ret = await api.create(nome, isChecked, senha, confirmaSenha, grr, email);

    print(ret.body);

    if (ret.statusCode == 200) {
      setState(() {

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => VendedorPage()));
      });
    }
    else {
      _showDialog(ret.body);
    }
  }

  void _showDialog(msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Falha ao cadastrar usuário"),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
