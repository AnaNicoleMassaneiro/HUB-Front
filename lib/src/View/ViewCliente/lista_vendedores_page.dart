import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_vendores.dart';
import 'package:hub/src/View/Class/vendedores.dart';
import 'package:hub/src/View/ViewCliente/detalhes_vendedor_page.dart';

import 'package:hub/src/util/contains_case_insensitive.dart';
import 'package:hub/src/util/hub_colors.dart';

class ListaVendedoresPage extends StatefulWidget {
  const ListaVendedoresPage({Key? key}) : super(key: key);

  @override
  _ListaVendedoresPageState createState() => _ListaVendedoresPageState();
}

class _ListaVendedoresPageState extends State<ListaVendedoresPage> {
  late final String texto;
  late List<Vendedores> listaVendedores = [];
  late Future<List<Map<String, dynamic>>> futureVendedores;
  TextEditingController controller = TextEditingController();
  final List<Vendedores> _searchResult = [];

  Future<List<Map<String, dynamic>>> buscavendedores() {
    var api = ApiVendedores();
    listaVendedores.clear();

    return api.searchAll();
  }

  @override
  void initState() {
    super.initState();

    futureVendedores = buscavendedores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Buscar Vendedores'),
          flexibleSpace: Container(
            decoration: hubColors.appBarGradient(),
          )),
      body: FutureBuilder(
        future: futureVendedores,
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            listaVendedores.clear();

            for (var v in snapshot.data!) {
              listaVendedores.add(Vendedores.fromJson(v));
            }

            _searchResult.clear();
            if (controller.text.trim().isNotEmpty) {
              for (var v in listaVendedores) {
                if (containsCaseInsensitive(v.name, controller.text.trim())) {
                  _searchResult.add(v);
                }
              }
            }

            return pageBody();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget pageBody() {
    return SizedBox(
      child: Column(
        children: <Widget>[
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        hintText: 'Buscar Vendedores',
                        border: InputBorder.none),
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
          ]),
          Expanded(
            child: _searchResult.isNotEmpty || controller.text.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResult.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: ListTile(
                          title: Text(_searchResult[i].name),
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
                                              DetalhesVendedorPage(
                                                idVendedor:
                                                    listaVendedores[i].id,
                                              ))).then((value) async {
                                    futureVendedores = buscavendedores();
                                    setState(() {});
                                  });
                                },
                              )
                            ],
                          ),
                        ),
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
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetalhesVendedorPage(
                                                idVendedor:
                                                    listaVendedores[i].id,
                                              ))).then((value) async {
                                    futureVendedores = buscavendedores();
                                    setState(() {});
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
    );
  }
}
