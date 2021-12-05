import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hub/src/Api/api_user.dart';
import 'package:hub/src/Api/api_vendores.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:hub/src/View/ViewVendedor/minhas_formas_de_pagamento.dart';
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
  late final int? idUser;
  late final bool isVendedor;
  TextEditingController controller = TextEditingController();
  late User usuario;
  late bool isSellerAtivo;
  late bool isSellerOpen;

  Future<Map<String, dynamic>>? futureUser;

  @override
  void initState() {
    idUser = userData.idUser;
    isVendedor = userData.idVendedor != null && userData.idVendedor! > 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    futureUser = getUserData();

    return Scaffold(
        appBar:
            AppBar(title: const Text('Perfil'), backgroundColor: Colors.amber),
        body: FutureBuilder(
            future: futureUser,
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (isVendedor) {
                  usuario = User.fromJson(snapshot.data!["user"]);
                  isSellerAtivo = snapshot.data!["isAtivo"];
                  isSellerOpen = snapshot.data!["isOpen"];
                } else {
                  usuario = User.fromJson(snapshot.data!);
                }

                return SafeArea(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 50),
                      child: Column(
                        children: <Widget>[
                          Text('Nome ' + usuario.name),
                          Text('Email ' + usuario.email),
                          Text('GRR ' + usuario.grr),
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.phone, size: 20),
                                Text(usuario.telefone ?? "---------------"),
                              ]),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditarNomePage(
                                              usuario: usuario))).then(
                                      (v) async {
                                    var ret = await getUserData();
                                    User updated = isVendedor
                                        ? User.fromJson(ret["user"])
                                        : User.fromJson(ret);
                                    setState(() {
                                      usuario = updated;
                                    });
                                  });
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.center,
                                  color: const Color(0xFFFBC02D),
                                  child: const Text(
                                    "Editar Perfil",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                )),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: ElevatedButton(
                                  onPressed: () {
                                    final page =
                                        EditarSenhaPage(idUser: usuario.id);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => page));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    alignment: Alignment.center,
                                    color: const Color(0xFFFBC02D),
                                    child: const Text(
                                      "Editar Senha",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ))),
                          isVendedor
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MinhasFormasDePagamentoPage()));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            alignment: Alignment.center,
                                            color: const Color(0xFFFBC02D),
                                            child: const Text(
                                              "Formas de Pagamento",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            ),
                                          )),
                                    ),
                                    const Padding(padding: EdgeInsets.all(10)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Status da Minha Loja",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Switch(
                                          value: isSellerOpen,
                                          onChanged: (bool v) {
                                            updateStatus(isSellerAtivo, v);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.info_outline),
                                          onPressed: () {
                                            customMessageModal(
                                                context,
                                                "Status da Loja",
                                                "Outros usuários só podem ver seus produtos enquanto "
                                                    "sua loja estiver ‘Aberta’. Mude seu status "
                                                    "para ‘Fechada’ quando não estiver mais "
                                                    "vendendo nenhum produto no momento.",
                                                "Fechar");
                                          },
                                        )
                                      ],
                                    ),
                                    const Padding(padding: EdgeInsets.all(10)),
                                    ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(isSellerAtivo
                                                      ? 'Tem certeza que deseja inativar sua conta?'
                                                      : 'Tem certeza que deseja reativar sua conta?'),
                                                  content: Text(isSellerAtivo
                                                      ? 'Outros usuários não poderão ver seu perfil ou'
                                                          ' seus produtos caso você realize essa ação. '
                                                          'Você ainda poderá logar no Aplicativo e pode '
                                                          'ativar sua conta novamente quando desejar.'
                                                      : 'Outros usuários voltarão a visualizar seu perfil e seus produtos listados.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        updateStatus(
                                                            !isSellerAtivo,
                                                            isSellerOpen);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                          'Inativar'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                          'Cancelar'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          alignment: Alignment.center,
                                          color: const Color(0xFFFBC02D),
                                          child: Text(
                                            isSellerAtivo
                                                ? "Inativar minha conta"
                                                : "Reativar minha conta",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                        ))
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ));
              }
            }));
  }

  Future<Map<String, dynamic>> getUserData() async {
    if (isVendedor) {
      var api = ApiVendedores();
      return api.searchById(userData.idVendedor!);
    } else {
      var api = ApiUser();
      return api.searchId(idUser);
    }
  }

  void updateStatus(bool isAtivo, bool isOpen) async {
    var api = ApiVendedores();

    var response =
        await api.updateSellerStatus(userData.idVendedor!, isAtivo, isOpen);

    if (response.statusCode == 200) {
      setState(() {
        isSellerOpen = isOpen;
        isSellerAtivo = isAtivo;
      });
    } else {
      customMessageModal(context, "Erro",
          "Houve um erro ao atualizar o status: " + response.body, "Fechar");
    }
  }
}
