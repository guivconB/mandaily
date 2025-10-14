import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Criar',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontFamily: 'Nexa',
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              const Text(
                'Crie a sua conta',
                style: TextStyle(
                  color: Color(0xFFC4C4C4),
                  fontFamily: 'Coolvetica',


                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                'Nome',
                style: TextStyle(
                  color: Color(0xFFC4C4C4),
                  fontFamily: 'Coolvetica',


                  fontSize: 16,
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: '...',
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Endereço de E-mail',
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (val) {}),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Eu concordo com os ',
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Termos de Uso',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: ' e com as '),
                          TextSpan(
                            text: 'Políticas de Privacidade',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Criar Conta'),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {},
                child: const Text('Já possui uma conta? Entrar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
