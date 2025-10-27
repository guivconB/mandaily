import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mandaily/home/tela_consulta.dart';

class TelaRemedio extends StatefulWidget {
  const TelaRemedio({super.key});

  @override
  State<TelaRemedio> createState() => _TelaRemedioState();
}

class _TelaRemedioState extends State<TelaRemedio> {
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
      // A estrutura principal da tela (body) continua a mesma
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
                    IconButton(
                      icon: Image.asset('lib/assets/images/iconcalendar.png', width: 28, height: 28),
                      onPressed: () => print('Botão de Calendário pressionado!'),
                    ),
                    IconButton(
                      icon: Image.asset('lib/assets/images/icon3barras.png', width: 28, height: 28),
                      onPressed: () => print('Botão de Menu pressionado!'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // --- DATA ATUAL FORMATADA ---
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

                // --- SELETOR DE DIAS HORIZONTAL ---
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

      // --- INÍCIO DA NOVA SEÇÃO DE BOTÕES FLUTUANTES ---

      // 1. O Botão de Ação Flutuante Principal (o do meio)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Botão central (+) pressionado!');
        },
        backgroundColor: const Color(0xFF48484A), // Cinza escuro, como na imagem
        elevation: 4.0, // Uma pequena sombra para dar profundidade
        shape: const CircleBorder(), // Garante que ele seja perfeitamente redondo
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),

      // 2. A localização do botão principal
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 3. A barra inferior que segura os botões laterais
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF2C2C2E),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // --- ÍCONE DA ESQUERDA (INATIVO) ---
              IconButton(
                // Ícone de saúde vazio, para navegar para a tela de consulta.
                icon: Image.asset('lib/assets/images/saudevazio.png', width: 30, height: 30),
                onPressed: () {
                  // A navegação com PageRouteBuilder que já fizemos.
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

              // --- ÍCONE DA DIREITA (ATIVO) ---
              IconButton(
                // Ícone de pílula preenchido, pois estamos na tela de remédios.
                icon: Image.asset('lib/assets/images/iconepilula.png', width: 30, height: 30),
                onPressed: () {
                  // Ação desnecessária, já estamos nesta tela.
                  print('Já está na Tela de Remédio.');
                },
              ),
            ],
          ),
        ),
      ),
      // --- FIM DA SEÇÃO ---
    );
  }
}
