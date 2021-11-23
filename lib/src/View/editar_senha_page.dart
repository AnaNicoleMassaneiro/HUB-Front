import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_user.dart';
import '../View/Class/user_data.dart';
import 'Class/User.dart';

class EditarSenhaPage extends StatefulWidget {
  const EditarSenhaPage({Key? key}) : super(key: key);

  @override
  _EditarSenhaPageState createState() => _EditarSenhaPageState();
}

class _EditarSenhaPageState extends State<EditarSenhaPage> {
  late final String texto;
  late final int? idUser;
  TextEditingController controller = TextEditingController();
  late User usuario;

  @override
  void initState() {
    idUser = userData.idUser;

    buscarUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        AppBar(title: const Text('Perfil'), backgroundColor: Colors.orange),
        body: SafeArea(
          child: Column(
            children: [
              header(),
            ],
          ),
        ));
  }

  Widget header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Builder(builder: (context) {
                return Text("AAAAAAAAAAA",
                    style:
                    TextStyle(fontWeight: FontWeight.w100, fontSize: 16));
              }),
            ],
          ),
        ],
      ),
    );
  }

  void buscarUsuario() {
    var api = ApiUser();

    api.searchId(idUser).then((response) => usuario = User.fromJson(response));
  }
}