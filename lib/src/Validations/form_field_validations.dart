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

String? validateNumber(String name){
  if (name.trim().isEmpty) {
    return "Preencha o valor do produto.";
  } else {
    return null;
  }
}