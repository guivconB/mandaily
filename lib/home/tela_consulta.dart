import 'package:flutter/material.dart';

class TelaConsulta extends StatelessWidget {
  const TelaConsulta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/fundo_consulta.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            // --- INÍCIO DO BOTÃO ESQUERDO (CALENDÁRIO) ---
            Positioned(
              top: 40.0,  // Distância do topo da tela
              left: 20.0, // Distância da esquerda da tela
              child: IconButton(
                // O ícone do botão será a sua imagem
                icon: Image.asset('lib/assets/images/iconcalendar.png'),
                iconSize: 40, // Defina um tamanho para o ícone
                // A ação que acontece ao pressionar o botão
                onPressed: () {
                  // Ação para o botão de calendário
                  print('Botão de Calendário pressionado!');
                  // TODO: Adicionar navegação para a tela de calendário aqui
                  // Ex: Navigator.push(context, MaterialPageRoute(builder: (context) => TelaCalendario()));
                },
              ),
            ),
            // --- FIM DO BOTÃO ESQUERDO ---

            // --- INÍCIO DO BOTÃO DIREITO (MENU) ---
            Positioned(
              top: 40.0,   // Mesma distância do topo para alinhar horizontalmente
              right: 20.0, // Distância da direita da tela
              child: IconButton(
                // O ícone do botão será a sua outra imagem
                icon: Image.asset('lib/assets/images/icon3barras.png'),
                iconSize: 40, // Use o mesmo tamanho para manter a consistência
                // A ação que acontece ao pressionar o botão
                onPressed: () {
                  // Ação para o botão de menu
                  print('Botão de Menu pressionado!');
                  // TODO: Adicionar navegação para a tela de menu/configurações aqui
                  // Ex: Navigator.push(context, MaterialPageRoute(builder: (context) => TelaMenu()));
                },
              ),
            ),
            // --- FIM DO BOTÃO DIREITO ---

            // Você pode continuar adicionando outros widgets aqui
          ],
        ),
      ),
    );
  }
}
