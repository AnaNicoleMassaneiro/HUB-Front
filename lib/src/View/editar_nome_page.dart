import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_user.dart';

import 'Class/User.dart';
import 'Class/user_data.dart';
import 'Components/modal_message.dart';
import 'editar_senha_page.dart';

class EditarNomePage extends StatefulWidget {
  const EditarNomePage({Key? key, required this.usuario}) : super(key: key);

  final User usuario;

  @override
  _EditarNomePageState createState() => _EditarNomePageState();
}

class _EditarNomePageState extends State<EditarNomePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerTel = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.text = widget.usuario.name;
    controllerTel.text = widget.usuario.telefone;
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
        child: SafeArea(
            child: Column(
              children: [
                tela(),
              ],
            )));
  }

  tela() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Column(
              children: [
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
                    maxLength: 15,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Telefone'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      _salvar(
                          userData.idVendedor!, controller.text, controllerTel.text);
                    },
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
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
        Navigator.of(context).pop();

        customMessageModal(
            context, 'Sucesso', 'Nome do usuário alterado com sucesso.', 'Fechar');
      } else {
        customMessageModal(
            context, 'Erro', 'Erro ao alterar nome do usuario', 'Fechar');
      }
    });
  }
}
