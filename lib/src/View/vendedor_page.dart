import 'package:flutter/material.dart';
import 'package:hub/src/SQLite/user_data_sqlite.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:hub/src/View/ViewCliente/cliente_page.dart';
import 'package:hub/src/View/ViewVendedor/minhas_reservas_page.dart';
import 'package:hub/src/View/ViewVendedor/relatorios_page.dart';
import 'package:hub/src/View/perfil_page.dart';
import 'package:hub/src/View/welcome_page.dart';
import 'package:hub/src/util/hub_colors.dart';
import 'ViewProduto/cadastrar_produto_page.dart';
import 'ViewProduto/meus_produtos_page.dart';
import './Class/user_data.dart';

class VendedorPage extends StatefulWidget {
  VendedorPage({Key? key}) : super(key: key);

  final int idVendedor = userData.idVendedor!;
  final int idUser = userData.idUser!;

  @override
  _VendedorPageState createState() => _VendedorPageState();
}

class _VendedorPageState extends State<VendedorPage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  late Map<String, double> userLocation;
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _telas = [
      MeusProdutosPage(),
      const MinhasReservasPage(),
      const RelatoriosPage(),
      Container(),
    ];

    return Scaffold(
        appBar: AppBar(
            title: Text('Área do vendedor',
                style: TextStyle(color: hubColors.dark)),
            flexibleSpace: Container(
              decoration: hubColors.appBarGradient(),
            )),
        drawer: Drawer(
            child: ListView(
          children: [
            ListTile(
              title: const Text('Minha conta'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PerfilPage()));
              },
            ),
            ListTile(
              title: const Text('Alternar perfil'),
              trailing: IconButton(
                onPressed: () {
                  customMessageModal(
                      context,
                      "Alternar perfil",
                      "Alterne entre seu perfil de comprador e vendedor. "
                          "No primeiro você pode buscar vendedores e "
                          "produtos. No segundo, você pode atualizar os "
                          "dados de seus produtos e cuidar da sua "
                          "loja virtual.",
                      "Ok");
                },
                icon: const Icon(
                  Icons.info_outline,
                  size: 24,
                ),
              ),
              onTap: () {
                userData.isVendedorProfileActive = false;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClientePage()),
                    (r) => false
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                userDataSqlite.deleteUserData();
                userData.clearAllData();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WelcomePage(title: '')),
                    (route) => false);
              },
            ),
          ],
        )),
        body: _telas[_indiceAtual],
        floatingActionButton: _indiceAtual == 0
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
                backgroundColor: hubColors.primary,
              )
            : Column(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: onTabTapped,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined), label: "Meus Produtos"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.attach_money_sharp), label: "Minhas Reservas"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: "Relatórios"),
          ],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}
