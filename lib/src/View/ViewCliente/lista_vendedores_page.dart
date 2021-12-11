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
  late final String  texto;
  List<Vendedores> listaVendedores = [];
  TextEditingController controller = TextEditingController();
  final List<Vendedores> _searchResult = [];

  void buscavendedores() {
    var api = ApiVendedores();
    listaVendedores.clear();

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
            title: const Text('Buscar Vendedores'),
            flexibleSpace: Container(
              decoration: hubColors.appBarGradient(),
            )
        ),
        body: SizedBox(
          child: Column(
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
                              hintText: 'Buscar Vendedores',
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
                ]
              ),
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
                                          idVendedor: listaVendedores[i].id,
                                        )
                                    )
                                  ).then((value) {
                                    setState(() {
                                      buscavendedores();
                                      onSearchTextChanged(controller.text);
                                    });
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
                                          idVendedor: listaVendedores[i].id,
                                        )
                                    )
                                  ).then((value) {
                                    setState(() {
                                      buscavendedores();
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
                  ),
                ),
              ],
            ),
        ),
      );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var userDetail in listaVendedores) {
      if (containsCaseInsensitive(userDetail.name, text)) {
        _searchResult.add(userDetail);
      }
    }

    setState(() {});
  }
}
