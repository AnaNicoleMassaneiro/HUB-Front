import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:hub/src/util/contains_case_insensitive.dart';
import 'package:hub/src/util/hub_colors.dart';
import '../Class/meus_produtos.dart';
import 'cadastrar_produto_page.dart';
import 'editar_produto_page.dart';

import '../Class/user_data.dart';

class MeusProdutosPage extends StatefulWidget {
  MeusProdutosPage({Key? key}) : super(key: key);
  final int idVendedor = userData.idVendedor!;
  final int idUser = userData.idUser!;

  @override
  _MeusProdutosPageState createState() => _MeusProdutosPageState();
}

class _MeusProdutosPageState extends State<MeusProdutosPage> {
  late final String texto;
  late List<MeusProdutos> listaProdutos = [];
  late Future<List<Map<String, dynamic>>> futureProdutos;
  bool _isLoading = false;

  TextEditingController controller = TextEditingController();
  final List<MeusProdutos> _searchResult = [];

  Future<List<Map<String, dynamic>>> buscaProdutos() {
    var api = api_product();

    return api.search(widget.idVendedor);
  }

  @override
  void initState() {
    super.initState();

    futureProdutos = buscaProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureProdutos,
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData && !_isLoading) {
          listaProdutos.clear();

          for (var p in snapshot.data!) {
            listaProdutos.add(MeusProdutos.fromJson(p));
          }

          if (controller.text.isNotEmpty) {
            _searchResult.clear();

            for (var userDetail in listaProdutos) {
              if (containsCaseInsensitive(
                  userDetail.nome, controller.text.trim())) {
                _searchResult.add(userDetail);
              }
            }
          } else {
            _searchResult.clear();
          }

          return meusProdutosPageBody();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget meusProdutosPageBody() {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CadastrarProdutoPage(
                        title: '',
                        idVendedor: widget.idVendedor,
                        idUser: widget.idUser))).then((value) async {
              setState(() => _isLoading = true);
              futureProdutos = buscaProdutos();

              for (var p in await futureProdutos) {
                listaProdutos.add(MeusProdutos.fromJson(p));
              }

              setState(() => _isLoading = false);
            });
          },
          child: const Icon(Icons.plus_one),
          backgroundColor: hubColors.primary,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        hintText: 'Buscar Produtos', border: InputBorder.none),
                    onChanged: (v) => setState(() {}),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      controller.clear();
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: listaProdutos.isEmpty ||
                      (controller.text.isNotEmpty && _searchResult.isEmpty)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Parece que não há nenhum produto por aqui...",
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontStyle: FontStyle.italic,
                            ))
                      ],
                    )
                  : _searchResult.isNotEmpty || controller.text.isNotEmpty
                      ? ListView.builder(
                          itemCount: _searchResult.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: ListTile(
                                title: Text(_searchResult[i].nome),
                                trailing: Wrap(
                                  spacing: 12,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.remove_red_eye_rounded),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditarProdutoPage(
                                                      produto: _searchResult[i],
                                                    ))).then((value) async {
                                          setState(() => _isLoading = true);
                                          futureProdutos = buscaProdutos();

                                          for (var p in await futureProdutos) {
                                            listaProdutos.add(MeusProdutos.fromJson(p));
                                          }

                                          setState(() => _isLoading = false);
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        verificaDeletarProduto(
                                            _searchResult[i].id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              margin: const EdgeInsets.all(0.0),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: listaProdutos.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: ListTile(
                                // leading:  CircleAvatar(backgroundImage:  NetworkImage(listaProdutos[index].profileUrl,),),
                                title: Text(listaProdutos[i].nome),
                                trailing: Wrap(
                                  spacing: 12,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          Icons.remove_red_eye_rounded),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditarProdutoPage(
                                                        produto: listaProdutos[
                                                            i]))).then((value) async {
                                          setState(() => _isLoading = true);
                                          futureProdutos = buscaProdutos();

                                          for (var p in await futureProdutos) {
                                            listaProdutos.add(MeusProdutos.fromJson(p));
                                          }

                                          setState(() => _isLoading = false);
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        verificaDeletarProduto(
                                            listaProdutos[i].id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              margin: const EdgeInsets.all(0.0),
                            );
                          },
                        ),
            ),
          ],
        ));
  }

  verificaDeletarProduto(int? id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Excluir Produto"),
          content: const Text("Tem certeza que deseja excluir este produto?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Sim"),
              onPressed: () {
                deletarProduto(id);
                Navigator.of(context).pop();
                setState(() => _isLoading = true);
              },
            ),
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deletarProduto(id) async {
    var api = api_product();
    var ret = await api.delete(id);

    if (ret.statusCode == 200) {
      futureProdutos = buscaProdutos();

      for (var p in await futureProdutos) {
        listaProdutos.add(MeusProdutos.fromJson(p));
      }

      setState(() {
        _isLoading = false;
        customMessageModal(
            context, "Sucesso!", "Produto excluido com sucesso", "OK");
      });
    } else if (ret.statusCode == 409) {
      setState(() => _isLoading = false);
      customMessageModal(
          context,
          "Falha ao excluir produto: ",
          "Este produto já está presente em reservas e/ou avaliações. "
              "Não é mais possível deletá-lo. Você pode inativá-lo se não "
              "quiser que outros usuários possam vê-lo.",
          "Fechar");
    } else {
      setState(() => _isLoading = false);
      customMessageModal(context, "Falha ao excluir produto: ",
          jsonDecode(ret.body)["msg"], "Fechar");
    }
  }
}
