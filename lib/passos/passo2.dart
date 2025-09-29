import 'package:flutter/material.dart';

class Passo2 extends StatelessWidget {
  const Passo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/iconesaude.png',
              width: 500, // Considere ajustar o tamanho se for um ícone
              height: 150, // Considere ajustar o tamanho se for um ícone
            ),
            const SizedBox(height: 20),
            const Padding( // Adicionado Padding
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Anote as suas consultas médicas no ManDaily para que seja lembrado do seu compromisso com o profissional da saúde.", // Espaço adicionado
                textAlign: TextAlign.center, // Centraliza o texto
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Adicione um botão aqui se precisar navegar para um Passo3, por exemplo
            // const SizedBox(height: 30),
            // IconButton(
            //   icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
            //   onPressed: () {
            //     // Navegar para a próxima tela
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}