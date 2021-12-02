class Endpoints {
  //static const host = "https://hubufpr.herokuapp.com/"; // ENDPOINT HEROKU
  static const host = "http://192.168.1.2:5000/"; // ENDPOINT LOCAL

  // USER
  static const create = host + "api/User/create";
  static const autenticate = host + "api/User/authenticate";
  static const updateLocation = host + "api/User/atualizarLocalizacao/";
  static const buscarUserPorId = host + "api/User/buscarUserPorId/";
  static const updateUserName = host + "api/User/updateUser/";
  static const atualizarSenha = host + "api/User/atualizarSenha/";

  // VENDEDOR
  static const buscarTodosVendedores = host + "api/vendedor/buscarTodos";
  static const buscarVendedorPorId = host + "api/vendedor/buscarPorId/";
  static const buscaPorLocalizacao = host + "api/vendedor/buscarPorLocalizacao";
  static const atualizarStatusVendedor = host + "api/vendedor/atualizarStatus";

  // VENDEDOR FAVORITO
  static const addToFavorites = host + "api/vendedor/favoritos/adicionar";
  static const removeFromFavorites = host + "api/vendedor/favoritos/remover";
  static const getFavorites = host + "api/vendedor/favoritos/buscar/";
  static const isFavorite = host + "api/vendedor/favoritos/isFavorite";

  // FORMA DE PAGAMENTO
  static const addPaymentModes = host + "api/formaPagamento/adicionar";
  static const removePaymentModes = host + "api/formaPagamento/remover";
  static const getPaymentModesBySeller = host + "api/formaPagamento/buscar/";
  static const listPaymentModes = host + "api/formaPagamento/buscar";

  // PRODUTO
  static const searchProdutoPorVendedor =
      host + "api/produto/buscarPorVendedor";
  static const searchProductAll = host + "api/produto/buscarTodos";
  static const registerProduct = host + "api/produto/cadastro";
  static const updateProduct = host + "api/produto/update/";
  static const deleteProduct = host + "api/produto/deletar/";

  // RESERVA
  static const createReservation = host + "api/reserva/create";
  static const cancelReservation = host + "api/reserva/cancel/";
  static const confirmReservation = host + "api/reserva/confirm/";
  static const getReservationByCustomer = host + "api/reserva/getByCustomer/";
  static const getReservationBySeller = host + "api/reserva/getBySeller/";

  // AVALIAÇÃO
  static const insertRating = host + "api/avaliacao/insert";
  static const getCustomeratings = host + "api/avaliacao/cliente/";
  static const getSellerRatings = host + "api/avaliacao/vendedor/";
  static const getProductRatings = host + "api/avaliacao/produto/";
}
