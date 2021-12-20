import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/View/waiting_page.dart';
import 'package:location/location.dart';

void main() async {
  runApp(const MyApp());

  const minute = Duration(seconds: 60);

  Timer.periodic(minute, (Timer t1) async {
    if (userData.idUser != null && userData.idUser! > 0) {
      var l = await Location().getLocation();
      userData.atualizarLocalizacao(l);
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const WaitingPage()
    );
  }
}
