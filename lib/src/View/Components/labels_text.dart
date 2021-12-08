import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/src/util/hub_colors.dart';

Widget linkedLabel(BuildContext context, String text1, String text2,
    Widget target) {
  return InkWell(
    onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => target)
    ),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            text1,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text2,
            style: TextStyle(
                color: hubColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}


Widget defaultTitle(BuildContext context, String title) {
  return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: title,
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.headline1,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: hubColors.primary,
        ),
      ));
}

Widget defaultTitleWhite(BuildContext context, String title) {
  return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: title,
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.headline1,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: const Color(0xffffffff),
        ),
      ));
}