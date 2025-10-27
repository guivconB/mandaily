import 'package:flutter/material.dart';
import 'passo1.dart';
import 'passo3.dart';

class Passo2 extends StatelessWidget {
  const Passo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/images/fundopasso2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack( // Adicione o Stack aqui
          children: [
            Center(
            ),
            // Botão Voltar
            Positioned(
              left: 20,
              bottom: 20,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Passo1()),
                  );
                },
                child: Image.asset(
                  'lib/assets/images/voltar.png',
                  width: 100, // ajuste o tamanho se necessário
                ),
              ),
            ),
            // Botão Avançar
            Positioned(
              right: 20,
              bottom: 20,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Passo3()),
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