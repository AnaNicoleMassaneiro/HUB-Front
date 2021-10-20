import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/Validations/form_field_validations.dart';
import 'package:hub/src/View/Components/entry_fields.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:image_picker/image_picker.dart';

import '../vendedor_page.dart';

class EditarProdutoPage extends StatefulWidget {
  const EditarProdutoPage(
      {Key? key,
      required this.title,
      required this.idVendedor,
      required this.idUser,
      required this.nome,
      required this.preco,
      required this.descricao,
      required this.qtdDisponivel,
      required this.idProduto})
      : super(key: key);

  final String title;
  final int idVendedor;
  final int? idUser;
  final String nome;
  final double preco;
  final String descricao;
  final int qtdDisponivel;
  final int idProduto;

  @override
  _EditarProdutoPageState createState() => _EditarProdutoPageState();
}

class _EditarProdutoPageState extends State<EditarProdutoPage> {
  bool isChecked = false;
  var nomeText = TextEditingController();
  var precoText = TextEditingController();
  var descricaoText = TextEditingController();
  var qtdDisponivelText = TextEditingController();
  var idProduto = TextEditingController();
  PickedFile? selectedImage;

  final _formKey = GlobalKey<FormState>();

  Widget _submitButton() {
    setState(() => {
          nomeText.text = widget.nome,
          precoText.text = widget.preco.toString(),
          descricaoText.text = widget.descricao,
          qtdDisponivelText.text = widget.qtdDisponivel.toString(),
          idProduto.text = widget.idProduto.toString()
        });

    return ElevatedButton(
        onPressed: () {
          _registerProduct(
              idProduto.text,
              double.parse(precoText.text),
              nomeText.text,
              descricaoText.text,
              int.parse(qtdDisponivelText.text),
              selectedImage);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          child: const Text(
            "Cadastrar",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _cadastroForm() {
    return Column(
      children: <Widget>[
        entryFieldValidation("Nome", nomeText, validateName, placeholder: ''),
        entryFieldValidation("Preço", precoText, validateNumber,
            placeholder: '', keyboard: TextInputType.number),
        entryFieldValidation("Descrição", descricaoText, validateName,
            placeholder: ''),
        entryFieldValidation(
            "Quantidade Disponível", qtdDisponivelText, validateName,
            placeholder: '', keyboard: TextInputType.number),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Editar Produto'), backgroundColor: Colors.orange),
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
                    Form(
                      key: _formKey,
                      child: _cadastroForm(),
                    ),
                    ElevatedButton(
                        onPressed: _pickedImage,
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
                    _submitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickedImage() {
    showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
          content: const Text("Como quer enviar a imagem?"),
          actions: [
            TextButton(
              child: const Text("Tirar Foto"),
              onPressed: () => Navigator.pop(context, ImageSource.camera),
            ),
            TextButton(
              child: const Text("Abrir Galeria"),
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ]),
    ).then((source) async {
      if (source != null) {
        // ignore: deprecated_member_use
        selectedImage = await ImagePicker().getImage(source: source);
      }
    });
  }

  void _registerProduct(idProduto, preco, nome, descricao, qtdDisponivel,
      PickedFile? image) async {
    var api = api_product();

    File? upload;
    image != null
        ? upload = File.fromUri(Uri.parse(image.path))
        : upload = null;

    var ret = await api.update(widget.idProduto, widget.idVendedor, preco, nome,
        descricao, qtdDisponivel, upload);

    if (ret.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            // ignore: prefer_const_constructors
            builder: (context) => VendedorPage(
                  title: '',
                  idVendedor: widget.idVendedor,
                  idUser: widget.idUser,
                )),
      );
      customMessageModal(
          context, "Sucesso!", "Produto alterado com sucesso", "OK");
    } else {
      customMessageModal(context, "Falha ao cadastrar produto: ",
          jsonDecode(await ret.stream.bytesToString())["msg"], "Fechar");
    }
  }
}
