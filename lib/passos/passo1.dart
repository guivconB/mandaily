import 'package:flutter/material.dart';
// Importe Passo2 se não estiver usando rotas nomeadas para esta navegação específica
import 'passo2.dart';

class Passo1 extends StatelessWidget {
  const Passo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/images/fundopasso1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack( // Adicione o Stack aqui
          children: [
            Center(
            ),
            // Botão Avançar
            Positioned(
              right: 20,
              bottom: 20,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Passo2()),
                  );
                },
                child: Image.asset(
                  'lib/assets/images/avancar.png',
                  width: 100, // ajuste o tamanho se necessário
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}