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

    // ❗ MUITO IMPORTANTE: Use o IP da sua máquina.
    const String apiUrl = 'http://192.168.1.128:3000/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{
          'email': _emailController.text.trim(),
          'senha': _senhaController.text.trim(),
        }),
      );

      Navigator.pop(context); // Fecha o indicador de carregamento

      if (response.statusCode == 200) {
        // Sucesso no Login!
        final responseBody = jsonDecode(response.body);
        print("DEBUG: Resposta do Login: $responseBody"); // VEJA ISSO NO CONSOLE

        // Acessa o objeto Usuario
        final usuarioData = responseBody['Usuario'];

        if (usuarioData != null) {
          final userId = usuarioData['_id'].toString();
          final userName = usuarioData['nome']?.toString(); // O ? evita crash se for null
          final userNascimento = usuarioData['dataNascimento']?.toString();

          print("DEBUG: Tentando salvar -> ID: $userId, Nome: $userName, Nasc: $userNascimento");

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userId', userId);

          if (userName != null) {
            await prefs.setString('userName', userName);
          }
          if (userNascimento != null) {
            await prefs.setString('userNascimento', userNascimento);
          }

          print("DEBUG: Dados salvos no SharedPreferences com sucesso!");
        } else {
          print("DEBUG: ERRO - Objeto 'Usuario' veio nulo do backend");
        }

        // Navega apenas DEPOIS de salvar tudo
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TelaConsulta()),
                (Route<dynamic> route) => false,
          );
        }

      } else {
        // Erro (e-mail/senha incorretos ou outro problema)
        final responseBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${responseBody['message']}')),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Garante que o loading feche em caso de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão com o servidor: $e')),
      );
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

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
              controller: _emailController,
              decoration: _inputDecoration('...'),
              keyboardType: TextInputType.emailAddress,
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
              controller: _senhaController,
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
                width: 280,
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
