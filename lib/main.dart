import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Se for usar tipos específicos do FCM aqui

// Imports dos seus arquivos locais
import 'package:mandaily/home/tela_consulta.dart';
import 'firebase_options.dart';
import 'splascreen.dart';
import 'FCM.dart';

void main() async {
  // 1. Garanta que o Flutter esteja inicializado antes de usar plugins assíncronos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Configuração do FCM (Notificações)
  // É recomendável envolver em um try-catch caso haja erro de rede ou configuração
  try {
    String? fcmToken = await FCMService.getFCMToken();
    print("FCM Token no main: $fcmToken");
  } catch (e) {
    print("Erro ao obter Token FCM: $e");
  }

  // 4. Verifica o estado do login (Persistência de dados)
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // 5. Executa o app, passando o status de login
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManDaily',
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 6. Lógica de Roteamento Inicial:
      // Se logado -> TelaConsulta
      // Se não logado -> SplashScreen
      home: isLoggedIn ? const TelaConsulta() : const SplashScreen(),
    );
  }
}