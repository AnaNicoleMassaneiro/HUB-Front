import 'meus_produtos.dart';

class Reservas {
  late int id;
  late int idCliente;
  late int idProduto;
  late MeusProdutos produto;
  late String status;
  late DateTime dataCriacao;
  late int quantidadeDesejada;
  late double localizacaoLat;
  late double localizacaoLon;

  Reservas({
    required this.id,
    required this.idCliente,
    required this.idProduto,
    required this.produto,
    required this.status,
    required this.dataCriacao,
    required this.quantidadeDesejada,
    required this.localizacaoLat,
    required this.localizacaoLon
  });

  factory Reservas.fromJson(Map<String, dynamic> json) {
    return Reservas(
        id: json['idReserva'],
        idCliente: json['cliente']['id'],
        idProduto: json['produto']['id'],
        produto: MeusProdutos.fromJson(json['produto']),
        status: json['statusReserva'],
        dataCriacao: DateTime.parse(json['dataCriacao']),
        quantidadeDesejada: json['quantidadeDesejada'],
        localizacaoLat: double.parse(json['latitude'].toString()),
        localizacaoLon: double.parse(json['longitude'].toString())
    );
  }
}
