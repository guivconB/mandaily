import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mandaily/anotacoes.dart';
import 'package:mandaily/calendar_screen.dart';
import 'package:mandaily/home/remedios/adicionar_remedio.dart';
import 'package:mandaily/home/tela_consulta.dart';

class TelaRemedio extends StatefulWidget {
  const TelaRemedio({super.key});

  @override
  State<TelaRemedio> createState() => _TelaRemedioState();
}

class _TelaRemedioState extends State<TelaRemedio> {
  // --- ADIÇÃO 1: Chave global para o Scaffold (para controlar o Drawer) ---
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late DateTime _selectedDate;
  final List<DateTime> _diasDoMes = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    final agora = DateTime.now();
    _selectedDate = DateTime(agora.year, agora.month, agora.day);
    for (int i = 0; i < 15; i++) {
      _diasDoMes.add(agora.add(Duration(days: i)));
    }
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- ADIÇÃO 2: Associar a chave ao Scaffold ---
      key: _scaffoldKey,

      // --- ADIÇÃO 3: Adicionar o Drawer (menu lateral) ---
      // (Copiado da tela_consulta.dart para consistência)
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E1E1E),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF2C2C2E),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Início', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.note, color: Colors.white),
              title: const Text('Anotações', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AnotacoesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('Perfil', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      // O body da tela permanece o mesmo
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
                // --- BARRA SUPERIOR (HEADER) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // --- MODIFICAÇÃO 1: Ação do botão do Calendário ---
                    IconButton(
                      icon: Image.asset('lib/assets/images/iconcalendar.png', width: 28, height: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CalendarScreen()),
                        );
                      },
                    ),
                    // --- MODIFICAÇÃO 2: Ação do botão de Menu (3 barras) ---
                    IconButton(
                      icon: Image.asset('lib/assets/images/icon3barras.png', width: 28, height: 28),
                      onPressed: () {
                        // Abre o Drawer
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  capitalize(DateFormat('EEE, dd \'de\' MMMM', 'pt_BR').format(_selectedDate)),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hoje',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                        onTap: () {
                          setState(() {
                            _selectedDate = dia;
                          });
                        },
                        child: Container(
                          width: 55,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF55CE98) : Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dia.day.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                capitalize(DateFormat.E('pt_BR').format(dia)),
                                style: TextStyle(color: isSelected ? Colors.white : Colors.grey[400], fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // --- MODIFICAÇÃO 3: Ação do Botão Flutuante Central ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega para a tela de adicionar remédio
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarRemedio()),
          );
        },
        backgroundColor: const Color(0xFF48484A),
        elevation: 4.0,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // A BottomAppBar já estava correta, com a troca de ícones e navegação.
      // Nenhuma alteração necessária aqui.
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
                      pageBuilder: (context, animation, secondaryAnimation) => const TelaConsulta(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Image.asset('lib/assets/images/iconepilula.png', width: 30, height: 30),
                onPressed: () {
                  print('Já está na Tela de Remédio.');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
