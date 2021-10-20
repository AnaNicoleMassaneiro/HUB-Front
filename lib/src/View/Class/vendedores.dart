// ignore: file_names
// ignore_for_file: non_constant_identifier_names, file_names

class Vendedores {
  int id;
  late String name;
  String password;
  String latitude;
  String longitude;
  String noteApp;
  String email;
  String grr;
  String lastLogon;
  String createdOn;
  String activation_code;
  String token;
  bool is_vendedor;

  Vendedores(
      {required this.name,
      required this.id,
      required this.password,
      required this.lastLogon,
      required this.activation_code,
      required this.createdOn,
      required this.email,
      required this.grr,
      required this.is_vendedor,
      required this.latitude,
      required this.longitude,
      required this.noteApp,
      required this.token});

  factory Vendedores.fromJson(Map<String, dynamic> json) {
    return Vendedores(
      name: json['name'],
      id: json['id'],
      password: json['password'],
      lastLogon: json['lastLogon'],
      activation_code: json['activationCode'],
      createdOn: json['createdOn'],
      email: json['email'],
      grr: json['grr'],
      is_vendedor: json['isVendedor'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      noteApp: json['noteApp'],
      token: json['token'],
    );
  }
}
