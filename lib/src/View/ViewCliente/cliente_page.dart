import 'package:flutter/material.dart';
import 'package:hub/src/SQLite/user_data_sqlite.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:hub/src/View/vendedor_page.dart';
import 'package:hub/src/util/hub_colors.dart';
import 'package:location/location.dart';

import '../Components/mapa.dart';
import '../perfil_page.dart';
import '../welcome_page.dart';
import 'buscar_page.dart';
import 'meus_favoritos_page.dart';
import 'minhas_reservas_page.dart';
import '../Class/user_data.dart';

class ClientePage extends StatefulWidget {
  ClientePage({Key? key}) : super(key: key);

  final int idCliente = userData.idCliente!;
  final int idUser = userData.idUser!;

  @override
  _ClientePageState createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  final TextEditingController user = TextEditingController();
  final TextEditingController senha = TextEditingController();
  var location = Location();
  late Map<String, double> userLocation;
  late LocationData minhaLocalizacao;
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _telas = [
      const MapComponent(),
      const BuscarPage(),
      const MinhasReservasPage()
    ];

    return Scaffold(
        appBar: AppBar(
            title: Text('Área do cliente',
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
                    const page = PerfilPage();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => page));
                  },
                ),
                ListTile(
                  title: const Text('Favoritos'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MeusFavoritosPage()),
                    );
                  },
                ),
                userData.isVendedor!
                ? ListTile(
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
                    userData.isVendedorProfileActive = true;
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendedorPage()),
                            (r) => false
                    );
                  },
                )
                : Container(),
                ListTile(
                  title: const Text('Logout'),
                  onTap: () {
                    userDataSqlite.deleteUserData();
                    userData.clearAllData();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomePage()),
                        (route) => false);
                  },
                ),
              ],
            )
        ),
        body: _telas[_indiceAtual],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: onTabTapped,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined), label: "Perto de mim"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined), label: "Buscar"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined), label: "Minhas Reservas")
          ],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}
