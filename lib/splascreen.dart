import 'package:flutter/material.dart';
import 'passos/passo1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Aguarda 3 segundos e depois navega para a próxima tela
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Passo1(), // 👈 troque pela tela desejada
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Image.asset(
          'lib/assets/images/logo.png', // sua logo
          width: 800,
          height: 250,
        ),
      ),
    );
  }
}
