class Endpoints {
  //static const host = "http://192.168.1.2:5000/"; // ENDPOINT LOCAL MATHEUS
  static const host = "http://192.168.0.148:4000"; // ENDPOINT LOCAL ANA
  static const create = host + "api/User/create";
  static const autenticate = host + "api/User/authenticate";
  static const searchProdutoPorVendedor =
      host + "api/produto/buscarPorVendedor";
  static const registerProduct = host + "api/produto/cadastro";
  static const updateProduct = host + "api/produto/update/";
  static const deleteProduct = host + "api/produto/deletar/";
  static const searchProductAll = host + "api/produto/buscarTodos";
  static const buscarTodosVendedores = host + "api/vendedor/buscarTodos";
  static const updateLocation = host + "api/User/atualizarLocalizacao/";
  static const createReservation = host + "api/reserva/create";
  static const cancelReservation = host + "api/reserva/cancel/";
  static const confirmReservation = host + "api/reserva/confirm/";
  static const getReservationByCustomer = host + "api/reserva/getByCustomer/";
  static const getReservationBySeller = host + "api/reserva/getBySeller/";
  static const buscaPorLocalizacao = host + "api/vendedor/buscarPorLocalizacao";
  static const buscarUserPorId = host + "api/User/buscarUserPorId/";
  static const insertRating = host + "api/avaliacao/insert";
  static const getCustomeratings = host + "api/avaliacao/cliente/";
  static const getSellerRatings = host + "api/avaliacao/vendedor/";
  static const getProductRatings = host + "api/avaliacao/produto/";
}
