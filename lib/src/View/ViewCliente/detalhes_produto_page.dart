import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hub/src/Api/api_rating.dart';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import '../Class/meus_produtos.dart';
import '../ViewReserva/create_reserva.dart';
import '../Components/entry_fields.dart';
import '../../../src/Validations/form_field_validations.dart';


class DetalhesProdutoPage extends StatefulWidget {
  DetalhesProdutoPage({Key? key, required this.produto})
      : super(key: key);

  MeusProdutos produto;

  @override
  _DetalhesProdutoPageState createState() => _DetalhesProdutoPageState();
}

class _DetalhesProdutoPageState extends State<DetalhesProdutoPage> {
  late final String texto;
  TextEditingController controller = TextEditingController();

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
    return Scaffold(
        appBar: AppBar(
            title: const Text('Detalhes do Produto'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFBC02D), Color(0xFFFBC02D)]),
              ),
            )
        ),
        body: SafeArea(
          child: ListView(
            children: [
              header(),
            ],
          ),
        ));
  }

  Widget header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.produto.imagem == null ?
                Image.asset("assets/product-icon.png", height: 250, fit: BoxFit.contain) :
                Image.memory(widget.produto.imagem!, height: 250, fit: BoxFit.contain)
              ,
              const Text("Produto",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              Text(widget.produto.nome.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24)),
              const Text("Nota",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              RatingBar.builder(
                initialRating: widget.produto.nota == null
                  ? 0
                  : ((widget.produto.nota!/0.5).truncateToDouble()) / 2
                ,
                direction: Axis.horizontal,
                ignoreGestures: true,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.black,
                ),
                onRatingUpdate: (double value) {},
              ),
              const Text("Preço",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              Text('R\$ ' + widget.produto.preco.toString().replaceAll(".", ","),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24)),
              const Text("Quantidade disponível",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              Text(widget.produto.quantidadeDisponivel.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24)),
              const Text("Descrição",
                  style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16)),
              Text(widget.produto.descricao.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 24)),
              ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Avaliar Produto"),
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
                                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  ),
                                  onRatingUpdate: (double value) {
                                    ratingValue = value.toInt();
                                  },
                                ),
                                entryFieldValidation(
                                  "Título",
                                  ratingTitle,
                                  validateRatingTitle,
                                  placeholder: ""
                                ),
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
                            if (_avaliaFormKey.currentState!.validate()){
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
                  )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          CreateReserva(produto: widget.produto)
                      ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    child: const Text(
                      "Reservar Produto",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  void insertRating() {
    var api = ApiRating();
    api.insertRating(
      widget.produto.id,
      userData.idCliente!,
      0,
      ratingValue,
      ratingTitle.text,
      ratingDescription.text,
      1
    ).then((response) {
      ratingDescription.text = "";
      ratingTitle.text = "";
      ratingValue = 0;

      if (response.statusCode != 200){
        Navigator.of(context).pop();
        customMessageModal(context, "Erro", response.body, "Fechar");
      }
      else {
        Navigator.of(context).pop();
        customMessageModal(
          context,
          "Avaliação enviada!",
          "Sua avaliação foi enviada com sucesso. Agradecemos seu feedback!",
          "Fechar"
        );
      }
    });
  }
}
