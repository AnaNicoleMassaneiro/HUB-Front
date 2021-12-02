import 'package:flutter/material.dart';
import 'package:hub/src/SQLite/user_data_sqlite.dart';
import 'package:hub/src/View/ViewVendedor/minhas_reservas_page.dart';
import 'package:hub/src/View/perfil_page.dart';
import 'package:hub/src/View/welcome_page.dart';
import 'Components/mapa.dart';
import 'ViewProduto/cadastrar_produto_page.dart';
import 'ViewProduto/meus_produtos_page.dart';
import './Class/user_data.dart';

class VendedorPage extends StatefulWidget {
  VendedorPage({Key? key, required this.title}) : super(key: key);

  final String title;
  final int idVendedor = userData.idVendedor!;
  final int idUser = userData.idUser!;

  @override
  _VendedorPageState createState() => _VendedorPageState();
}

class _VendedorPageState extends State<VendedorPage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  late Map<String, double> userLocation;
  int _indiceAtual = 1;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _telas = [
      const MapComponent(),
      MeusProdutosPage(),
      const MinhasReservasPage(),
    ];

    return Scaffold(
        appBar: AppBar(
            title: const Text('Área do vendedor'),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFBC02D), Color(0xFFFBC02D)]),
              ),
            )),
        drawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Minha conta'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PerfilPage()));
                  },
                ),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () {
                    userDataSqlite.deleteUserData(userData.idUser!);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomePage(title: '')),
                        (route) => false);
                  },
                ),
              ],
            )
        ),
        body: _telas[_indiceAtual],
        floatingActionButton: _indiceAtual == 1
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CadastrarProdutoPage(
                              title: '',
                              idVendedor: widget.idVendedor,
                              idUser: widget.idUser))).then((value) {
                    setState(() {});
                  });
                },
                child: const Icon(Icons.plus_one),
                backgroundColor: Colors.black,
              )
            : Column(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: onTabTapped,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Localização"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Meus Produtos"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Minhas Reservas")
          ],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}
