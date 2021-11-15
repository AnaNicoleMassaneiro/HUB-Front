import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/View/ViewCliente/cliente_page.dart';
import 'package:hub/src/View/vendedor_page.dart';

import 'src/View/welcome_page.dart';
import 'src/SQLite/user_data_sqlite.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void initUserData() async {
    var ret = await userDataSqlite.getUserData();

    if (ret["idUser"] != null) {
      userData.idUser = ret["idUser"];
      userData.idVendedor = ret["idVendedor"];
      userData.idCliente = ret["idCliente"];
      userData.curLocationLat = ret["locationLat"];
      userData.curLocationLon = ret["locationLon"];
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    initUserData();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
          bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: userData.idUser == null
      ? const WelcomePage(title: '',)
      : userData.idVendedor == null
        ? ClientePage(title: '')
        : VendedorPage(title: '')
      ,
    );
  }
}
