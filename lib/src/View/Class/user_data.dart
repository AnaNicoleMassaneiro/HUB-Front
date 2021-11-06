class UserData {
  static final UserData _userData = UserData._internal();

  int? idVendedor;
  int? idCliente;
  int? idUser;
  double? curLocationLat;
  double? curLocationLon;

  factory UserData() {
    return _userData;
  }

  UserData._internal();
}
final userData = UserData();