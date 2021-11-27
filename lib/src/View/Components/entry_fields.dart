import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget simpleEntryField(String title, TextEditingController controllertxt,
    {String? placeholder, bool isPassword = false, TextInputType keyboard = TextInputType.text}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
            controller: controllertxt,
            obscureText: isPassword,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: const Color(0xfff3f3f4),
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
    {required String placeholder, bool isPassword = false,
      TextInputType keyboard = TextInputType.text, bool enabled = true
    }) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: (value) {
            return validation(value.toString());
          },
          enabled: enabled,
          controller: controllerTxt,
          obscureText: isPassword,
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: const Color(0xfff3f3f4),
              labelText: placeholder.trim() == "" ? null : placeholder,
              filled: true
          ),
          keyboardType: keyboard,
        )
      ],
    ),
  );
}

Widget textAreaEntryFieldValidation(
    String title, TextEditingController controllerTxt, Function validation,
    int maxLines, {String? placeholder, bool enabled = true}
  ) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: (value) {
            return validation(value.toString());
          },
          maxLines: maxLines,
          enabled: enabled,
          controller: controllerTxt,
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: const Color(0xfff3f3f4),
              labelText: placeholder,
              filled: true
          ),
        )
      ],
    ),
  );
}