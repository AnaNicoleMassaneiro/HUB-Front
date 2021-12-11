import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/src/response.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/Api/api_rating.dart';
import 'package:hub/src/Api/api_vendores.dart';
import 'package:hub/src/View/Class/avaliacao.dart';
import 'package:hub/src/View/Class/forma_de_pagamento.dart';
import 'package:hub/src/View/Class/meus_produtos.dart';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/View/Class/vendedores.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:hub/src/util/hub_colors.dart';
import '../Components/entry_fields.dart';
import '../../../src/Validations/form_field_validations.dart';
import 'detalhes_produto_page.dart';

class DetalhesVendedorPage extends StatefulWidget {
  const DetalhesVendedorPage({Key? key, required this.idVendedor})
      : super(key: key);

  final int idVendedor;

  @override
  _DetalhesVendedorPageState createState() => _DetalhesVendedorPageState();
}

class _DetalhesVendedorPageState extends State<DetalhesVendedorPage> {
  late final String texto;
  late Vendedores vendedor;
  TextEditingController controller = TextEditingController();
  late List<MeusProdutos> produtos = <MeusProdutos>[];
  late List<FormaDePagamento> payment = <FormaDePagamento>[];
  bool isFavorite = false;

  late Future<List<Map<String, dynamic>>> futureProducts;
  late Future<Map<String, dynamic>> futureSeller;
  late Future<bool> futureIsFavorite;
  late Future<List<Map<String, dynamic>>> futurePayment;

  final _avaliaFormKey = GlobalKey<FormState>();

  final TextEditingController ratingTitle = TextEditingController();
  final TextEditingController ratingDescription = TextEditingController();
  int ratingValue = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    futureProducts = searchSellerProducts();
    futureSeller = getSeller();
    futureIsFavorite = isSellerFavorite();
    futurePayment = getPaymentModes();

