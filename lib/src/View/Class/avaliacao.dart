class Avaliacao {
  late int id;
  late int tipoAvaliacao;
  late int? idCliente;
  late int? idVendedor;
  late int? idProduto;
  late String nome;
  late String titulo;
  late String descricao;
  late int nota;
  late DateTime dataCriacao;

  Avaliacao({
    required this.id,
    required this.tipoAvaliacao,
    this.idCliente,
    this.idVendedor,
    this.idProduto,
    required this.nome,
    required this.titulo,
    required this.descricao,
    required this.nota,
    required this.dataCriacao
  });

  factory Avaliacao.fromJson(Map<String, dynamic> avaliacao) {
    var nome = "";

    switch (avaliacao["tipoAvaliacao"]) {
      case 1:
        nome = avaliacao["cliente"]["user"]["name"];
        break;
      case 2:
        nome = avaliacao["cliente"]["user"]["name"];
        break;
      case 3:
        nome = avaliacao["vendedor"]["user"]["name"];
        break;
    }

    return Avaliacao(
      id: avaliacao["idAvaliacao"],
      tipoAvaliacao: avaliacao["tipoAvaliacao"],
      idCliente: avaliacao["cliente"] == null ? null : avaliacao["cliente"]["id"],
      idVendedor: avaliacao["vendedor"] == null ? null : avaliacao["vendedor"]["id"],
      idProduto: avaliacao["produto"] == null ? null : avaliacao["produto"]["id"],
      nome: nome,
      titulo: avaliacao["titulo"],
      nota: avaliacao["nota"],
      descricao: avaliacao["descricao"],
      dataCriacao: DateTime.parse(avaliacao["dataCriacao"]),//DateTime.parse("2021-12-12 00:00:00")
    );
  }
}
