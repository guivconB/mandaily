import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mandaily/home/remedios/adicionar_remedio.dart';
import 'package:mandaily/home/tela_consulta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdicionarConsulta extends StatefulWidget {
  const AdicionarConsulta({super.key});

  @override
  State<AdicionarConsulta> createState() => _AdicionarConsultaState();
}

class _AdicionarConsultaState extends State<AdicionarConsulta> {
  String? _tipoSelecionado;

  final TextEditingController _nomeConsultaController = TextEditingController();
  final TextEditingController _nomeProfissionalController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _dosagemController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();

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
      fillColor: const Color(0xFF616161),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }
  Future<void> _criarConsulta() async {
    // Validação simples dos campos
    if (_nomeConsultaController.text.isEmpty ||
        _dataController.text.isEmpty ||
        _horaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatórios.')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Obter o ID do usuário salvo durante o login
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) {
        throw Exception("Usuário não logado. ID não encontrado.");
      }

      // Formatar data para o padrão ISO que o backend espera (YYYY-MM-DD)
      final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
      final DateTime dateTime = inputFormat.parse(_dataController.text);
      final String dataFormatada = dateTime.toIso8601String();

      const String apiUrl = 'http://192.168.1.128:3000/consulta'; // ⬅️ SUBSTITUA PELO SEU IP!

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'userId': userId,
          'nomeConsulta': _nomeConsultaController.text,
          'nomeProfissional': _nomeProfissionalController.text,
          'endereco': _enderecoController.text,
          'horario': _horaController.text,
          'data': dataFormatada,
        }),
      );

      Navigator.pop(context); // Fecha o loading

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Consulta adicionada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        // Volta para a tela anterior
        Navigator.pop(context);
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception('Erro ao criar consulta: ${responseBody['error']}');
      }
    } catch (e) {
      Navigator.pop(context); // Fecha o loading em caso de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
      _dataController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
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
          ),
        );
      },
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      _horaController.text = DateFormat('HH:mm').format(
        DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute),
      );
    }
  }

  @override
  void dispose() {
    _nomeConsultaController.dispose();
    _nomeProfissionalController.dispose();
    _enderecoController.dispose();
    _dosagemController.dispose();
    _dataController.dispose();
    _horaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/fundo_adicionar.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const TelaConsulta()),
                            );
                          }
                        },
                      ),
                      const Center(
                        child: Text(
                          'Adicionar',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Nexa',
                            fontWeight: FontWeight.w900,
                            fontSize: 35,
                            letterSpacing: -3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Nova Consulta',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Coolvetica',
                          fontSize: 40,
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Categoria',
                          style: TextStyle(
                            color: Color(0xFFC4C4C4),
                            fontFamily: 'Coolvetica',
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Row de botões
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Consulta
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007AFF),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            ),
                            child: const Text(
                              'Consulta',
                              style: TextStyle(fontFamily: 'Coolvetica', fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 44),

                          // Remédio
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                  const AdicionarRemedio(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'lib/assets/images/botaoremedioapagado.png',
                                  width: 120,
                                  height: 120,
                                ),


                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Campos da consulta
                      const Text('Nome da consulta', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                      TextField(controller: _nomeConsultaController, style: const TextStyle(color: Colors.white), decoration: _inputDecoration('...')),
                      const SizedBox(height: 20),

                      const Text('Nome do profissional', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                      TextField(controller: _nomeProfissionalController, style: const TextStyle(color: Colors.white), decoration: _inputDecoration('...')),
                      const SizedBox(height: 20),

                      const Text('Endereço', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                      TextField(controller: _enderecoController, style: const TextStyle(color: Colors.white), decoration: _inputDecoration('...')),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Horário', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _horaController,
                                  readOnly: true,
                                  onTap: _selectTime,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration('00:00'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Data', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _dataController,
                                  readOnly: true,
                                  onTap: _selectDate,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration('00/00/0000'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 150),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Botão
          Positioned(
            bottom: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: _criarConsulta,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Adicionar Consulta',
                style: TextStyle(color: Colors.black, fontFamily: 'Coolvetica', fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
