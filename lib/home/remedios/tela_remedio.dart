import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mandaily/anotacoes.dart';
import 'package:mandaily/calendar_screen.dart';
import 'package:mandaily/home/remedios/adicionar_remedio.dart';
import 'package:mandaily/home/tela_consulta.dart';
import 'package:mandaily/perfil/perfil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mandaily/splascreen.dart';

// 1. Classe de Modelo (Data Model) para o Remédio
class Medicamento {
  final String id;
  final String nome;
  final String tipo;
  final int? dose;
  final String horarioInicio;
  final DateTime dataInicio;
  // Adicione outros campos se precisar exibi-los

  Medicamento({
    required this.id,
    required this.nome,
    required this.tipo,
    this.dose,
    required this.horarioInicio,
    required this.dataInicio,
  });

  factory Medicamento.fromJson(Map<String, dynamic> json) {
    return Medicamento(
      id: json['_id'],
      nome: json['nome'],
      tipo: json['tipo'],
      dose: json['dose'],
      horarioInicio: json['horarioInicio'],
      dataInicio: DateTime.parse(json['dataInicio']),
    );
  }
}


class TelaRemedio extends StatefulWidget {
  const TelaRemedio({super.key});

  @override
  State<TelaRemedio> createState() => _TelaRemedioState();
}

class _TelaRemedioState extends State<TelaRemedio> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late DateTime _selectedDate;
  final List<DateTime> _diasDoMes = [];

  // 2. Estado para a busca de dados
  late Future<List<Medicamento>> _futureMedicamentos;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    final agora = DateTime.now();
    _selectedDate = DateTime(agora.year, agora.month, agora.day);
    for (int i = 0; i < 15; i++) {
      _diasDoMes.add(agora.add(Duration(days: i)));
    }
    // Inicia a busca assim que a tela é construída
    _futureMedicamentos = _buscarMedicamentosDoUsuario();
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
  // 3. Função para buscar os dados na API
  Future<List<Medicamento>> _buscarMedicamentosDoUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      return []; // Retorna lista vazia se não houver usuário logado
    }

    // ❗ ATENÇÃO: Substitua pelo IP da sua máquina!
    final String apiUrl = 'http://192.168.1.128:3000/medicamentos';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> medicamentosJson = jsonDecode(response.body);

        // Mapeia o JSON para objetos Medicamento e filtra pela data selecionada
        return medicamentosJson
            .map((json) => Medicamento.fromJson(json))
            .where((medicamento) {
          // Lógica de filtro: mostrar se a data selecionada está dentro do período de tratamento
          final dataInicio = medicamento.dataInicio;
          // NOTA: A lógica de "numeroDias" precisaria ser implementada aqui se fosse complexa.
          // Por simplicidade, vamos mostrar todos os remédios agendados para a data selecionada ou antes dela.
          // O ideal seria filtrar pelo 'userId' também.
          bool isSameDay = medicamento.dataInicio.year == _selectedDate.year &&
              medicamento.dataInicio.month == _selectedDate.month &&
              medicamento.dataInicio.day == _selectedDate.day;

          // Em um app real, o backend deveria ter uma rota /medicamentos/user/:userId
          // bool pertenceAoUsuario = json['userId'] == userId;

          return isSameDay; // && pertenceAoUsuario;
        }).toList();
      } else {
        throw Exception('Falha ao carregar os medicamentos.');
      }
    } catch (e) {
      throw Exception('Erro de conexão: ${e.toString()}');
    }
  }

  // 4. Função para atualizar a lista ao mudar de data
  void _onDateSelected(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      _futureMedicamentos = _buscarMedicamentosDoUsuario();
    });
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          image: DecorationImage(
            image: AssetImage('lib/assets/images/fundo_remedio.jpg'),
            fit: BoxFit.cover,
          ),
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
                      final isSelected = dia.day == _selectedDate.day && dia.month == _selectedDate.month;
                      return GestureDetector(
                        onTap: () => _onDateSelected(dia),
                        child: Container(
                          width: 55,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF55CE98) : Colors.black.withOpacity(0.2),
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
                const SizedBox(height: 20),

                // 5. Lista de Remédios com FutureBuilder
                Expanded(
                  child: FutureBuilder<List<Medicamento>>(
                    future: _futureMedicamentos,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Nenhum remédio para hoje.', style: TextStyle(color: Colors.white70, fontSize: 16)));
                      }

                      final medicamentos = snapshot.data!;
                      return ListView.builder(
                        itemCount: medicamentos.length,
                        itemBuilder: (context, index) {
                          final remedio = medicamentos[index];
                          // O primeiro item é "ativo"
                          final isAtivo = index == 0;
                          return _buildRemedioCard(remedio, isAtivo);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega para a tela de adicionar e aguarda um resultado
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarRemedio()),
          );
          // Se a tela de adicionar retornou 'true', atualiza a lista
          if (result == true) {
            setState(() {
              _futureMedicamentos = _buscarMedicamentosDoUsuario();
            });
          }
        },
        backgroundColor: const Color(0xFF48484A),
        elevation: 4.0,
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
                icon: Image.asset('lib/assets/images/saudevazio.png', width: 30, height: 30),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, _, __) => const TelaConsulta(),
                      transitionsBuilder: (context, a, _, c) => FadeTransition(opacity: a, child: c),
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Image.asset('lib/assets/images/iconepilula.png', width: 30, height: 30),
                onPressed: () => print('Já está na Tela de Remédio.'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 6. Widget para construir o Card do Remédio
  Widget _buildRemedioCard(Medicamento remedio, bool isAtivo) {
    final cardColor = isAtivo ? const Color(0xFF55CE98) : const Color(0xFF3A3A3C);
    final textColor = isAtivo ? Colors.black : Colors.white;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline (linha vertical com círculos)
          SizedBox(
            width: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          // Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        remedio.nome,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Coolvetica',
                        ),
                      ),
                      Text(
                        remedio.horarioInicio,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontFamily: 'Coolvetica',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${remedio.dose} ${remedio.tipo}(s)',
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontSize: 16,
                      fontFamily: 'Coolvetica',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
