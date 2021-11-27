import 'package:flutter/material.dart';
import 'package:hub/src/View/Class/meus_produtos.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import '../Components/entry_fields.dart';
import '../../Api/api_reservations.dart';
import '../Class/user_data.dart';


class CreateReserva extends StatefulWidget {
  const CreateReserva ({Key? key, required this.produto}) : super(key: key);
  final String title = 'Confirmar Reserva';
  final MeusProdutos produto;

  @override
  _CreateReservaPageState createState() => _CreateReservaPageState();
}

class _CreateReservaPageState extends State<CreateReserva> {
  final TextEditingController quantidade = TextEditingController();

  final _reservaFormKey = GlobalKey<FormState>();

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_reservaFormKey.currentState!.validate()) {
          confirmReservation(context);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: const Text(
          'Confirmar Reserva',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _quantidadeWidget() {
    return Column(
      children: <Widget>[
        entryFieldValidation("Quantidade", quantidade, validateQuantidade,
            placeholder: 'Disponível: ' + widget.produto.quantidadeDisponivel.toString(),
            keyboard: TextInputType.number),
      ],
    );
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
                    colors: [Color(0xFF915FB5), Color(0xFFCA436B)]),
              ),
            )
        ),
        body: SizedBox(
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 50),
                      Form(key: _reservaFormKey, child: (_quantidadeWidget())),
                      _submitButton(),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: const Text('Esqueceu a senha?',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  String? validateQuantidade(String text){
    try {
      double qt = double.parse(text);

      if (qt <= 0 || text.trim.toString() == "") {
        return "Preencha a quantidade desejada";
      } else if (qt > widget.produto.quantidadeDisponivel) {
        return "Quantidade disponível insuficiente.";
      }
      else {
        return null;
      }
    }
    catch (ex) {
      return "Preencha a quantidade desejada!";
    }
  }

  void confirmReservation(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Tem certeza que deseja reservar esse produto?'),
            content: const Text(
              'Isso fará com que o Vendedor entenda que você está a caminho para '
              'comprá-lo.\nSua reserva é automaticamente cancelada após 45 minutos, '
              'portanto esteja atento à localização do vendedor '
              'e às formas de pagamento aceitas por ele.\nDeseja confirmar sua reserva?'
            ),
            actions: [
              TextButton(
                onPressed: () {
                  createReservation(
                      userData.idCliente!,
                      widget.produto.id,
                      int.tryParse(quantidade.text)!,
                      userData.curLocationLat!,
                      userData.curLocationLon!
                  );
                },
                child: const Text('Sim'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Não'),
              ),
            ],
          );
        }
    );
  }

  void createReservation(int idCliente, int idProduto, int quantidade,
      double lat, double lon) {

    var api = ApiReservations();

    api.create(idCliente, idProduto, quantidade, lat, lon)
      .then((response) {
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        customMessageModal(
            context,
            "Reserva criada com sucesso",
            "Sua reserva foi criada com sucesso e o vendedor foi notificado.",
            "Fechar"
        );
      }
      else {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);

        customMessageModal(
            context,
            "Um erro ocorreu",
            "Houve um erro ao criar sua reserva. Tente novamente mais tarde",
            "Fechar"
        );
      }
    });
  }
}
