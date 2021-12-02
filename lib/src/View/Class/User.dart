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
  String telefone;
  String lastLogon;
  String createdOn;
  String? activation_code;
  String? token;
  bool isVendedor;

  User(
      {required this.name,
      required this.id,
      required this.password,
      required this.lastLogon,
      required this.activation_code,
      required this.createdOn,
      required this.email,
      required this.grr,
      required this.telefone,
      required this.isVendedor,
      required this.latitude,
      required this.longitude,
      required this.noteApp,
      required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        id: json['id'],
        password: json['password'],
        lastLogon: json['lastLogon'],
        activation_code: json['activationCode'],
        createdOn: json['createdOn'],
        email: json['email'],
        grr: json['grr'],
        telefone: json['telefone'],
        isVendedor: json['isVendedor'],
        latitude: double.parse(json['latitude'].toString()),
        longitude: double.parse(json['longitude'].toString()),
        noteApp: double.parse(json['noteApp'].toString()),
        token: json['token']);
  }
}
