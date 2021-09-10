import 'package:flutter/material.dart';
import 'package:flutter_login_signup/src/signup.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Api/apiLogin.dart';
import 'ListaScreen.dart';
import 'Widget/bezierContainer.dart';

class ListaScreen extends StatefulWidget {
  ListaScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  int _indiceAtual = 0;

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('titulo')
      ),
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("localizacao")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket), title: Text("Meus pedidos")),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), title: Text("Favoritos")),
          ],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}
