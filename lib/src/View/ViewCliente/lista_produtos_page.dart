import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/util/contains_case_insensitive.dart';
import 'package:hub/src/util/hub_colors.dart';
import '../Class/meus_produtos.dart';
import 'detalhes_produto_page.dart';

class ListaProdutosPage extends StatefulWidget {
  const ListaProdutosPage({Key? key}) : super(key: key);

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  late final String texto;
  late List<MeusProdutos> listaProdutos = [];
  late Future<List<Map<String, dynamic>>> futureProdutos;
  TextEditingController controller = TextEditingController();
  final List<MeusProdutos> _searchResult = [];

  Future<List<Map<String, dynamic>>> buscaProdutos() async {
    var api = api_product();

    return api.searchAll();
  }

  @override
  void initState() {
    super.initState();

    futureProdutos = buscaProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Buscar Produtos'),
          flexibleSpace: Container(decoration: hubColors.appBarGradient()),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: futureProdutos,
            builder:
                (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                listaProdutos.clear();

                for (var produto in snapshot.data!) {
                  listaProdutos.add(MeusProdutos.fromJson(produto));
                }

                _searchResult.clear();
                if (controller.text.trim().isNotEmpty) {
                  for (var product in listaProdutos) {
                    if (containsCaseInsensitive(
                        product.nome, controller.text.trim())) {
                      _searchResult.add(product);
                    }
                  }
                }

                return SizedBox(
                  child: Stack(
                    children: <Widget>[
                      pageBody(),
                    ],
                  ),
                );
              }
            },
          ),
        ));
  }

  Widget pageBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.search),
              title: TextField(
                controller: controller,
                decoration: const InputDecoration(
                    hintText: 'Buscar Produtos', border: InputBorder.none),
                onChanged: (v) {
                  setState(() {});
                },
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
                                                  idProduto:
                                                      _searchResult[i].id,
                                                ))).then((value) async {
                                      futureProdutos = buscaProdutos();

                                      for (var p in await futureProdutos) {
                                        listaProdutos
                                            .add(MeusProdutos.fromJson(p));
                                      }

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
                                                  idProduto:
                                                      listaProdutos[i].id,
                                                ))).then((value) async {
                                      futureProdutos = buscaProdutos();

                                      for (var p in await futureProdutos) {
                                        listaProdutos
                                            .add(MeusProdutos.fromJson(p));
                                      }

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
    );
  }
}
