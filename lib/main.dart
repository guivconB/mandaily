import 'package:flutter/material.dart';
import 'splascreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mandaily/home/tela_consulta.dart';

// 1. Transforme a função main em assíncrona
void main() async {
  // 2. Garanta que o Flutter esteja inicializado antes de usar plugins
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Verifique o estado do login
  final prefs = await SharedPreferences.getInstance();
  // Usa '?? false' para o caso de ser a primeira vez que o app abre e a chave não existe
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // 4. Passe a informação para o MyApp
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  // 5. Receba o status de login
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManDaily',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 6. Decida a tela inicial com base no status do login
      //    Se o usuário já está logado, ele pula a SplashScreen e vai direto para a TelaConsulta.
      //    Caso contrário, ele vê a SplashScreen, que então navegará para a tela de login/registro (Passo5).
      home: isLoggedIn ? const TelaConsulta() : const SplashScreen(),
    );
  }
}

