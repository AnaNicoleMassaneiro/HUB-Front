import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/Validations/form_field_validations.dart';
import 'package:hub/src/View/Class/meus_produtos.dart';
import 'package:hub/src/View/Class/user_data.dart';
import 'package:hub/src/View/Components/entry_fields.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:hub/src/util/hub_colors.dart';
import 'package:image_picker/image_picker.dart';

class EditarProdutoPage extends StatefulWidget {
  const EditarProdutoPage({Key? key, required this.produto}) : super(key: key);

  final MeusProdutos produto;

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
  var isEditing = false;
  var isRemoveImage = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    setState(() => {
          nomeText.text = widget.produto.nome,
          precoText.text = widget.produto.preco.toString(),
          descricaoText.text = widget.produto.descricao,
          qtdDisponivelText.text =
              widget.produto.quantidadeDisponivel.toString(),
          idProduto.text = widget.produto.id.toString()
        });
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _updateProduct(
                idProduto.text,
                double.parse(precoText.text.replaceAll(",", ".")),
                nomeText.text,
                descricaoText.text,
                int.parse(qtdDisponivelText.text
                    .replaceAll(",", "")
                    .replaceAll(".", "")
                    .replaceAll(" ", "")
                ),
                selectedImage,
                isRemoveImage,
                widget.produto.imagem,
                widget.produto.isAtivo!);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          child: const Text(
            "Salvar alterações",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ));
  }

  Widget _cadastroForm() {
    return Column(
      children: <Widget>[
        entryFieldValidation("Nome", nomeText, validateProductName,
            placeholder: '', enabled: isEditing),
        entryFieldValidation("Preço", precoText, validateNumber,
            enabled: isEditing,
            placeholder: '',
            keyboard: TextInputType.number),
        entryFieldValidation("Descrição", descricaoText, validateDescription,
            placeholder: '', enabled: isEditing),
        entryFieldValidation(
            "Quantidade Disponível", qtdDisponivelText, validateQuantity,
            placeholder: '',
            keyboard: TextInputType.number,
            enabled: isEditing),
        SwitchListTile(
          contentPadding: const EdgeInsets.all(5),
          value: widget.produto.isAtivo!,
          onChanged: isEditing
              ? (bool value) {
                  setState(() {
                    widget.produto.isAtivo = value;
                  });
                }
              : null,
          title: const Text(
            "Produto ativo?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Editar Produto'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFFFBC02D), Color(0xFFFBC02D)]),
            ),
          )),
      floatingActionButton: isEditing
          ? FloatingActionButton(
              backgroundColor: Colors.red,
              child: const Icon(Icons.cancel_sharp),
              onPressed: () {
                setState(() => {
                      isEditing = false,
                      selectedImage = null,
                      nomeText.text = widget.produto.nome,
                      precoText.text = widget.produto.preco.toString(),
                      descricaoText.text = widget.produto.descricao,
                      qtdDisponivelText.text =
                          widget.produto.quantidadeDisponivel.toString(),
                      idProduto.text = widget.produto.id.toString(),
                      isRemoveImage = false,
                      _formKey.currentState!.validate(),
                    });
              })
          : FloatingActionButton(
              backgroundColor: hubColors.primary,
              child: const Icon(Icons.create),
              onPressed: () {
                setState(() => {isEditing = true});
              }),
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
                    isRemoveImage
                        ? Column()
                        : _showImage(widget.produto.imagem, selectedImage),
                    Form(
                      autovalidateMode: AutovalidateMode.disabled,
                      key: _formKey,
                      child: _cadastroForm(),
                    ),
                    isEditing
                        ? Column(
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: _pickedImage,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Adicionar imagem",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() => {isRemoveImage = true});
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      "Remover imagem",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              _submitButton(),
                            ],
                          )
                        : Column(),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 40)),
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
    ).then((source) {
      if (source != null) {
        // ignore: deprecated_member_use
        setState(() async {
          selectedImage = await ImagePicker().getImage(source: source);
        });
      }
    });
  }

  void _updateProduct(
      idProduto,
      preco,
      nome,
      descricao,
      qtdDisponivel,
      PickedFile? image,
      bool isRemoveImagem,
      Uint8List? oldImage,
      bool isAtivo) async {
    var api = api_product();

    File? upload;
    bool isKeepImage = false;

    if (isRemoveImage) {
      //removendo imagem atual
      upload = null;
    } else if (image != null) {
      //alterando imagem para nova imagemm
      upload = File.fromUri(Uri.parse(image.path));
    } else {
      //mantendo imagem atual
      upload = null;
      isKeepImage = true;
    }

    var ret = await api.update(widget.produto.id, userData.idVendedor!, preco,
        nome, descricao, qtdDisponivel, isAtivo, upload, isKeepImage);

    if (ret.statusCode == 200) {
      Navigator.pop(context);
      customMessageModal(
          context, "Slucesso!", "Produto aterado com sucesso", "OK");
    } else {
      customMessageModal(context, "Falha ao cadastrar produto: ",
          jsonDecode(await ret.stream.bytesToString())["msg"], "Fechar");
    }
  }

  Image _showImage(Uint8List? image, PickedFile? pf) {
    if (pf == null) {
      if (image != null) {
        return Image.memory(image, height: 250, width: 250, fit: BoxFit.cover);
      } else {
        return Image.asset("assets/product-icon.png", width: 200, height: 200);
      }
    } else {
      return Image.file(File(pf.path),
          height: 250, width: 250, fit: BoxFit.cover);
    }
  }
}
