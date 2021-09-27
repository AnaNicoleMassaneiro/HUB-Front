String validateGRR(String grr){
  RegExp regex = new RegExp(r"^[0-9]{8}$");
  if (grr == null || grr.isEmpty)
    return "Por favor, preencha o GRR!";
  else if (grr.length != 8 || !regex.hasMatch(grr))
    return "Seu GRR deve ser composto por 8 dígitos numéricos.";
  else return null;
}

String validateEmail(String email){
  RegExp regex = new RegExp(
      r"^[\w!#$%&'*+\-/=?^_`{|}~]+(\.[\w!#$%&'*+\-/=?^_`{|}~]+)*@ufpr\.br$");
  RegExp regexDomain = new RegExp(r".*@ufpr.br");

  if (email == null || email.isEmpty)
    return "Por favor, preencha seu e-mail!";
  else if (!regexDomain.hasMatch(email))
    return "Insira seu email @ufpr.br.";
  else if (!regex.hasMatch(email))
    return "Insira um endereço de e-mail válido.";
  else return null;
}

String validateName(String name){
  if (name == null || name.isEmpty)
    return "Por favor, preencha seu nome!";
  else return null;
}

String validatePassword(String pwd){
  if (pwd == null || pwd.isEmpty)
    return "Por favor, preencha sua a senha!";
  else if (pwd.length < 6)
    return "Sua senha deve ter no mínimo 6 caracteres.";
  else return null;
}