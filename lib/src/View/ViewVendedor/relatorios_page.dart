import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hub/src/Api/api_report.dart';
import 'package:hub/src/View/Class/report_body.dart';
import 'package:hub/src/View/Class/report_header.dart';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:hub/src/util/hub_colors.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({Key? key}) : super(key: key);

  @override
  _RelatoriosPageState createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  String lastReportType = '';
  String reportType = 'Vendas';
  String reportInterval = 'WEEK';

  ReportHeader? header;
  List<ReportBody>? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tipo de Relatório",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    DropdownButton<String>(
                      value: reportType,
                      elevation: 16,
                      style: TextStyle(color: hubColors.dark),
                      underline: Container(
                        height: 2,
                        color: hubColors.primary,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          reportType = newValue!;
                        });
                      },
                      items: <String>['Vendas', 'Reservas']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                    IconButton(
                        onPressed: () {
                          customMessageModal(
                              context,
                              "Tipo de Relatório",
                              "Relatórios de Vendas contabilizam "
                                  "todas as reservas realizadas para seus produtos, "
                                  "onde o status seja \"Concluída\". Já os  Relatórios "
                                  "de Reservas contabilizam apenas aquelas que não"
                                  " foram concluídas "
                                  "(\"Canceladas\", \"Expiradas\" ou \"Pendentes\").",
                              "OK");
                        },
                        icon: const Icon(Icons.info_outline))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Período",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    DropdownButton<String>(
                      value: reportInterval,
                      elevation: 16,
                      style: TextStyle(color: hubColors.dark),
                      underline: Container(
                        height: 2,
                        color: hubColors.primary,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          reportInterval = newValue!;
                        });
                      },
                      items: <List<String>>[
                        ['WEEK', 'Última semana'],
                        ['MONTH', 'Último mês'],
                        ['SEMESTER', 'Últmimo semestre'],
                        ['', 'Todas as vendas'],
                      ].map<DropdownMenuItem<String>>((List<String> value) {
                        return DropdownMenuItem<String>(
                          value: value[0],
                          child: Text(
                            value[1],
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                    IconButton(
                        onPressed: () {
                          customMessageModal(
                              context,
                              "Período",
                              "Período de tempo a ser considerado na geração "
                                  "do relatório.",
                              "OK");
                        },
                        icon: const Icon(Icons.info_outline))
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                ElevatedButton(
                    onPressed: () {
                      generateReport();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      child: Text(
                        "Gerar Relatório",
                        style: TextStyle(fontSize: 20, color: hubColors.dark),
                      ),
                    )),
                header == null
                    ? Row()
                    : Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15)),
                          Text(
                            "Relatório de " + lastReportType,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Total de " + lastReportType + ": ",
                                  style: details()),
                              Text(header!.totalReservas.toString(),
                                  style: detailsBold())
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Valor Total: ", style: details()),
                              Text(
                                  "R\$ " +
                                      header!.valorTotal
                                          .toStringAsFixed(2)
                                          .replaceAll('.', ','),
                                  style: detailsBold())
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Total de itens: ", style: details()),
                              Text(header!.quantidadeItens.toString(),
                                  style: detailsBold())
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Ticket Médio: ", style: details()),
                              Text(
                                  "R\$ " +
                                      header!.ticketMedio
                                          .toStringAsFixed(2)
                                          .replaceAll('.', ','),
                                  style: detailsBold())
                            ],
                          ),
                          const Padding(
                              padding: EdgeInsets.only(top: 10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("Detalhes por Produto: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 18)),
                            ],
                          )
                        ],
                      ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                header == null
                    ? Row()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: body!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return Card(
                              elevation: 3,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      body![i].produto,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10)),
                                      Text(
                                        "Total de " + lastReportType + ": ",
                                        style: details(),
                                      ),
                                      Text(
                                        body![i].quantidadeReservas.toString(),
                                        style: detailsBold(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10)),
                                      Text(
                                        "Valor total das " +
                                            lastReportType +
                                            ": ",
                                        style: details(),
                                      ),
                                      Text(
                                        "R\$ " +
                                            body![i]
                                                .valorTotal
                                                .toStringAsFixed(2)
                                                .replaceAll('.', ','),
                                        style: detailsBold(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10)),
                                      Text(
                                        "Quantidade total: ",
                                        style: details(),
                                      ),
                                      Text(
                                        body![i].quantidadeItens.toString(),
                                        style: detailsBold(),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(bottom: 10)),
                                ],
                              ),
                            );
                          },
                        ),
                      )
              ])),
    ));
  }

  void generateReport() async {
    header = null;
    body = <ReportBody>[];

    var api = ApiReport();
    var ret = await api.generateReport(
        userData.idVendedor!, reportType, reportInterval);

    if (ret.statusCode == 200) {
      var response = jsonDecode(ret.body);
      header = ReportHeader.fromJson(response["header"]);

      for (var r in response["data"]) {
        body!.add(ReportBody.fromJson(r));
      }

      lastReportType = reportType;

      setState(() {});
    } else if (ret.statusCode == 404) {
      customMessageModal(context, "Nenhum dado encontrado!",
          jsonDecode(ret.body)["msg"], "OK");
      setState(() {});
    } else {
      customMessageModal(context, "Erro!",
          "Houve um erro ao gerar o relatório: " + ret.body, "OK");
    }
  }

  TextStyle details() {
    return const TextStyle(
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        fontSize: 16,
        wordSpacing: 2);
  }

  TextStyle detailsBold() {
    return const TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontSize: 16,
        wordSpacing: 2);
  }
}
