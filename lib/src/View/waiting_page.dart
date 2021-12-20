import 'package:flutter/material.dart';
import 'package:hub/src/SQLite/user_data_sqlite.dart';
import 'package:hub/src/View/vendedor_page.dart';
import 'package:hub/src/View/welcome_page.dart';
import 'package:hub/src/util/hub_colors.dart';

import 'Class/user_data.dart';
import 'ViewCliente/cliente_page.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  _WaitingPageState createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  void initUserData(BuildContext context) async {
    var ret = await userDataSqlite.getUserData();

    if (ret["idUser"] != null) {
      userData.idUser = ret["idUser"];
      userData.idVendedor = ret["idVendedor"];
      userData.idCliente = ret["idCliente"];
      userData.isVendedor = ret["isVendedor"] == "true" ? true : false;
      userData.isVendedorProfileActive = userData.isVendedor;
      userData.curLocationLat = ret["locationLat"];
      userData.curLocationLon = ret["locationLon"];
      userData.token = ret["token"];

      if (userData.isVendedor!) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => VendedorPage(),
            ),
                (r) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ClientePage(),
            ),
                (r) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomePage(),
          ),
              (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    initUserData(context);

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [hubColors.primary, hubColors.yellowExtraLight])),
        child: Center(
          child: Image.asset("assets/darklogo.png", width: 200, height: 200),
        ),
      ),
    ));
  }
}
