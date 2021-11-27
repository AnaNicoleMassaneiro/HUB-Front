import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import '../Class/meus_produtos.dart';
import 'detalhes_produto_page.dart';

class ListaProdutosPage extends StatefulWidget {
  const ListaProdutosPage({Key? key}) : super(key: key);

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  late final String texto;
  List<MeusProdutos> listaProdutos = [];
  TextEditingController controller = TextEditingController();
  final List<MeusProdutos> _searchResult = [];

  void buscaProdutos() {
    var api = api_product();
    api.searchAll().then((response) {
      listaProdutos.clear();

      for (var produto in response) {
        setState(() {
          listaProdutos.add(MeusProdutos.fromJson(produto));
        });
      }
    }, onError: (error) async {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    buscaProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Buscar Produto'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF915FB5), Color(0xFFCA436B)]),
          ),
        )
      ),
        body: SizedBox(
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.search),
                        title: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                              hintText: 'Buscar Produtos',
                              border: InputBorder.none),
                          onChanged: onSearchTextChanged,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            controller.clear();
                            onSearchTextChanged('');
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: listaProdutos.isEmpty || (controller.text.isNotEmpty && _searchResult.isEmpty)
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Parece que não há nenhum produto por aqui...",
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontStyle: FontStyle.italic,
                            )
                          )
                        ],
                      )
                      : _searchResult.isNotEmpty || controller.text.isNotEmpty
                        ? ListView.builder(
                          itemCount: _searchResult.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: ListTile(
                                // leading:  CircleAvatar(backgroundImage:  NetworkImage(listaProdutos[index].profileUrl,),),
                                title: Text(_searchResult[i].nome),
                                trailing: Wrap(
                                  spacing: 12,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                              DetalhesProdutoPage(
                                                produto: _searchResult[i],
                                              )
                                          )
                                        ).then((value) {
                                          setState(() {
                                            buscaProdutos();
                                            onSearchTextChanged(controller.text);
                                          });
                                        });
                                      },
                                    )
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
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                              DetalhesProdutoPage(
                                                produto: listaProdutos[i],
                                              )
                                          )
                                        ).then((value) {
                                          setState(() {
                                            buscaProdutos();
                                          });
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                              margin: const EdgeInsets.all(0.0),
                            );
                          },
                        ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var userDetail in listaProdutos) {
      if (userDetail.nome.contains(text)) _searchResult.add(userDetail);
    }

    setState(() {});
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
      setState(() {
        listaProdutos.clear();
        buscaProdutos();
      });
      customMessageModal(
          context, "Sucesso!", "Produto excluido com sucesso", "OK");
    } else {
      customMessageModal(context, "Falha ao cadastrar produto: ",
          jsonDecode(ret.body)["msg"], "Fechar");
    }
  }
}
