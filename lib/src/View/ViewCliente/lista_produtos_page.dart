import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import '../Class/meus_produtos.dart';

class ListaProdutosPage extends StatefulWidget {
  const ListaProdutosPage({Key? key}) : super(key: key);

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  late final String texto;
  List<MeusProdutos> listaProdutos = [];
  TextEditingController controller = TextEditingController();
  List<MeusProdutos> _searchResult = [];

  void buscaProdutos() {
    var api = api_product();
    /*  api.search(widget.idVendedor, 0, null).then((response) {
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
    }); */
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