    return Scaffold(
        appBar: AppBar(
            title: const Text('Detalhes do Vendedor'),
            flexibleSpace: Container(decoration: hubColors.appBarGradient())),
        body: SafeArea(
            child: FutureBuilder(
                future: Future.wait([
                  futureProducts,
                  futureSeller,
                  futureIsFavorite,
                  futurePayment
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    produtos.clear();
                    for (var p in snapshot.data![0]) {
                      produtos.add(MeusProdutos.fromJson(p));
                    }

                    vendedor = Vendedores.fromJson(snapshot.data![1]);
                    isFavorite = snapshot.data![2];

                    payment.clear();
                    for (var p in snapshot.data![3]) {
                      payment.add(FormaDePagamento.fromJson(p));
                    }

                    return pageBody();
                  }
                })));
    //child: pageBody()));
  }

  Widget pageBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Padding(padding: EdgeInsets.only(bottom: 25)),
        Text(
          vendedor.name.toString(),
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
        ),
        vendedor.telefone == null || vendedor.telefone!.isEmpty
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, size: 20, color: Colors.black54),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  Text(
                    vendedor.telefone!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w100, fontSize: 14),
                  ),
                ],
              ),
        const Padding(padding: EdgeInsets.only(bottom: 15)),
        payment.isEmpty
            ? Column()
            : Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Formas de pagamento aceitas: ",
                      style:
                          TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
                  const Padding(padding: EdgeInsets.only(bottom: 5)),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 180,
                            mainAxisSpacing: 5,
                            mainAxisExtent: 75),
                    shrinkWrap: true,
                    itemCount: payment.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                payment[i].icone,
                                height: 35,
                                fit: BoxFit.contain,
                              ),
                              Text(payment[i].descricao)
                            ]),
                      );
                    },
                    padding: const EdgeInsets.all(5),
                  ),
                ],
              ),
        const Text("Nota",
            style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
        GestureDetector(
          child: RatingBar.builder(
            initialRating: vendedor.noteApp == null
                ? 0
                : ((vendedor.noteApp! / 0.5).truncateToDouble()) / 2,
            direction: Axis.horizontal,
            ignoreGestures: true,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (double value) {},
          ),
          behavior: HitTestBehavior.opaque,
          onTap: () {
            openRatingsModal();
          },
        ),
        const Padding(padding: EdgeInsets.only(bottom: 25)),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        scrollable: true,
                        title: const Text("Avaliar Vendedor"),
                        content:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Form(
                            key: _avaliaFormKey,
                            child: Column(
                              children: [
                                RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (double value) {
                                    ratingValue = value.toInt();
                                  },
                                ),
                                entryFieldValidation(
                                    "Título", ratingTitle, validateRatingTitle,
                                    placeholder: ""),
                                textAreaEntryFieldValidation("Descrição",
                                    ratingDescription, validateRatingTitle, 8),
                              ],
                            ),
                          ),
                        ]),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ratingTitle.clear();
                              ratingDescription.clear();
                              ratingValue = 0;
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_avaliaFormKey.currentState!.validate()) {
                                insertRating();
                              }
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      )),
              child: Container(
                width: (MediaQuery.of(context).size.width - 100) / 2,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: const Text(
                  "Avaliar",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )),
          ElevatedButton(
              onPressed: () {
                addOrRemoveFromFavorites();
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 100) / 2,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: Text(
                  isFavorite ? "- Favoritos" : "+ Favoritos",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              )),
        ]),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        produtos.isNotEmpty
            ? const Text(
                "Produtos deste vendedor: ",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              )
            : const Text(
                "Este vendedor ainda não possui produtos cadastrados.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
              ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
        produtos.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      title: Text(produtos[i].nome),
                      trailing: Wrap(
                        spacing: 12,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetalhesProdutoPage(
                                          produto: produtos[i]))).then(
                                  (v) async {
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
              ))
            : Container(),
      ],
    );
  }

  Future<Map<String, dynamic>> getSeller() async {
    var api = ApiVendedores();

    return api.searchById(widget.idVendedor);
  }

  void insertRating() {
    var api = ApiRating();
    api
        .insertRating(0, userData.idCliente!, vendedor.id, ratingValue,
            ratingTitle.text, ratingDescription.text, 2)
        .then((response) {
      ratingDescription.text = "";
      ratingTitle.text = "";
      ratingValue = 0;

      if (response.statusCode != 200) {
        Navigator.of(context).pop();
        customMessageModal(context, "Erro", response.body, "Fechar");
      } else {
        Navigator.of(context).pop();
        customMessageModal(
            context,
            "Avaliação enviada!",
            "Sua avaliação foi enviada com sucesso. Agradecemos seu feedback!",
            "Fechar");
      }
    });
  }

  Future<List<Map<String, dynamic>>> searchSellerProducts() async {
    var api = api_product();
    produtos.clear();

    print("starting search vendedor page at " + DateTime.now().toString());
    return api.search(widget.idVendedor);
  }

  Future<List<Map<String, dynamic>>> getPaymentModes() async {
    var api = ApiVendedores();
    payment.clear();

    return api.getFormasDePagamentoBySeller(widget.idVendedor);
  }

  void openRatingsModal() async {
    var api = ApiRating();

    List<Avaliacao> ratings = [];

    var ret = await api.getSellerRatings(vendedor.id);

    for (var r in ret) {
      ratings.add(Avaliacao.fromJson(r));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text("Avaliações do Vendedor:"),
              content: SizedBox(
                height: 500,
                width: 300,
                child: ratings.isEmpty
                    ? const Text(
                        "Ainda não existem avaliações para este vendedor.")
                    : ListView.builder(
                        itemCount: ratings.length,
                        itemBuilder: (context, i) {
                          return Card(
                              child: Column(
                            children: [
                              Text(ratings[i].titulo),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10)),
                              RatingBar.builder(
                                initialRating:
                                    double.parse(ratings[i].nota.toString()),
                                direction: Axis.horizontal,
                                ignoreGestures: true,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (double value) {},
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10)),
                              Text(ratings[i].descricao),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5)),
                              Text("Por " +
                                  ratings[i].nome +
                                  ", em " +
                                  ratings[i].dataCriacao.day.toString() +
                                  "/" +
                                  ratings[i].dataCriacao.month.toString() +
                                  "/" +
                                  ratings[i].dataCriacao.year.toString() +
                                  " as " +
                                  ratings[i].dataCriacao.hour.toString() +
                                  ":" +
                                  ratings[i].dataCriacao.minute.toString())
                            ],
                          ));
                        },
                      ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar'),
                ),
              ],
            ));
  }

  Future<bool> isSellerFavorite() async {
    var api = ApiVendedores();

    return api.isFavorite(userData.idCliente!, widget.idVendedor);
  }

  void addOrRemoveFromFavorites() async {
    var api = ApiVendedores();

    Response response;

    if (isFavorite) {
      response =
          await api.removeFromFavorites(vendedor.id, userData.idCliente!);
    } else {
      response = await api.addToFavorites(vendedor.id, userData.idCliente!);
    }

    if (response.statusCode == 200) {
      setState(() {
        isFavorite = !isFavorite;
      });

      customMessageModal(
          context,
          "Sucesso",
          isFavorite
              ? "Vendedor adicionado aos favoritos."
              : "Vendedor removido dos favoritos.",
          "Fechar");
    } else {
      customMessageModal(context, "Ops, um erro ocorreu.",
          jsonDecode(response.body)["msg"], "Fechar");
    }
  }
}
