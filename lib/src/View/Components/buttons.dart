import 'package:flutter/material.dart';
import 'package:hub/src/util/hub_colors.dart';

Widget defaultBackButton(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
            child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
          ),
          const Text('Voltar',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
        ],
      ),
    ),
  );
}

Widget submitButtonWhite(BuildContext context, String text, Widget target) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => target));
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 13),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: const Color(0xffdf8e33).withAlpha(100),
                offset: const Offset(2, 4),
                blurRadius: 8,
                spreadRadius: 2)
          ],
          color: Colors.white),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Color(0xfff7892b)),
      ),
    ),
  );
}

Widget submitButtonBorder(BuildContext context, String text, Widget target) {
  return InkWell(
    onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => target)
    ),
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 13),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(29)),
        border: Border.all(color: hubColors.dark, width: 2),
        color: hubColors.dark,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: hubColors.white),
      ),
    ),
  );
}