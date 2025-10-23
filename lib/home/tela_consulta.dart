import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mandaily/home/remedios/adicionar_remedio.dart';
import 'package:mandaily/home/remedios/tela_remedio.dart';
import 'package:mandaily/calendar_screen.dart'; // 1. Importe a nova tela

class TelaConsulta extends StatefulWidget {
  const TelaConsulta({super.key});

  @override
  State<TelaConsulta> createState() => _TelaConsultaState();
}

class _TelaConsultaState extends State<TelaConsulta> {
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
            image: AssetImage('lib/assets/images/fundo_consulta.jpg'),
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
                      // 2. Modifique o onPressed para navegar
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CalendarScreen()),
                        );
                      },
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
                            color: isSelected ? const Color(0xFF007AFF) : Colors.black.withOpacity(0.2),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdicionarRemedio()),
          );
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
        color: const Color(0xFF2C2C2E), // Cor da barra inferior
        shape: const CircularNotchedRectangle(), // Cria o "entalhe" para o botão central
        notchMargin: 8.0, // O espaço entre o botão e a barra
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // --- BOTÃO DA ESQUERDA (MODIFICADO) ---
              IconButton(
                // Substituímos o Icon por Image.asset
                // **IMPORTANTE**: Coloque o caminho correto da sua imagem aqui!
                icon: Image.asset('lib/assets/images/iconesaude.png', width: 30, height: 30),
                onPressed: () {
                  print('Botão da esquerda pressionado!');
                },
              ),
              // --- BOTÃO DA DIREITA (MODIFICADO) ---
              IconButton(
                // Substituímos o Icon por Image.asset
                // **IMPORTANTE**: Coloque o caminho correto da sua imagem aqui!
                icon: Image.asset('lib/assets/images/iconpilula.png', width: 30, height: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaRemedio()),
                  );

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
