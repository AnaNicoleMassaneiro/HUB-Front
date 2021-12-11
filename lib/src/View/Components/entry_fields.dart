import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hub/src/util/hub_colors.dart';

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
        Container(
          decoration: BoxDecoration(
            color: hubColors.lightGreyTextbox,
            border: Border.all(
                color: hubColors.yellowExtraLight,// set border color
                width: 2),   // set border width
            borderRadius: const BorderRadius.all(
                Radius.circular(5.0)), // set rounded corner radius
          ),
          child: TextFormField(
            validator: (value) {
              return validation(value.toString());
            },
            enabled: enabled,
            controller: controllerTxt,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: placeholder.trim() == "" ? null : placeholder,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
            keyboardType: keyboard,
          ),
        ),
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
        Container(
          child: TextFormField(
            validator: (value) {
              return validation(value.toString());
            },
            maxLines: maxLines,
            enabled: enabled,
            controller: controllerTxt,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                border: InputBorder.none,
                fillColor: Colors.black12,
                labelText: placeholder,
            ),
          ),
          decoration: BoxDecoration(
              border: Border.all(
                  color: hubColors.yellowExtraLight,// set border color
                  width: 2),   // set border width
              borderRadius: const BorderRadius.all(
                  Radius.circular(5.0)),
              color: hubColors.lightGreyTextbox
          ),
        )
      ],
    ),
  );
}