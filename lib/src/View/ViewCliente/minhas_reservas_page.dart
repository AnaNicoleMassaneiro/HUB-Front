import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_reservations.dart';
import 'package:hub/src/View/Class/reservas.dart';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/View/Components/modal_message.dart';

class MinhasReservasPage extends StatefulWidget {
  const MinhasReservasPage({Key? key}) : super(key: key);

  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<MinhasReservasPage> {
  List<Reservas> reservas = [];

  void buscaReservas() {
    var api = ApiReservations();
    reservas.clear();

    api.getByCustomer(userData.idCliente!).then((response) {
      for (var reserva in response) {
        setState(() {
          reservas.add(Reservas.fromJson(reserva));
        });
      }
    }, onError: (error) async {
      setState(() {});
    });

    if (mounted) {
      setState(() {
        reservas = reservas;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    buscaReservas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      child: Stack(
        children: <Widget>[
          Column(
            children: [
              Expanded(
                  child: reservas.isNotEmpty
                      ? ListView.builder(
                          itemCount: reservas.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    reservas[i].produto.imagem == null
                                        ? Image.asset(
                                            "assets/product-icon.png",
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            fit: BoxFit.scaleDown,
                                          )
                                        : Image.memory(
                                            reservas[i].produto.imagem!,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            fit: BoxFit.scaleDown),
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    reservas[i].produto.nome +
                                                        " x " +
                                                        reservas[i]
                                                            .quantidadeDesejada
                                                            .toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center),
                                          Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    "Criada em " +
                                                        reservas[i]
                                                            .dataCriacao
                                                            .day
                                                            .toString()
                                                            .padLeft(2, '0') +
                                                        "/" +
                                                        reservas[i]
                                                            .dataCriacao
                                                            .month
                                                            .toString()
                                                            .padLeft(2, '0') +
                                                        "/" +
                                                        reservas[i]
                                                            .dataCriacao
                                                            .year
                                                            .toString() +
                                                        ", " +
                                                        reservas[i]
                                                            .dataCriacao
                                                            .hour
                                                            .toString()
                                                            .padLeft(2, '0') +
                                                        ":" +
                                                        reservas[i]
                                                            .dataCriacao
                                                            .minute
                                                            .toString()
                                                            .padLeft(2, '0'),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end),
                                          Row(
                                            children: [
                                              Text(
                                                reservas[i].status,
                                              ),
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                          )
                                        ],
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                    ),
                                    reservas[i].status == "PENDENTE"
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  confirmCancelReservation(
                                                      reservas[i].id);
                                                },
                                                child: const Text("Cancelar")))
                                        : Row()
                                  ]),
                            );
                          })
                      : const Center(
                          child: Text(
                          "Você ainda não fez nenhuma reserva.",
                          style: TextStyle(fontSize: 16),
                        ))),
            ],
          ),
        ],
      ),
    ));
  }

  void confirmCancelReservation(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Tem certeza que deseja cancelar essa reserva? '
                'Esta ação não pode ser desfeita.'),
            actions: [
              TextButton(
                onPressed: () {
                  cancelReservation(id);
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
        });
  }

  void cancelReservation(int id) {
    final api = ApiReservations();
    api.cancelReservation(id).then((response) {
      if (response.statusCode == 200) {
        buscaReservas();

        Navigator.of(context).pop();

        customMessageModal(
            context, '', 'Reserva cancelada com sucesso.', 'Fechar');
      } else {
        Navigator.of(context).pop();
        customMessageModal(
            context,
            '',
            'Houve um erro ao cancelar a reserva. Tente novamente mais tarde.',
            'Fechar');
      }
    });
  }
}
