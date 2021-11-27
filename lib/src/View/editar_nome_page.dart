import 'package:flutter/material.dart';

class EditarNomePage extends StatefulWidget {
  const EditarNomePage(
      {Key? key, required this.name, required this.email, required this.grr})
      : super(key: key);

  final String name;
  final String email;
  final String grr;

  @override
  _EditarNomePageState createState() => _EditarNomePageState();
}

class _EditarNomePageState extends State<EditarNomePage> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Editar Nome'), backgroundColor: Colors.orange),
        body: SafeArea(
          child: Column(
            children: [
              header(),
            ],
          ),
        ));
  }

  Widget header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
      child: Column(
        children: <Widget>[
          TextField(
            decoration:
                InputDecoration(border: OutlineInputBorder(), hintText: 'Nome'),
          ),
        ],
      ),
    );
  }
}