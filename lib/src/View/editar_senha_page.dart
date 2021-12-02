import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_user.dart';

import 'Components/modal_message.dart';

class EditarSenhaPage extends StatefulWidget {
  const EditarSenhaPage({Key? key, this.idUser}) : super(key: key);

  final int? idUser;

  @override
  _EditarSenhaPageState createState() => _EditarSenhaPageState();
}

class _EditarSenhaPageState extends State<EditarSenhaPage> {
  TextEditingController novaSenha = TextEditingController();
  TextEditingController confNovaSenha = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Alterar Senha'),
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
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: TextField(
                            controller: novaSenha,
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Nova senha'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: TextField(
                            controller: confNovaSenha,
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Confirmar nova senha'),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _salvar(widget.idUser, novaSenha.text,
                                  confNovaSenha.text);
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

  void _salvar(id, senha, confSenha) {
    var api = ApiUser();
    api.updatePassword(id, senha, confSenha).then((response) {
      if (response.statusCode == 200) {
        customMessageModal(context, 'Sucesso',
            'Sucesso ao alterar senha de usuario', 'Fechar');

        novaSenha.clear();
        confNovaSenha.clear();
      } else {
        customMessageModal(
            context, 'Erro', 'Erro ao alterar senha do usuario', 'Fechar');
      }
    });
  }
}
