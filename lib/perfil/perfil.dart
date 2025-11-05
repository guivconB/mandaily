import 'package:flutter/material.dart';
import 'dart:io'; //Adicionado para usar File
import 'package:image_picker/image_picker.dart'; //Adicionado para selecionar imagem
import '../widgets_perfil/perfil_componentes.dart';
//Importa os widgets do Flutter e o componente PerfilComponentes criado na pasta Widgets

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}
//Agor a tela tem estado e pode mudar de maneira dinâmica definindo-a como StatefulWidget

class _PerfilState extends State<Perfil> {
  int selectedPerfil = 1;
  bool notificacoes1 = true;
//Defini as variáveis que controlam o perfil

  File? fotoPerfil;

  Future<void> editarFoto() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        fotoPerfil = File(imagem.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    //Esse método monta a interface visual da tela

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text('Perfis'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);  // Volta para a tela anterior
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Espaçamento interno
            PerfilComponentes(
              nome: 'Nome Sobrenome',
              nascimento: 'dd/mm/aaaa',
              notificacoes: notificacoes1,
              onNotificacoesChanged: (val) => setState(() => notificacoes1 = val),
              isSelected: selectedPerfil == 1,

              fotoPerfil: fotoPerfil,
              onEditarFoto: editarFoto,
            ),

          ],
        ),
      ),
    );
  }
}