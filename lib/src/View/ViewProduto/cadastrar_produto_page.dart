import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/Validations/form_field_validations.dart';
import 'package:hub/src/View/Components/entry_fields.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:hub/src/util/hub_colors.dart';
import 'package:image_picker/image_picker.dart';

class CadastrarProdutoPage extends StatefulWidget {
  const CadastrarProdutoPage(
      {Key? key, required this.title, required this.idVendedor, required this.idUser})
      : super(key: key);

  final String title;
  final int idVendedor;
  final int idUser;

  @override
  _CadastrarProdutoPageState createState() => _CadastrarProdutoPageState();
}

class _CadastrarProdutoPageState extends State<CadastrarProdutoPage> {
  final TextEditingController preco = TextEditingController();
  final TextEditingController nome = TextEditingController();
  final TextEditingController descricao = TextEditingController();
  final TextEditingController qtdDisponivel = TextEditingController();

  PickedFile? selectedImage;

  bool isChecked = false;

  final _formKey = GlobalKey<FormState>();

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _registerProduct(double.parse(preco.text.replaceAll(",", ".")),
                nome.text, descricao.text, int.parse(qtdDisponivel.text),
                selectedImage);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          child: Text(
            "Cadastrar",
            style: TextStyle(fontSize: 20, color: hubColors.dark),
          ),
        ));
  }

  Widget _cadastroForm() {
    return Column(
      children: <Widget>[
        entryFieldValidation("Nome", nome, validateName, placeholder: ''),
        entryFieldValidation("Preço", preco, validateNumber,
            placeholder: '', keyboard: TextInputType.number),
        entryFieldValidation("Descrição", descricao, validateName,
            placeholder: ''),
        entryFieldValidation(
            "Quantidade Disponível", qtdDisponivel, validateName,
            placeholder: '', keyboard: TextInputType.number),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Cadastrar Produto',
              style: TextStyle(color: hubColors.dark)),
          flexibleSpace: Container(
            decoration: hubColors.appBarGradient(),
          )
      ),
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
                    _showImage(selectedImage),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: _pickedImage,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: Text(
                            "Adicionar imagem",
                            style: TextStyle(fontSize: 20, color: hubColors.dark),
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10))
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

  void _registerProduct(preco, nome, descricao, qtdDisponivel, PickedFile? image) async { 
    var api = api_product();

    File? upload;
    image != null ? upload = File.fromUri(Uri.parse(image.path)) : upload = null;

    var ret = await api.register(
        widget.idVendedor, preco, nome, descricao, qtdDisponivel, upload);

    if (ret.statusCode == 200) {
      Navigator.pop(context);
      customMessageModal(
          context, "Sucesso!", "Produto cadastrado com sucesso", "OK");
    } else {
      customMessageModal(context, "Falha ao cadastrar produto: ",
          jsonDecode(await ret.stream.bytesToString())["msg"], "Fechar");
    }
  }

  Image _showImage(PickedFile? pf) {
    if (pf != null){
      return Image.file(File(pf.path), height: 250, width: 250, fit: BoxFit.cover);
    }
    else {
      return Image.asset("assets/upload-icon.png", width: 200, height: 200);
    }
  }
}