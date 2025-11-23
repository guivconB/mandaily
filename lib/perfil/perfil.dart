import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets_perfil/perfil_componentes.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  int selectedPerfil = 1;
  bool notificacoes1 = true;
  File? fotoPerfil;

  // Variáveis locais para exibir na tela
  String _nomeUsuario = 'Carregando...';
  String _nascimentoUsuario = 'dd/mm/aaaa';

  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  // Função auxiliar para formatar data
  String _formatarData(String dataIso) {
    try {
      DateTime data = DateTime.parse(dataIso);
      return "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
    } catch (e) {
      return dataIso;
    }
  }

  Future<void> _carregarDadosUsuario() async {
    print("DEBUG: Iniciando carregamento de perfil...");
    final prefs = await SharedPreferences.getInstance();

    final nomeSalvo = prefs.getString('userName');
    final nascSalvo = prefs.getString('userNascimento');

    // 1. Tenta recuperar o caminho da imagem salva
    final imagemPath = prefs.getString('userProfileImage');

    print("DEBUG: Recuperado -> Nome: $nomeSalvo, ImagemPath: $imagemPath");

    setState(() {
      _nomeUsuario = nomeSalvo ?? 'Usuário não identificado';

      if (nascSalvo != null) {
        _nascimentoUsuario = _formatarData(nascSalvo);
      } else {
        _nascimentoUsuario = 'dd/mm/aaaa';
      }

      // 2. Se existir um caminho salvo, recria o arquivo da imagem
      if (imagemPath != null && imagemPath.isNotEmpty) {
        // Verifica se o arquivo ainda existe no celular
        final arquivoImagem = File(imagemPath);
        if (arquivoImagem.existsSync()) {
          fotoPerfil = arquivoImagem;
        }
      }
    });
  }

  Future<void> editarFoto() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      // 3. Salva o novo caminho no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userProfileImage', imagem.path);

      setState(() {
        fotoPerfil = File(imagem.path);
      });

      print("DEBUG: Nova imagem salva em: ${imagem.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text('Perfis'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            PerfilComponentes(
              nome: _nomeUsuario,
              nascimento: _nascimentoUsuario,
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
