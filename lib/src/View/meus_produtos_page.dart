import 'package:flutter/cupertino.dart';

class MeusProdutosPage extends StatelessWidget {
  late final String texto;

  MeusProdutosPage(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}
