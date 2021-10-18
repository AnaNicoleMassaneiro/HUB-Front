import 'package:flutter/material.dart';

class ListaVendedoresPage extends StatefulWidget {
  const ListaVendedoresPage({Key? key}) : super(key: key);

  @override
  _ListaVendedoresPageState createState() => _ListaVendedoresPageState();
}

class _ListaVendedoresPageState extends State<ListaVendedoresPage> {
  final TextEditingController preco = TextEditingController();
  final TextEditingController nome = TextEditingController();
  final TextEditingController descricao = TextEditingController();
  final TextEditingController qtdDisponivel = TextEditingController();

  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Buscar Vendedor'), backgroundColor: Colors.orange),
      body: SizedBox(
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          color: Colors.orange,
                          child: const Text(
                            "Adicionar imagem",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
