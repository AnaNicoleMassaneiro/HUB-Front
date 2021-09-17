import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, Object> dados = ModalRoute.of(context).settings.arguments;

    Future.delayed(Duration.zero, () => ({modal(context, dados["msg"])}));
  }

  Future<dynamic> modal(BuildContext context, final msg) {
    return showDialog(
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
