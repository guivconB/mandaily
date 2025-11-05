import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mandaily/home/tela_consulta.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'splascreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'FCM.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa o Flutter antes do Firebase

  // Inicializa o Firebase com as opções do seu projeto
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String? fcmToken = await FCMService.getFCMToken();
  print("FCM Token no main: $fcmToken");

  // Verifica o estado do login
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Executa o app, passando o status de login
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManDaily',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Define a tela inicial com base no status de login
      home: isLoggedIn ? const TelaConsulta() : const SplashScreen(),
    );
  }
}
