import 'package:flutter/material.dart';
import 'package:mandaily/auth/register.dart';
import 'package:mandaily/splascreen.dart';
import '../passos/passo5.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // função pra padronizar o estilo dos textfields
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white70,
        fontFamily: 'Coolvetica',
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      filled: true,
      fillColor: Colors.grey[700],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Passo5()),
                );
              },
            ),

            const Center(
              child: Column(
                children: [
                  Text(
                    'Entrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nexa',
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                      letterSpacing: -3,
                    ),
                  ),

                  // subtítulo
                  Text(
                    'Entre com a sua conta',
                    style: TextStyle(
                      color: Color(0xFFC4C4C4),
                      fontFamily: 'Coolvetica',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 90),

            // campo email
            const Text(
              'Endereço de E-mail',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Coolvetica',
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: _inputDecoration('...'),
            ),

            const SizedBox(height: 16),

            const Text(
              'Senha',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Coolvetica',
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: _inputDecoration('••••••••'),
            ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Recuperar senha')),
                  );
                },
                child: const Text(
                  'Esqueceu a senha?',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Coolvetica',
                    fontSize: 22,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 90),

            Center(
              child: SizedBox(
                width: 280, // a largura
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SplashScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontFamily: 'Coolvetica',
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // texto "não possui uma conta?"
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Não possui uma conta? ',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Coolvetica',
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Register()),
                      );
                    },
                    child: const Text(
                      'Criar',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Coolvetica',
                        fontSize: 18,
                        decoration: TextDecoration.underline,

                      ),

                    ),
                  ),
                ],
              ),
            ),



          ],

        ),

      ),

    );
  }
}
