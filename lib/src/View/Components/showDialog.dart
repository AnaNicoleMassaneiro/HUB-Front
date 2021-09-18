import 'package:flutter/material.dart';

void customMessageModal(BuildContext context, final msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Falha ao cadastrar usuário: "),
        content: new Text(msg),
        actions: <Widget>[
          new TextButton(
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

void loginErrorModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Falha ao autenticar"),
        content: new Text("Usuário e/ou senha incorretos. Por favor, tente novamente."),
        actions: <Widget>[
          new TextButton(
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