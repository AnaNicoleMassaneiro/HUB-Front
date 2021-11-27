import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_user.dart';
import 'package:hub/src/View/editar_senha_page.dart';
import '../View/Class/user_data.dart';
import 'Class/User.dart';
import 'editar_nome_page.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late final String texto;
  late final int? idUser;
  TextEditingController controller = TextEditingController();
  late User usuario;

  @override
  void initState() {
    idUser = userData.idUser;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text('Perfil'), backgroundColor: Colors.orange),
        body: buildContainer());
  }

  Future<User> getFutureDados() async {
    var api = ApiUser();

    await api.searchId(idUser).then((response) => setState(() {
          usuario = User.fromJson(response);
        }));

    return usuario;
  }

  Container buildContainer() {
    // ignore: avoid_unnecessary_containers
    return Container(
        child: FutureBuilder(
            future: getFutureDados(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SafeArea(
                    child: Column(
                  children: [
                    header(),
                  ],
                ));
              }
            }));
  }

  Widget header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
      child: Column(
        children: <Widget>[
          Text('Nome ' + usuario.name),
          Text('Email ' + usuario.email),
          Text('GRR ' + usuario.grr),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditarSenhaPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  color: const Color(0xFF915FB5),
                  child: const Text(
                    "Editar Senha",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditarNomePage(
                              idUser: idUser,
                              name: usuario.name,
                              email: usuario.email,
                              grr: usuario.grr)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  color: const Color(0xFF915FB5),
                  child: const Text(
                    "Editar Nome",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
