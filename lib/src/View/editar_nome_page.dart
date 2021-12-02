import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_user.dart';

import 'Class/User.dart';
import 'Components/modal_message.dart';
import 'editar_senha_page.dart';

class EditarNomePage extends StatefulWidget {
  const EditarNomePage({Key? key, required this.idUser}) : super(key: key);

  final dynamic idUser;

  @override
  _EditarNomePageState createState() => _EditarNomePageState();
}

class _EditarNomePageState extends State<EditarNomePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerTel = TextEditingController();
  late User usuario;

  @override
  void initState() {
    super.initState();
  }

  Future<User> getFutureDados() async {
    var api = ApiUser();

    await api.searchId(widget.idUser).then((response) => setState(() {
          usuario = User.fromJson(response);
        }));

    return usuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Editar Perfil'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFFD600), Color(0xFFFBC02D)]),
              ),
            )),
        body: buildContainer());
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
                    tela(),
                  ],
                ));
              }
            }));
  }

  tela() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditarSenhaPage(idUser: widget.idUser)));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    color: const Color(0xFFFBC02D),
                    child: const Text(
                      "Editar Senha",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  )),
            ),
            Column(
              children: [
                Text('Nome ' + usuario.name),
                Text('Email ' + usuario.email),
                Text('GRR ' + usuario.grr),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Nome'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    controller: controllerTel,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Telefone'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      _salvar(
                          widget.idUser, controller.text, controllerTel.text);
                    },
                    child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    color: const Color(0xFFFBC02D),
                    child: const Text(
                      "Salvar",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _salvar(id, name, phone) {
    var api = ApiUser();
    api.updateUserName(id, name, phone).then((response) {
      if (response.statusCode == 200) {
        customMessageModal(
            context, 'Sucesso', 'Sucesso ao alterar nome do usuario', 'Fechar');

        controller.clear();
        controllerTel.clear();
      } else {
        customMessageModal(
            context, 'Erro', 'Erro ao alterar nome do usuario', 'Fechar');
      }
    });
  }
}
