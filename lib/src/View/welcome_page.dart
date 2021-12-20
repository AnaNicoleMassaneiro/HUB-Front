import 'package:flutter/material.dart';
import 'package:hub/src/View/login_page.dart';
import 'package:hub/src/View/signup_page.dart';
import 'package:hub/src/util/hub_colors.dart';

import 'Components/buttons.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [hubColors.primary, hubColors.yellowExtraLight])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/darklogo.png", width: 200, height: 200),
              const SizedBox(
                height: 80,
              ),
              submitButtonBorder(
                  this.context,
                  "Login",
                  const LoginPage(
                    title: '',
                  )),
              const SizedBox(
                height: 20,
              ),
              submitButtonBorder(
                  this.context,
                  "Registrar",
                  const SignUpPage(
                    title: '',
                  )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
