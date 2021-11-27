import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hub/src/Api/api_product.dart';
import 'package:hub/src/Validations/form_field_validations.dart';
import 'package:hub/src/View/Components/entry_fields.dart';
import 'package:hub/src/View/Components/modal_message.dart';
import 'package:image_picker/image_picker.dart';

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
        required this.idProduto,
        this.imagem})
      : super(key: key);

  final String title;
  final int idVendedor;
  final int idUser;
  final String nome;
  final double preco;
  final String descricao;
  final int qtdDisponivel;
  final int idProduto;
  final Uint8List? imagem;

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
  void initState(){
    super.initState();

    setState(() => {
      nomeText.text = widget.nome,
      precoText.text = widget.preco.toString(),
      descricaoText.text = widget.descricao,
      qtdDisponivelText.text = widget.qtdDisponivel.toString(),
      idProduto.text = widget.idProduto.toString()
    });
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: () {
          _updateProduct(
              idProduto.text,
              double.parse(precoText.text.replaceAll(",", ".")),
              nomeText.text,
              descricaoText.text,
              int.parse(qtdDisponivelText.text),
              selectedImage,
              isRemoveImage,
              widget.imagem
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          child: const Text(
            "Salvar alterações",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }

  Widget _cadastroForm() {
    return Column(
      children: <Widget>[
        entryFieldValidation(
            "Nome", nomeText, validateName, placeholder: '', enabled: isEditing),
        entryFieldValidation("Preço", precoText, validateNumber, enabled: isEditing,
            placeholder: '', keyboard: TextInputType.number),
        entryFieldValidation("Descrição", descricaoText, validateName,
            placeholder: '', enabled: isEditing),
        entryFieldValidation(
            "Quantidade Disponível", qtdDisponivelText, validateName,
            placeholder: '', keyboard: TextInputType.number, enabled: isEditing),
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
                  colors: [Color(0xFF915FB5), Color(0xFFCA436B)]),
            ),
          )
      ),
      floatingActionButton: isEditing ?
        FloatingActionButton(
            backgroundColor: Colors.red,
            child: const Icon(Icons.cancel_sharp),
            onPressed: () { setState(() => {
              isEditing = false,
              selectedImage = null,
              nomeText.text = widget.nome,
              precoText.text = widget.preco.toString(),
              descricaoText.text = widget.descricao,
              qtdDisponivelText.text = widget.qtdDisponivel.toString(),
              idProduto.text = widget.idProduto.toString(),
              isRemoveImage = false
            } ); }
        ) :
        FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.create),
            onPressed: () { setState(() => { isEditing = true } ); }
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
                    isRemoveImage
                      ? Column()
                      : _showImage(widget.imagem, selectedImage),
                    Form(
                      key: _formKey,
                      child: _cadastroForm(),
                    ),
                    isEditing ?
                    Column(
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: _pickedImage,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              alignment: Alignment.center,
                              color: const Color(0xFF915FB5),
                              child: const Text(
                                "Adicionar imagem",
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            )
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () { setState(() => { isRemoveImage = true }); },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              alignment: Alignment.center,
                              color: const Color(0xFF915FB5),
                              child: const Text(
                                "Remover imagem",
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            )
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                      ],
                    ) :
                    Column(),
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

  void _updateProduct(idProduto, preco, nome, descricao, qtdDisponivel,
      PickedFile? image, bool isRemoveImagem, Uint8List? oldImage) async {
    var api = api_product();

    File? upload;
    bool isKeepImage = false;

    if (isRemoveImage) { //removendo imagem atual
      upload = null;
    }
    else if (image != null){ //alterando imagem para nova imagemm
      upload = File.fromUri(Uri.parse(image.path));
    }
    else { //mantendo imagem atual
      upload = null;
      isKeepImage = true;
    }

    var ret = await api.update(
        widget.idProduto,
        widget.idVendedor,
        preco,
        nome,
        descricao,
        qtdDisponivel,
        upload,
        isKeepImage
    );

    if (ret.statusCode == 200) {
      Navigator.pop(context);
      customMessageModal(
          context, "Slucesso!", "Produto aterado com sucesso", "OK");
    } else {
      customMessageModal(context, "Falha ao cadastrar produto: ",
          jsonDecode(await ret.stream.bytesToString())["msg"], "Fechar");
    }
  }

  Image _showImage(Uint8List? image, PickedFile? pf){
    if (pf == null){
      if (image != null){
        return Image.memory(image, height: 250, width: 250, fit: BoxFit.cover);
      }
      else {
        return Image.asset("assets/product-icon.png", width: 200, height: 200);
      }
    }
    else {
      return Image.file(File(pf.path), height: 250, width: 250, fit: BoxFit.cover);
    }
  }
}
