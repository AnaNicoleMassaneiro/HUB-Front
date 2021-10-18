import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import '../Class/meus_produtos.dart';
import 'cadastrar_produto_page.dart';
import 'editar_produto_page.dart';

class MeusProdutosPage extends StatefulWidget {
  const MeusProdutosPage({Key? key, required this.idVendedor, this.idUser})
      : super(key: key);
  final int idVendedor;
  final int? idUser;

  @override
  _MeusProdutosPageState createState() => _MeusProdutosPageState();
}

class _MeusProdutosPageState extends State<MeusProdutosPage> {
  late final String texto;
  List<MeusProdutos> listaProdutos = [];
  TextEditingController controller = TextEditingController();
  List<MeusProdutos> _searchResult = [];

  void buscaProdutos() {
    var api = api_product();
    api.search(widget.idVendedor, 0, null).then((response) {
      for (var produto in response) {
        setState(() {
          listaProdutos.add(MeusProdutos(
              id: produto["id"],
              nome: produto["nome"],
              descricao: produto["descricao"],
              isAtivo: produto["isAtivo"],
              preco: double.parse(produto["preco"].toString()),
              quantidadeDisponivel: produto["quantidadeDisponivel"]));
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
    return Column(
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
          child: _searchResult.isNotEmpty || controller.text.isNotEmpty
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
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditarProdutoPage(
                                            title: '',
                                            idVendedor: widget.idVendedor,
                                            idUser: widget.idUser,
                                            nome: listaProdutos[i].nome,
                                            qtdDisponivel: listaProdutos[i]
                                                .quantidadeDisponivel,
                                            preco: listaProdutos[i].preco,
                                            descricao:
                                                listaProdutos[i].descricao)));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                verificaDeletarProduto(listaProdutos[i].id);
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
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditarProdutoPage(
                                            title: '',
                                            idVendedor: widget.idVendedor,
                                            idUser: widget.idUser,
                                            nome: listaProdutos[i].nome,
                                            qtdDisponivel: listaProdutos[i]
                                                .quantidadeDisponivel,
                                            preco: listaProdutos[i].preco,
                                            descricao:
                                                listaProdutos[i].descricao)));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                verificaDeletarProduto(listaProdutos[i].id);
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
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    listaProdutos.forEach((userDetail) {
      if (userDetail.nome.contains(text)) _searchResult.add(userDetail);
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
