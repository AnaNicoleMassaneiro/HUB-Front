import 'package:flutter/material.dart';

void customMessageModal(
    BuildContext context, String title, String innerText, String btnText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Text(title),
        content: Text(innerText),
        actions: <Widget>[
          TextButton(
            child: Text(btnText),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
