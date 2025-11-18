import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mandaily/anotacoes.dart';
import 'package:mandaily/home/remedios/adicionar_consulta.dart';
import 'package:mandaily/home/remedios/tela_remedio.dart';
import 'package:mandaily/calendar_screen.dart';
import 'package:mandaily/perfil/perfil.dart';
import 'package:mandaily/splascreen.dart'; // Importante para o redirecionamento do Logout

// --- MODELO DE DADOS ---
class Consulta {
  final String id;
  final String nomeConsulta;
  final String? nomeProfissional;
  final String? endereco;
  final String horario;
  final DateTime data;

  Consulta({
    required this.id,
    required this.nomeConsulta,
    this.nomeProfissional,
    this.endereco,
    required this.horario,
    required this.data,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json['_id'],
      nomeConsulta: json['nomeConsulta'],
      nomeProfissional: json['nomeProfissional'],
      endereco: json['endereco'],
      horario: json['horario'],
      data: DateTime.parse(json['data']),
    );
  }
}

// --- TELA PRINCIPAL ---
class TelaConsulta extends StatefulWidget {
  const TelaConsulta({super.key});

  @override
  State<TelaConsulta> createState() => _TelaConsultaState();
}

class _TelaConsultaState extends State<TelaConsulta> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late DateTime _selectedDate;
  final List<DateTime> _diasDoMes = [];
  late Future<List<Consulta>> _futureConsultas;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    final agora = DateTime.now();
    _selectedDate = DateTime(agora.year, agora.month, agora.day);
    for (int i = 0; i < 15; i++) {
      _diasDoMes.add(agora.add(Duration(days: i)));
    }
    _futureConsultas = _buscarConsultasDoUsuario();
  }

  // --- FUNÇÃO DE LOGOUT (NOVO) ---
  Future<void> _fazerLogout() async {
    // 1. Mostra confirmação
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text('Sair', style: TextStyle(color: Colors.white)),
        content: const Text('Deseja realmente sair da sua conta?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      // 2. Limpa o SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Remove login, token, userId, etc.

      if (!mounted) return;

      // 3. Redireciona para a Splash ou Login e remove o histórico de navegação
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  // --- BUSCAR CONSULTAS (API) ---
  Future<List<Consulta>> _buscarConsultasDoUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) return [];

    // ❗ ATENÇÃO: Verifique seu IP
    final String apiUrl = 'http://192.168.1.128:3000/consulta';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> consultasJson = jsonDecode(response.body);

        return consultasJson
            .map((json) => Consulta.fromJson(json))
            .where((consulta) {
          bool isSameDay = consulta.data.year == _selectedDate.year &&
              consulta.data.month == _selectedDate.month &&
              consulta.data.day == _selectedDate.day;
          // Filtrar por usuário se a API retornar todos
          // bool pertenceAoUsuario = consulta.userId == userId;
          return isSameDay;
        }).toList();
      } else {
        throw Exception('Falha ao carregar as consultas.');
      }
    } catch (e) {
      throw Exception('Erro de conexão: ${e.toString()}');
    }
  }

  // --- DELETAR CONSULTA ---
  Future<void> _deletarConsulta(String consultaId) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C2C2C),
          title: const Text('Confirmar Exclusão', style: TextStyle(color: Colors.white)),
          content: const Text('Você tem certeza que deseja deletar esta consulta?', style: TextStyle(color: Colors.white70)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Deletar', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    try {
      // ❗ ATENÇÃO: Verifique seu IP
      final String apiUrl = 'http://192.168.1.128:3000/consulta/$consultaId';
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consulta deletada com sucesso!'), backgroundColor: Colors.green),
        );
        setState(() {
          _futureConsultas = _buscarConsultasDoUsuario();
        });
      } else {
        throw Exception('Falha ao deletar a consulta.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }

  void _onDateSelected(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      _futureConsultas = _buscarConsultasDoUsuario();
    });
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // --- DRAWER COM LOGOUT ---
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E1E1E),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Color(0xFF2C2C2E)),
                    child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.white),
                    title: const Text('Início', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.note, color: Colors.white),
                    title: const Text('Anotações', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AnotacoesPage())),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.white),
                    title: const Text('Perfil', style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil())),
                  ),
                ],
              ),
            ),
            // Botão de Sair fixo no final ou adicionado na lista
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Sair da conta', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: _fazerLogout, // Chama a função de logout
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('lib/assets/images/fundo_consulta.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Image.asset('lib/assets/images/iconcalendar.png', width: 28, height: 28),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarScreen())),
                    ),
                    IconButton(
                      icon: Image.asset('lib/assets/images/icon3barras.png', width: 28, height: 28),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  capitalize(DateFormat('EEE, dd \'de\' MMMM', 'pt_BR').format(_selectedDate)),
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text('Hoje', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _diasDoMes.length,
                    itemBuilder: (context, index) {
                      final dia = _diasDoMes[index];
                      final isSelected = dia.day == _selectedDate.day;
                      return GestureDetector(
                        onTap: () => _onDateSelected(dia),
                        child: Container(
                          width: 55,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF007AFF) : Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(dia.day.toString(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(capitalize(DateFormat.E('pt_BR').format(dia)), style: TextStyle(color: isSelected ? Colors.white : Colors.grey[400], fontSize: 14)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),

                // --- LISTA DE CONSULTAS ---
                Expanded(
                  child: FutureBuilder<List<Consulta>>(
                    future: _futureConsultas,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Nenhuma consulta agendada para este dia.', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        );
                      } else {
                        final consultas = snapshot.data!;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: consultas.length,
                          itemBuilder: (context, index) {
                            final consulta = consultas[index];
                            return _buildConsultaCard(consulta);
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdicionarConsulta()),
          ).then((_) {
            setState(() {
              _futureConsultas = _buscarConsultasDoUsuario();
            });
          });
        },
        backgroundColor: const Color(0xFF48484A),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF2C2C2E),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Image.asset('lib/assets/images/iconesaude.png', width: 30, height: 30),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset('lib/assets/images/iconpilula.png', width: 30, height: 30),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const TelaRemedio(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- CARD DA CONSULTA ---
  Widget _buildConsultaCard(Consulta consulta) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF007AFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      consulta.nomeConsulta,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    consulta.horario,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (consulta.nomeProfissional != null && consulta.nomeProfissional!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    consulta.nomeProfissional!,
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
                  ),
                ),
              if (consulta.endereco != null && consulta.endereco!.isNotEmpty)
                Text(
                  consulta.endereco!,
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 15,
          child: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white70, size: 28),
            onPressed: () => _deletarConsulta(consulta.id),
          ),
        ),
      ],
    );
  }
}