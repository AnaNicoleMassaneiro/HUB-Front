class Endpoints {
  static const host = "http://192.168.0.148:5000/";
  static var create = host + "api/User/create";
  static var autenticate = host + "api/User/authenticate";
  static var searchProdutoPorVendedor = host + "api/produto/buscarPorVendedor";
  static var registerProduct = host + "api/produto/cadastro";
  static var updateProduct = host + "api/produto/update/";
  static var deleteProduct = host + "api/produto/deletar/";
  static var searchProductAll = host + "buscarTodos";
}
