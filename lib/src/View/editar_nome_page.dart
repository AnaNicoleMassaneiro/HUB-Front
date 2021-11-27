import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_user.dart';

import 'Components/modal_message.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Editar Nome'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF915FB5), Color(0xFFCA436B)]),
              ),
            )
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Column(
                  children: <Widget>[
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
                        ElevatedButton(
                            onPressed: () {
                              _salvar(widget.idUser, controller.text);
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

  void _salvar(id, name) {
    var api = ApiUser();
    api.updateUserName(id, name).then((response) {
      if (response.statusCode == 200) {
        customMessageModal(
            context, 'Sucesso', 'Sucesso ao alterar nome do usuario', 'Fechar');

        controller.clear();
      } else {
        customMessageModal(
            context, 'Erro', 'Erro ao alterar nome do usuario', 'Fechar');
      }
    });
  }
}
