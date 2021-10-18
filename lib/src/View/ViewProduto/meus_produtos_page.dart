import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import '../Class/meus_produtos.dart';
import 'cadastrar_produto_page.dart';

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
            child: ListView.builder(
          itemCount: listaProdutos.length,
          itemBuilder: (context, i) {
            return Card(
              child: ListTile(
                title: Text(listaProdutos[i].nome),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CadastrarProdutoPage(
                                title: '',
                                idVendedor: widget.idVendedor,
                                idUser: widget.idUser)));
                  },
                ),
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
