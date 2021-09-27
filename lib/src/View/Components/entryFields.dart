import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget simpleEntryField(String title, TextEditingController controllertxt,
    {String placeholder, bool isPassword = false, TextInputType keyboard = TextInputType.text}) {
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
        TextFormField(
            controller: controllertxt,
            obscureText: isPassword,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                labelText: placeholder,
                filled: true
            ),
            keyboardType: keyboard,
        )
      ],
    ),
  );
}

Widget entryFieldValidation(String title, TextEditingController controllerTxt, Function validation,
    {String placeholder, bool isPassword = false, TextInputType keyboard = TextInputType.text,
    }) {
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
        TextFormField(
          validator: (value) {
            return validation(value);
          },
          controller: controllerTxt,
          obscureText: isPassword,
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              labelText: placeholder,
              filled: true
          ),
          keyboardType: keyboard,
        )
      ],
    ),
  );
}