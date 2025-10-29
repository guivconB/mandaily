import 'package:flutter/material.dart';
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
  bool temaEscuro1 = true;
//Defini as variáveis que controlam o perfil

  @override
  Widget build(BuildContext context) {
  //Esse método monta a interface visual da tela

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Perfis'), backgroundColor: Colors.grey[850]),
    //Estrutura a base da tela

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
      //Espaçamento interno

            PerfilComponentes(
              nome: 'Nome Sobrenome',
              nascimento: 'dd/mm/aaaa',
              notificacoes: notificacoes1,
              temaEscuro: temaEscuro1,
              onNotificacoesChanged: (val) => setState(() => notificacoes1 = val),
              onTemaChanged: (val) => setState(() => temaEscuro1 = val),
              isSelected: selectedPerfil == 1,
            ),
            //Cria o primeiro card de perfil
          ],
        ),
      ),
    );
  }
}