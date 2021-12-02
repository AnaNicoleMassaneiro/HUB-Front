import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_user.dart';

import 'Components/modal_message.dart';
import 'editar_senha_page.dart';

class EditarNomePage extends StatefulWidget {
  const EditarNomePage(
      {Key? key,
      required this.idUser,
      required this.name,
      required this.email,
      required this.grr})
      : super(key: key);

  final dynamic idUser;
  final String name;
  final String email;
  final String grr;

  @override
  _EditarNomePageState createState() => _EditarNomePageState();
}

class _EditarNomePageState extends State<EditarNomePage> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerTel = TextEditingController();

  @override
  void initState() {
    super.initState();
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
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditarSenhaPage(
                                        idUser: widget.idUser)));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            color: const Color(0xFFFBC02D),
                            child: const Text(
                              "Editar Senha",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          )),
                    ),
                    Column(
                      children: [
                        Text('Nome ' + widget.name),
                        Text('Email ' + widget.email),
                        Text('GRR ' + widget.grr),
                        TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: 'Nome'),
                        ),
                        TextField(
                          controller: controllerTel,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Telefone'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _salvar(widget.idUser, controller.text,
                                  controllerTel.text);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              alignment: Alignment.center,
                              color: Colors.orange,
                              child: const Text(
                                "Salvar",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
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
