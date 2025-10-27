import 'package:flutter/material.dart';
import 'package:mandaily/anotacoes.dart'; // <<< ADIÇÃO 1: Importar tela de anotações
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // --- ADIÇÃO 2: Chave global para o Scaffold (para controlar o Drawer) ---
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Função para normalizar data (sem horas)
  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateTime.now().month;
    final monthsRemaining = 12 - currentMonth + 1;

    return Scaffold(
      // --- ADIÇÃO 3: Associar a chave ao Scaffold ---
      key: _scaffoldKey,

      backgroundColor: const Color(0xFF121212),

      // --- ADIÇÃO 4: Adicionar o Drawer (menu lateral) ---
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E1E1E), // Cor de fundo do menu
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
                // Fecha o drawer e volta para a tela anterior (Home)
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.note, color: Colors.white),
              title: const Text('Anotações', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer primeiro
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

      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Calendário',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        // --- MODIFICAÇÃO 1: Alterar o ícone e a ação do botão direito ---
        actions: [
          IconButton(
            // Use o mesmo ícone das outras telas para consistência
            icon: Image.asset('lib/assets/images/icon3barras.png', width: 28, height: 28),
            onPressed: () {
              // Ação para abrir o Drawer
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: monthsRemaining,
        itemBuilder: (context, index) {
          final month = currentMonth + index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildMonthCalendar(context, DateTime(DateTime.now().year, month, 1)),
          );
        },
      ),
    );
  }

  Widget _buildMonthCalendar(BuildContext context, DateTime date) {
    final monthName = DateFormat.MMMM('pt_BR').format(date).capitalize();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          monthName,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        TableCalendar(
          locale: 'pt_BR',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: date,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          availableGestures: AvailableGestures.none,
          calendarFormat: CalendarFormat.month,
          headerVisible: false,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: GoogleFonts.poppins(color: Colors.white),
            weekendStyle: GoogleFonts.poppins(color: Colors.white),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: GoogleFonts.poppins(
              color: Colors.black, //numeros pretos
            ),
            markerDecoration: const BoxDecoration(
              color: Colors.lightBlueAccent,
              shape: BoxShape.circle,
            ),
            defaultDecoration: BoxDecoration(
              color: Colors.white12,
              shape: BoxShape.circle,
            ),
            weekendDecoration: BoxDecoration(
              color: Colors.white12,
              shape: BoxShape.circle,
            ),
            defaultTextStyle: GoogleFonts.poppins(color: Colors.white),
            weekendTextStyle: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// Extensão para capitalizar nome do mês
extension StringCasingExtension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
