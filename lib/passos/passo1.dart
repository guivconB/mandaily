import 'package:flutter/material.dart';
// Importe Passo2 se não estiver usando rotas nomeadas para esta navegação específica
import 'passo2.dart';

class Passo1 extends StatelessWidget {
  const Passo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/logo.png',
              width: 500,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Padding( // Adicionado Padding para melhor visualização do texto
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Bem vindo ao ManDaily, um aplicativo de gerenciamento de agenda voltado à saúde do homem.",
                textAlign: TextAlign.center, // Centraliza o texto
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30), // Espaço antes do botão
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40), // Ícone de seta
              onPressed: () {
                // Se estiver usando a Opção 1 do main.dart (navegação manual):
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Passo2()),
                );
                // Se estiver usando a Opção 2 do main.dart (rotas nomeadas):
                // Navigator.pushNamed(context, '/passo2');
              },
            ),
          ],
        ),
      ),
    );
  }
}