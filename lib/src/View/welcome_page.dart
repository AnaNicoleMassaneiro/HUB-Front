import 'package:flutter/material.dart';
import 'package:hub/src/View/login_page.dart';
import 'package:hub/src/View/signup_page.dart';

import 'Components/labels_text.dart';
import 'Components/buttons.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF915FB5), Color(0xFFCA436B)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              defaultTitleWhite(this.context, "HUB UFPR"),
              SizedBox(
                height: 80,
              ),
              submitButtonBorder(
                  this.context,
                  "Login",
                  LoginPage(
                    title: '',
                  )),
              SizedBox(
                height: 20,
              ),
              submitButtonBorder(
                  this.context,
                  "Registrar",
                  SignUpPage(
                    title: '',
                  )),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
