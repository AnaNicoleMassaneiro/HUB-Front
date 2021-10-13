import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_search_produto.dart';
import 'Class/meus_produtos.dart';

class MeusProdutosPage extends StatefulWidget {
  const MeusProdutosPage({Key? key}) : super(key: key);

  @override
  _MeusProdutosPageState createState() => _MeusProdutosPageState();
}

class _MeusProdutosPageState extends State<MeusProdutosPage> {
  late final String texto;
  final List<MeusProdutos> listaProdutos = [];
  TextEditingController controller = TextEditingController();

  void buscaProdutos() {
    var api = api_search_produto();
    api.search(1, 6, "aaaaaa").then((response) {
      setState(() {
        if (response.statusCode == 200) {
          final trataDados = json.decode(response.body);

          print('------------');
          setState(() {
            for (Map user in trataDados) {
              // ignore: avoid_print
              print(user.values);
              // listaProdutos.add(user.values);
            }
          });
        }
      });
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
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                      hintText: 'Buscar Produtos', border: InputBorder.none),
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
        ),
        Expanded(
            child: ListView.builder(
          itemCount: listaProdutos.length,
          itemBuilder: (context, i) {
            return Card(
              child: ListTile(
                title: Text(listaProdutos[i].nome),
              ),
              margin: const EdgeInsets.all(0.0),
            );
          },
        )),
      ],
    );
  }

  onSearchTextChanged(String text) async {}
}
