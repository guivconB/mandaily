import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // cor de fundo
      body: Center(
        child: Image.asset(
          'assets/logo.png', // caminho da logo (adicione em pubspec.yaml)
          width: 150, // ajuste o tamanho conforme precisar
          height: 150,
        ),
      ),
    );
  }
}
