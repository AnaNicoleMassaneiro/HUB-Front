String? validateGRR(String grr){
  RegExp regex = RegExp(r"^[0-9]{8}$");
  if (grr.isEmpty) {
    return "Preencha seu GRR.!";
  } else if (grr.length != 8 || !regex.hasMatch(grr)) {
    return "Seu GRR deve ser composto por 8 dígitos numéricos.";
  } else {
    return null;
  }
}

String? validateEmail(String email){
  RegExp regex = RegExp(
      r"^[\w!#$%&'*+\-/=?^_`{|}~]+(\.[\w!#$%&'*+\-/=?^_`{|}~]+)*@ufpr\.br$");
  RegExp regexDomain = RegExp(r".*@ufpr.br");

  if (email.trim().isEmpty) {
    return "Preencha seu e-mail.";
  } else {
    if (!regexDomain.hasMatch(email)) {
      return "Insira seu email @ufpr.br.";
    } else if (!regex.hasMatch(email)) {
      return "Insira um endereço de e-mail válido.";
    } else {
      return null;
    }
  }
}

String? validateName(String name){
  if (name.trim().isEmpty) {
    return "Preencha seu nome.";
  } else {
    return null;
  }
}

String? validatePassword(String pwd){
  if (pwd.trim().isEmpty) {
    return "Preencha a sua senha.";
  } else if (pwd.length < 6) {
    return "Sua senha deve ter no mínimo 6 caracteres.";
  } else {
    return null;
  }
}

String? validateUsername(String username){
  if (validateEmail(username) == null || validateGRR(username) == null) {
    return null;
  } else {
    return "Preencha usando seu GRR ou e-mail @ufpr.br.";
  }
}

String? validateNumber(String num){
  if (num.trim().isEmpty) {
    return "Preencha o valor do produto.";
  } else if (double.tryParse(num) == null) {
    return "Você deve informar um número válido.";
  } else {
    return null;
  }
}

String? validateAmount(String name){
  if (name.trim().isEmpty) {
    return "Preencha a quantidade disponível do produto.";
  } else if (int.tryParse(name) == null) {
    return "Você deve informar um número inteiro.";
  } else {
    return null;
  }
}

String? validateRatingTitle(String title){
  if (title.trim().isEmpty) {
    return "Preencha o título da avaliação.";
  } else {
    return null;
  }
}

String? validateRatingDescription(String desc){
  if (desc.trim().isEmpty) {
    return "Preencha a descrição da avaliação.";
  } else {
    return null;
  }
}
String? validateProductName(String desc){
  if (desc.trim().isEmpty) {
    return "Preencha o nome do produto.";
  } else {
    return null;
  }
}

String? validateDescription(String desc){
  if (desc.trim().isEmpty) {
    return "Preencha a descrição do produto.";
  } else {
    return null;
  }
}

String? validateQuantity(String qt){
  if (qt.trim().isEmpty) {
    return "Preencha a quantidade disponível.";
  }
  try {
    if (int.parse(qt
        .replaceAll(",", "")
        .replaceAll(".", "")
        .replaceAll(" ", "")) < 0) {
      return "Preencha a quantidade disponível.";
    }
  }
  catch(ex) {
    return "Preencha a quantidade disponível.";
  }
  return null;
}
