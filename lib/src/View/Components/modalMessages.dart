import 'package:flutter/material.dart';

void customMessageModal(BuildContext context, String title, String innerText, String btnText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(innerText),
        actions: <Widget>[
          new TextButton(
            child: new Text(btnText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}