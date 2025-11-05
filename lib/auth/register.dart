import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mandaily/validators/user_validators.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mandaily/auth/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  bool _termosAceitos = false;

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

  void _criarConta() async {
    if (!_termosAceitos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você deve aceitar os Termos de Uso.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      const String apiUrl = 'http://192.168.1.9:3000/user'; // ✅ MANTENHA SEU IP!

      try {
        // --- ✨ INÍCIO DA CORREÇÃO ---
        // 1. Converte o texto da data (ex: "31/10/2025") para um objeto DateTime.
        final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
        final DateTime dateTime = inputFormat.parse(_dataController.text);

        // 2. Formata o objeto DateTime para o padrão ISO 8601 (ex: "2025-10-31T...")
        final String dataFormatadaParaBackend = dateTime.toIso8601String();
        // --- ✨ FIM DA CORREÇÃO ---

        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'nome': _nomeController.text,
            'email': _emailController.text,
            'senha': _senhaController.text,
            'dataNascimento': dataFormatadaParaBackend, // <-- ✨ USANDO A DATA FORMATADA
          }),
        );

        Navigator.pop(context); // Fecha o indicador de carregamento

        if (response.statusCode == 201) {
          // Sucesso!
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Conta criada com sucesso! Faça o login.")),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false,
          );
        } else {
          // Erro do servidor (ex: e-mail já existe)
          final responseBody = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: ${responseBody['message']}')),
          );
        }
      } catch (e) {
        Navigator.pop(context); // Fecha o indicador de carregamento
        // Agora o erro de conexão será mais específico para problemas de rede
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro de conexão: $e. Verifique o IP e a rede.')),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // ✅ Chave do formulário
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // Botão voltar
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),

              const Center(
                child: Column(
                  children: [
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

              // Nome
              const Text('Nome', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
              TextFormField(
                controller: _nomeController,
                decoration: _inputDecoration('...'),
                validator: UserValidators.validarNome,
              ),

              const SizedBox(height: 15),

              // Data de nascimento
              const Text('Data de Nascimento', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
              SizedBox(
                width: 200,
                child: TextFormField(
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
                      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                      setState(() {
                        _dataController.text = formattedDate;
                      });
                    }
                  },
                  decoration: _inputDecoration('00/00/0000'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecione sua data de nascimento';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 15),

              // Email
              const Text('Endereço de E-mail', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('...'),
                validator: UserValidators.validarEmail,
              ),

              const SizedBox(height: 15),

              // Senha
              const Text('Senha', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: _inputDecoration('••••••••'),
                validator: UserValidators.validarSenha,
              ),

              const SizedBox(height: 15),

              // Confirmar Senha
              const Text('Confirmar Senha', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
              TextFormField(
                controller: _confirmarSenhaController,
                obscureText: true,
                decoration: _inputDecoration('••••••••'),
                validator: (value) => UserValidators.confirmarSenha(value, _senhaController.text),
              ),

              const SizedBox(height: 20),

              // Checkbox Termos
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _termosAceitos,
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    side: const BorderSide(color: Colors.white),
                    onChanged: (value) => setState(() => _termosAceitos = value ?? false),
                  ),
                  const Expanded(
                    child: Text(
                      'Eu concordo com os Termos de Uso e Políticas de Privacidade',
                      style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Botão Criar Conta
              Center(
                child: ElevatedButton(
                  onPressed: _criarConta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Criar Conta', style: TextStyle(color: Colors.black, fontFamily: 'Coolvetica', fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
