import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget linkedLabel(BuildContext context, String text1, String text2,
    Widget target) {
  return InkWell(
    onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => target)
    ),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(15),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            text1,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text2,
            style: TextStyle(
                color: Color(0xfff79c4f),
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
          color: Color(0xffe46b10),
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
          color: Color(0xffffffff),
        ),
      ));
}