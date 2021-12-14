import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hub/src/util/hub_colors.dart';

class RelatoriosPage extends StatefulWidget {

  RelatoriosPage({Key? key}) : super(key: key);

  @override
  _RelatoriosPageState createState() => _RelatoriosPageState();
  }
class _RelatoriosPageState extends State<RelatoriosPage> {
  String dropdownValue = 'Vendas';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: TextStyle(color: hubColors.primary),
      underline: Container(
        height: 2,
        color: hubColors.primary,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Vendas', 'Reservas']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
