import 'package:hub/src/Api/api_location.dart';
import 'package:hub/src/SQLite/user_data_sqlite.dart';
import 'package:location/location.dart';

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

  Future<void> atualizarLocalizacao(LocationData l) async {
    var api = ApiLocation();

    userData.curLocationLat = l.latitude;
    userData.curLocationLon = l.longitude;

    userDataSqlite.updateUserData(userData.toMap());
    api
        .updateCurrentLocation(l.latitude, l.longitude, userData.idUser!)
        .then((response) {
      if (response == null) {
        throw Exception("Houve um erro ao atualizar a localização!");
      } else if (response.statusCode != 200) {
        throw Exception(
            "Houve um erro ao atualizar a localização: " + response.body);
      }
    });
  }

  UserData._internal();
}

final userData = UserData();