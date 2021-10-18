class Endpoints {
  static const host = "http://192.168.0.148:5000/";
  static var create = host + "api/User/create";
  static var autenticate = host + "api/User/authenticate";
  static var searchProduto = host + "api/produto/buscar";
  static var registerProduct = host + "api/produto/cadastro";
  static var updateProduct = host + "api/produto/update";
  static var deleteProduct = host + "api/produto/deletar/$id";

  static get id => null;
}
