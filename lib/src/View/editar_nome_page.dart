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
            title: const Text('Editar Nome'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFFD600), Color(0xFFFBC02D)]),
              ),
            )
        ),
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
          Column(
            children: [
              Text('Nome ' + widget.name),
              Text('Email ' + widget.email),
              Text('GRR ' + widget.grr),
              const TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Nome'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
