class Endpoints {
  //static const host = "https://hubufpr.herokuapp.com/api/"; // ENDPOINT HEROKU
  static const host = "http://192.168.1.11:5000/api/"; // ENDPOINT LOCAL

  // USER
  static const create = host + "User/create";
  static const autenticate = host + "User/authenticate";
  static const updateLocation = host + "User/atualizarLocalizacao/";
  static const buscarUserPorId = host + "User/buscarUserPorId/";
  static const updateUserName = host + "User/updateUser/";
  static const atualizarSenha = host + "User/atualizarSenha/";

  // VENDEDOR
  static const buscarTodosVendedores = host + "vendedor/buscarTodos";
  static const buscarVendedorPorId = host + "vendedor/buscarPorId/";
  static const buscaPorLocalizacao = host + "vendedor/buscarPorLocalizacao";
  static const atualizarStatusVendedor = host + "vendedor/atualizarStatus";

  // VENDEDOR FAVORITO
  static const addToFavorites = host + "vendedor/favoritos/adicionar";
  static const removeFromFavorites = host + "vendedor/favoritos/remover";
  static const getFavorites = host + "vendedor/favoritos/buscar/";
  static const isFavorite = host + "vendedor/favoritos/isFavorite";

  // FORMA DE PAGAMENTO
  static const addPaymentModes = host + "formaPagamento/adicionar";
  static const removePaymentModes = host + "formaPagamento/remover";
  static const getPaymentModesBySeller = host + "formaPagamento/buscar/";
  static const listPaymentModes = host + "formaPagamento/buscar";

  // PRODUTO
  static const searchProdutoPorVendedor =
      host + "produto/buscarPorVendedor";
  static const searchProductAll = host + "produto/buscarTodos";
  static const registerProduct = host + "produto/cadastro";
  static const updateProduct = host + "produto/update/";
  static const deleteProduct = host + "produto/deletar/";

  // RESERVA
  static const createReservation = host + "reserva/create";
  static const cancelReservation = host + "reserva/cancel/";
  static const confirmReservation = host + "reserva/confirm/";
  static const getReservationByCustomer = host + "reserva/getByCustomer/";
  static const getReservationBySeller = host + "reserva/getBySeller/";

  // AVALIAÇÃO
  static const insertRating = host + "avaliacao/insert";
  static const getCustomeratings = host + "avaliacao/cliente/";
  static const getSellerRatings = host + "avaliacao/vendedor/";
  static const getProductRatings = host + "avaliacao/produto/";

  // RELATÓRIO
  static const generateReport = host + "relatorios/criar";
}
