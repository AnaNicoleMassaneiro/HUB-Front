import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_vendores.dart';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/View/Class/vendedores.dart';
import 'package:hub/src/View/ViewCliente/detalhes_vendedor_page.dart';

import 'package:hub/src/util/contains_case_insensitive.dart';
import 'package:hub/src/util/hub_colors.dart';

class MeusFavoritosPage extends StatefulWidget {
  const MeusFavoritosPage({Key? key}) : super(key: key);

  @override
  _MeusFavoritosPageState createState() => _MeusFavoritosPageState();
}

class _MeusFavoritosPageState extends State<MeusFavoritosPage> {
  late final String texto;
  List<Vendedores> favoritos = [];
  TextEditingController controller = TextEditingController();
  final List<Vendedores> _searchResult = [];

  void buscaFavoritos() {
    var api = ApiVendedores();
    favoritos.clear();

    api.getFavorites(userData.idCliente!).then((response) {
      for (var vendedores in response) {
        favoritos.add(Vendedores.fromJson(vendedores));
      }
      setState(() {});
    }, onError: (error) async {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    buscaFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Meus Favoritos'),
          flexibleSpace: Container(
            decoration: hubColors.appBarGradient(),
          )),
      body: Column(
        children: [
          Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        hintText: 'Buscar favoritos', border: InputBorder.none),
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
          ]),
          favoritos.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Você ainda não adicionou vendedores aos seus favoritos.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ))
              : Expanded(
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
                                                          favoritos[i].id,
                                                    ))).then((value) {
                                          setState(() {
                                            buscaFavoritos();
                                            onSearchTextChanged(
                                                controller.text);
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
                          itemCount: favoritos.length,
                          itemBuilder: (context, i) {
                            return Card(
                              child: ListTile(
                                // leading:  CircleAvatar(backgroundImage:  NetworkImage(listaVendedores[index].profileUrl,),),
                                title: Text(favoritos[i].name),
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
                                                          favoritos[i].id,
                                                    ))).then((value) {
                                          setState(() {
                                            buscaFavoritos();
                                            onSearchTextChanged(
                                                controller.text);
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
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var userDetail in favoritos) {
      if (containsCaseInsensitive(userDetail.name, text)) {
        _searchResult.add(userDetail);
      }
    }

    setState(() {});
  }
}
