import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:hub/src/Api/api_user.dart';
import 'package:hub/src/Api/api_vendores.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:hub/src/View/ViewVendedor/minhas_formas_de_pagamento.dart';
import 'package:hub/src/View/editar_senha_page.dart';
import 'package:hub/src/util/hub_colors.dart';
import '../View/Class/user_data.dart';
import 'Class/User.dart';
import 'editar_nome_page.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  TextEditingController controller = TextEditingController();
  late User usuario;
  late bool isSellerAtivo;
  late bool isSellerOpen;

  Future<Map<String, dynamic>>? futureUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    futureUser = getUserData();

    return Scaffold(
        appBar: AppBar(
            title: Text('Perfil', style: TextStyle(color: hubColors.dark)),
            flexibleSpace: Container(
              decoration: hubColors.appBarGradient(),
            )),
        body: FutureBuilder(
            future: futureUser,
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (userData.isVendedor!) {
                  usuario = User.fromJson(snapshot.data!["user"]);
                  isSellerAtivo = snapshot.data!["isAtivo"];
                  isSellerOpen = snapshot.data!["isOpen"];
                } else {
                  usuario = User.fromJson(snapshot.data!);
                }

                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    child: Column(
                      children: [
                        userData.isVendedor!
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        isSellerOpen
                                          ? "Status da Minha Loja (Aberta)"
                                          : "Status da Minha Loja (Fechada)",
                                        style: const TextStyle(
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
                                                  "sua loja estiver \"Aberta\". Mude seu status "
                                                  "para \"Fechada\" quando não estiver mais "
                                                  "vendendo nenhum produto no momento.",
                                              "Fechar");
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)
                        ),
                        Text(
                          usuario.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20
                          ),
                        ),
                        Text(usuario.email, style: profileDetails()),
                        Text("GRR" + usuario.grr, style: profileDetails()),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.phone, size: 20),
                              Text(
                                usuario.telefone == null ||
                                        usuario.telefone!.trim().isEmpty
                                    ? "---------------"
                                    : usuario.telefone!,
                                style: profileDetails(),
                              ),
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditarNomePage(
                                            usuario: usuario))).then((v) async {
                                  var ret = await getUserData();
                                  User updated = userData.isVendedor!
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
                                child: Text(
                                  "Editar Perfil",
                                  style: TextStyle(
                                      fontSize: 20, color: hubColors.dark),
                                ),
                              )),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Editar Senha",
                                    style: TextStyle(
                                        fontSize: 20, color: hubColors.dark),
                                  ),
                                ))),
                        userData.isVendedor!
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MinhasFormasDePagamentoPage()));
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Formas de Pagamento",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: hubColors.dark),
                                          ),
                                        )),
                                  ),
                                  const Padding(padding: EdgeInsets.all(20)),
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
                                                    child: Text(isSellerAtivo
                                                        ? 'Inativar'
                                                        : 'Reativar'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child:
                                                        const Text('Cancelar'),
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
                                        child: Text(
                                          isSellerAtivo
                                              ? "Inativar minha conta"
                                              : "Reativar minha conta",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: hubColors.dark),
                                        ),
                                      ))
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  Future<Map<String, dynamic>> getUserData() async {
    if (userData.isVendedor!) {
      var api = ApiVendedores();
      return api.searchById(userData.idVendedor!);
    } else {
      var api = ApiUser();
      return api.searchId(userData.idUser);
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

  TextStyle profileDetails() {
    return const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w100, fontStyle: FontStyle.italic);
  }
}
