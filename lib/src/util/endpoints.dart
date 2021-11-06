class Endpoints {
  static const host = "http://192.168.1.2:5000/";
  static const create = host + "api/User/create";
  static const autenticate = host + "api/User/authenticate";
  static const searchProdutoPorVendedor = host + "api/produto/buscarPorVendedor";
  static const registerProduct = host + "api/produto/cadastro";
  static const updateProduct = host + "api/produto/update/";
  static const deleteProduct = host + "api/produto/deletar/";
  static const searchProductAll = host + "api/produto/buscarTodos";
  static const buscarTodosVendedores = host + "api/vendedor/buscarTodos";
  static const updateLocation = host + "api/User/atualizarLocalizacao/";
  static const createReservation = host + "api/reserva/create";
  static const cancelReservation = host + "api/reserva/cancel";
  static const confirmReservation = host + "api/reserva/confirm";
}
