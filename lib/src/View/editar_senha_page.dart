import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_user.dart';
import 'package:hub/src/Validations/form_field_validations.dart';
import 'package:hub/src/util/hub_colors.dart';

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
  final _formKey = GlobalKey<FormState>();

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
              decoration: hubColors.appBarGradient(),
            )),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Column(
                  children: <Widget>[
                    Form(key: _formKey, child: updateSenhaForm()),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _salvar(widget.idUser, novaSenha.text,
                                      confNovaSenha.text);
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                color: const Color(0xFFFBC02D),
                                child: const Text(
                                  "Salvar",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget updateSenhaForm() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: TextFormField(
            validator: (value) {
              var ret = validatePassword(value!);
              if (ret != null) {
                return ret;
              } else {
                if (confNovaSenha.text.trim().isEmpty) {
                  return null;
                }
                if (value.compareTo(confNovaSenha.text) == 0) {
                  return null;
                } else {
                  return "Senhas não coincidem!";
                }
              }
            },
            controller: novaSenha,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Nova senha'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: TextFormField(
            validator: (value) => validatePassword(value!),
            controller: confNovaSenha,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Confirmar nova senha'),
          ),
        )
      ],
    );
  }

  void _salvar(id, senha, confSenha) {
    var api = ApiUser();
    api.updatePassword(id, senha, confSenha).then((response) {
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        customMessageModal(
            context, 'Sucesso', 'Senha alterada com sucesso!', 'Fechar');

        novaSenha.clear();
        confNovaSenha.clear();
      } else {
        customMessageModal(
            context,
            'Erro',
            'Ocorreu um erro ao alterar a senha do usuario: ' + response.body,
            'Fechar');
      }
    });
  }
}
