class UserData {
  static final UserData _userData = UserData._internal();

  int? idVendedor;
  int? idCliente;
  int? idUser;
  double? curLocationLat;
  double? curLocationLon;
  String? token;

  factory UserData() {
    return _userData;
  }

  Map<String, dynamic> toMap() {
    return {
      'idVendedor': idVendedor,
      'idCliente': idCliente,
      'idUser': idUser,
      'locationLat': curLocationLat,
      'locationLon': curLocationLon,
      'token': token,
    };
  }

  UserData._internal();
}

final userData = UserData();