import 'package:flutter/material.dart';
import 'package:mandaily/auth/register.dart';
import 'package:mandaily/home/tela_consulta.dart';
import '../passos/passo5.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void _fazerLogin() async {
    // Validação simples para não enviar requisição vazia
    if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha e-mail e senha.')),
      );
      return;
    }

    // Exibe um indicador de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Center(child: CircularProgressIndicator()),
    );

    // ❗ MUITO IMPORTANTE: Use o IP da sua máquina, não localhost.
    const String apiUrl = 'http://192.168.1.128:3000/login'; // ⬅️ SUBSTITUA PELO SEU IP!

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{
          'email': _emailController.text.trim(), // .trim() remove espaços em branco
          'senha': _senhaController.text.trim(),
        }),
      );

      Navigator.pop(context); // Fecha o indicador de carregamento

      if (response.statusCode == 200) {
        // Sucesso no Login!
        final responseBody = jsonDecode(response.body);
        final userId = responseBody['Usuario']['_id']; // <-- ✨ PEGA O ID DO USUÁRIO

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', userId); // <-- ✨ SALVA O ID DO USUÁRIO

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TelaConsulta()),
              (Route<dynamic> route) => false,
        );
      } else {
        // Erro (e-mail/senha incorretos ou outro problema)
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${responseBody['message']}')),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Garante que o loading feche em caso de erro de conexão
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão com o servidor: $e')),
      );
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
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
              controller: _emailController, // Adicione esta linha
              decoration: _inputDecoration('...'),
              keyboardType: TextInputType.emailAddress, // Melhora a usabilidade
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
              controller: _senhaController, // Adicione esta linha
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
                  onPressed: _fazerLogin,
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  TelaConsulta()),
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
