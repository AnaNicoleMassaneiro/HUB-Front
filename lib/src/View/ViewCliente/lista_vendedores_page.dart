import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/Api/api_vendores.dart';
import 'package:hub/src/View/Class/vendedores.dart';
import 'package:hub/src/View/Components/modal_message.dart';

import 'package:hub/src/util/contains_case_insensitive.dart';

class ListaVendedoresPage extends StatefulWidget {
  const ListaVendedoresPage({Key? key}) : super(key: key);

  @override
  _ListaVendedoresPageState createState() => _ListaVendedoresPageState();
}

class _ListaVendedoresPageState extends State<ListaVendedoresPage> {
  late final String  texto;
  List<Vendedores> listaVendedores = [];
  TextEditingController controller = TextEditingController();
  final List<Vendedores> _searchResult = [];

  void buscavendedores() {
    var api = ApiVendedores();
    Map<String, dynamic> indexedData = {};

    api.searchAll().then((response) {
      for (var vendedores in response) {
        listaVendedores.add(Vendedores.fromJson(vendedores));
      }
      setState(() {});
    }, onError: (error) async {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    buscavendedores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Buscar Produto'),
            backgroundColor: Colors.orange),
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
                              hintText: 'Buscar vendedores',
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
                    child:
                        _searchResult.isNotEmpty || controller.text.isNotEmpty
                            ? ListView.builder(
                                itemCount: _searchResult.length,
                                itemBuilder: (context, i) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(_searchResult[i].name),
                                    ),
                                    margin: const EdgeInsets.all(0.0),
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: listaVendedores.length,
                                itemBuilder: (context, i) {
                                  return Card(
                                    child: ListTile(
                                      // leading:  CircleAvatar(backgroundImage:  NetworkImage(listaVendedores[index].profileUrl,),),
                                      title: Text(listaVendedores[i].name),
                                      trailing: Wrap(
                                        spacing: 12,
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

    listaVendedores.forEach((userDetail) {
      if (containsCaseInsensitive(userDetail.name, text)) _searchResult.add(userDetail);
    });

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
        listaVendedores.clear();
        buscavendedores();
      });
      customMessageModal(
          context, "Sucesso!", "Produto excluido com sucesso", "OK");
    } else {
      customMessageModal(context, "Falha ao cadastrar produto: ",
          jsonDecode(ret.body)["msg"], "Fechar");
    }
  }
}
