import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/Api/api_rating.dart';
import 'package:hub/src/Api/api_vendores.dart';
import 'package:hub/src/View/Class/avaliacao.dart';
import 'package:hub/src/View/Class/forma_de_pagamento.dart';
import 'package:hub/src/View/Class/meus_produtos.dart';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/View/Class/vendedores.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import '../Components/entry_fields.dart';
import '../../../src/Validations/form_field_validations.dart';
import 'detalhes_produto_page.dart';

class DetalhesVendedorPage extends StatefulWidget {
  DetalhesVendedorPage({Key? key, required this.vendedor}) : super(key: key);

  Vendedores vendedor;

  @override
  _DetalhesVendedorPageState createState() => _DetalhesVendedorPageState();
}

class _DetalhesVendedorPageState extends State<DetalhesVendedorPage> {
  late final String texto;
  TextEditingController controller = TextEditingController();
  List<MeusProdutos> produtos = <MeusProdutos>[];
  List<FormaDePagamento> payment = <FormaDePagamento>[];

  final _avaliaFormKey = GlobalKey<FormState>();

  final TextEditingController ratingTitle = TextEditingController();
  final TextEditingController ratingDescription = TextEditingController();
  int ratingValue = 0;

  @override
  void initState() {
    super.initState();
    searchSellerProducts();
    getPaymentModes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Vendedor'),
        backgroundColor: Colors.orange
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(padding: EdgeInsets.only(bottom: 25)),
            Text(
              widget.vendedor.name.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 24
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 25)
            ),
            payment.isEmpty
            ? Column()
            : Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Formas de pagamento aceitas: ",
                    style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)
                ),
                const Padding(
                    padding: EdgeInsets.only(bottom: 5)
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 180,
                    mainAxisSpacing: 5,
                    mainAxisExtent: 75
                  ),
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
                          Text(
                            payment[i].descricao
                          )
                        ]
                      ),
                    );
                  },
                  padding: const EdgeInsets.all(5),
                ),
              ],
            ),
            const Text("Nota",
              style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)
            ),
            GestureDetector(
              child: RatingBar.builder(
                initialRating: widget.vendedor.noteApp == null
                  ? 0
                  : ((widget.vendedor.noteApp! / 0.5).truncateToDouble()) / 2,
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
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Avaliar Vendedor"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) =>
                                    const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (double value) {
                                  ratingValue = value.toInt();
                                },
                              ),
                              entryFieldValidation("Título",
                                ratingTitle, validateRatingTitle,
                                placeholder: ""),
                              textAreaEntryFieldValidation(
                                "Descrição",
                                ratingDescription,
                                validateRatingTitle,
                                8
                              ),
                            ],
                          ),
                        ),
                      ]
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
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
                  )
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  child: const Text(
                    "Avaliar",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
              const Text(
                "Produtos deste vendedor: ",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Expanded(
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
                                      produto: produtos[i]
                                    )
                                  )
                                ).then((value) {
                                  setState(() {
                                    searchSellerProducts();
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
                )
              ),
          ],
        ),
      )
    );
  }

  void insertRating() {
    var api = ApiRating();
    api
        .insertRating(0, userData.idCliente!, widget.vendedor.id, ratingValue,
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

  void searchSellerProducts() {
    var api = api_product();

    produtos.clear();

    api.search(widget.vendedor.id).then((response) {
      for (var p in response) {
        setState(() {
          produtos.add(MeusProdutos.fromJson(p));
        });
      }
    });
  }

  void getPaymentModes(){
    var api = ApiVendedores();


    print("HERE");
    api.getFormasDePagamentoBySeller(widget.vendedor.id).then((response) {
      for (var f in response){
        print(f["descricao"]);
        payment.add(FormaDePagamento.fromJson(f));
      }
    });
  }

  void openRatingsModal() async {
    var api = ApiRating();

    List<Avaliacao> ratings = [];

    var ret = await api.getSellerRatings(widget.vendedor.id);

    for (var r in ret){
      ratings.add(Avaliacao.fromJson(r));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) =>  AlertDialog(
          title: const Text("Avaliações do Vendedor:"),
          content: SizedBox(
            height: 500,
            width: 300,
            child:
            ratings.isEmpty
                ? const Text(
                "Ainda não existem avaliações para este vendedor."
            )
                : ListView.builder(
              itemCount: ratings.length,
              itemBuilder: (context, i) {
                return Card(
                    child: Column(
                      children: [
                        Text(ratings[i].titulo),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)
                        ),
                        RatingBar.builder(
                          initialRating: double.parse(ratings[i].nota.toString()),
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
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)
                        ),
                        Text(ratings[i].descricao),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5)
                        ),
                        Text(
                          "Por " +
                            ratings[i].nome +
                            ", em " +
                            ratings[i].dataCriacao.day.toString() + "/" +
                            ratings[i].dataCriacao.month.toString() + "/" +
                            ratings[i].dataCriacao.year.toString() + " as " +
                            ratings[i].dataCriacao.hour.toString() + ":" +
                            ratings[i].dataCriacao.minute.toString()
                        )
                      ],
                    )
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            ),
          ],
        )
    );
  }
}
