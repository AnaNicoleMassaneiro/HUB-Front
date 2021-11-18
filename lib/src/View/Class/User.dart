// ignore_for_file: non_constant_identifier_names, file_names

class User {
  int id;
  late String name;
  String? password;
  double? latitude;
  double? longitude;
  double? noteApp;
  String email;
  String grr;
  String lastLogon;
  String createdOn;
  String? activation_code;
  String? token;
  bool isVendedor;
  bool isAtivo;
  bool isOpen;

  User(
      {required this.name,
      required this.id,
      required this.password,
      required this.lastLogon,
      required this.activation_code,
      required this.createdOn,
      required this.email,
      required this.grr,
      required this.isVendedor,
      required this.latitude,
      required this.longitude,
      required this.noteApp,
      required this.token,
      required this.isAtivo,
      required this.isOpen});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['user']['name'],
        id: json['id'],
        password: json['user']['password'],
        lastLogon: json['user']['lastLogon'],
        activation_code: json['user']['activationCode'],
        createdOn: json['user']['createdOn'],
        email: json['user']['email'],
        grr: json['user']['grr'],
        isVendedor: json['user']['isVendedor'],
        latitude: double.parse(json['user']['latitude'].toString()),
        longitude: double.parse(json['user']['longitude'].toString()),
        noteApp: double.parse(json['user']['noteApp'].toString()),
        token: json['user']['token'],
        isAtivo: json['isAtivo'],
        isOpen: json['isOpen']);
  }
}
