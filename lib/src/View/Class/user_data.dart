class UserData {
  static final UserData _userData = UserData._internal();

  int? idVendedor;
  int? idCliente;
  int? idUser;
  bool? isVendedor;
  bool? isVendedorProfileActive;
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
      'isVendedor': isVendedor.toString(),
      'locationLat': curLocationLat,
      'locationLon': curLocationLon,
      'token': token,
    };
  }

  void clearAllData() {
    idVendedor = null;
    idUser = null;
    idCliente = null;
    isVendedor = null;
    isVendedorProfileActive = null;
    curLocationLon = null;
    curLocationLon = null;
    token = null;
  }

  UserData._internal();
}

final userData = UserData();