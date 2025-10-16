import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _dataController = TextEditingController();
  bool _termosAceitos = false;

  // Função para padronizar o estilo dos TextFields
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white70,
        fontFamily: 'Coolvetica',
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
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


            // Botão de voltar

            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
            ),

            const Center(
              child: Column(
                children: [
                  // Título "Criar"
                  Text(
                    'Criar',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nexa',
                      fontWeight: FontWeight.w900,
                      fontSize: 43,
                      letterSpacing: -3,
                    ),
                  ),
                  // Subtítulo "Crie a sua conta"
                  Text(
                    'Crie a sua conta',
                    style: TextStyle(
                      color: Color(0xFFC4C4C4),
                      fontFamily: 'Coolvetica',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),


            // Campo Nome

            const Text(
              'Nome',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Coolvetica',
                fontSize: 23,
              ),
            ),
            TextField(
              decoration: _inputDecoration('...'),
            ),

            const SizedBox(height: 15),


            // Campo Data de Nascimento

            const Text(
              'Data de Nascimento',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Coolvetica',
                fontSize: 23,
              ),
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _dataController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            surface: Color(0xFF1E1E1E),
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: const Color(0xFF2C2C2C),
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                    DateFormat('dd/MM/yyyy').format(pickedDate);
                    setState(() {
                      _dataController.text = formattedDate;
                    });
                  }
                },
                decoration: _inputDecoration('00/00/0000'),
              ),
            ),

            const SizedBox(height: 15),


            // Campo E-mail

            const Text(
              'Endereço de E-mail',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Coolvetica',
                fontSize: 23,
              ),
            ),
            TextField(
              decoration: _inputDecoration('...'),
            ),

            const SizedBox(height: 15),


            // Campo Senha

            const Text(
              'Senha',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Coolvetica',
                fontSize: 23,
              ),
            ),
            TextField(
              obscureText: true,
              decoration: _inputDecoration('••••••••'),
            ),

            const SizedBox(height: 15),


            // Campo Confirmar Senha

            const Text(
              'Confirmar Senha',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Coolvetica',
                fontSize: 23,
              ),
            ),
            TextField(
              obscureText: true,
              decoration: _inputDecoration('••••••••'),
            ),

            const SizedBox(height: 20),


            // Checkbox - Termos de Uso

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _termosAceitos,
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                  side: const BorderSide(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      _termosAceitos = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Coolvetica',
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(text: 'Eu concordo com os '),
                        TextSpan(
                          text: 'Termos de Uso',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        TextSpan(text: ' e com as '),
                        TextSpan(
                          text: 'Políticas de Privacidade',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),


            // Botão Criar Conta

            Center(
              child: ElevatedButton(
                onPressed: _termosAceitos
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Conta criada com sucesso!"),
                    ),
                  );
                }
                    : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey[500]!; // botão desativado mais claro
                      }
                      return Colors.white; // botão ativo
                    },
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 18),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: Text(
                  'Criar Conta',
                  style: TextStyle(
                    color:
                    _termosAceitos ? Colors.black : Colors.white70, // texto
                    fontFamily: 'Coolvetica',
                    fontSize: 20,
                  ),
                ),
              ),
            ),


            // Texto "Já possui uma conta? Entrar"

            const SizedBox(height: 10),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Já possui uma conta? ',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Coolvetica',
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Coolvetica',
                        fontSize: 14,
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
