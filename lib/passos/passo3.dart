import 'package:flutter/material.dart';
import 'passo4.dart'; // importa a próxima tela se existir

class Passo3 extends StatelessWidget {
  const Passo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/iconepilula.png', // imagem diferente se quiser
              width: 400,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Os remédios que está utilizando no momento para ser alertado na frequência que você precisa consumi-los.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Passo4()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}