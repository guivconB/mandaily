import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 📅 Mapa de eventos armazenados
  Map<DateTime, List<String>> _events = {};

  // Função para normalizar data (sem horas)
  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  void initState() {
    super.initState();

    // Exemplo de eventos (dados iniciais)
    _events = {
      _normalizeDate(DateTime(2025, 10, 23)): ['Exame de sangue'],
      _normalizeDate(DateTime(2025, 10, 25)): ['Tomar remédio 08:00'],
      _normalizeDate(DateTime(2025, 11, 3)): ['Consulta médica'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateTime.now().month;
    final monthsRemaining = 12 - currentMonth + 1;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.menu, color: Colors.white),
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
          eventLoader: (day) => _events[_normalizeDate(day)] ?? [],
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            final events = _events[_normalizeDate(selectedDay)] ?? [];
            if (events.isNotEmpty) {
              _showEventDialog(context, selectedDay, events);
            } else {
              // ⭐⭐⭐ FUNÇÃO DE ADICIONAR NOVO EVENTO ⭐⭐⭐
              _showAddEventDialog(context, selectedDay);
            }
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

  // 📅 Modal que mostra eventos existentes
  void _showEventDialog(BuildContext context, DateTime day, List<String> events) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          'Eventos de ${DateFormat('d/MM/yyyy').format(day)}',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: events
              .map((e) => ListTile(
            title: Text(e, style: GoogleFonts.poppins(color: Colors.white)),
            leading: const Icon(Icons.event, color: Colors.white70),
          ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // ⭐⭐ CHAMA O MESMO MÉTODO DE ADIÇÃO DE EVENTO ⭐⭐
              _showAddEventDialog(context, day);
            },
            child: const Text('Adicionar', style: TextStyle(color: Colors.blueAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  // ⭐⭐⭐ FUNÇÃO PRINCIPAL DE ADICIONAR EVENTOS ⭐⭐⭐
  void _showAddEventDialog(BuildContext context, DateTime day) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          'Adicionar evento em ${DateFormat('d/MM/yyyy').format(day)}',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Digite o evento...',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 👉 Lógica que realmente salva o evento
              if (controller.text.isNotEmpty) {
                setState(() {
                  final normalized = _normalizeDate(day);
                  _events.putIfAbsent(normalized, () => []);
                  _events[normalized]!.add(controller.text);
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Salvar', style: TextStyle(color: Colors.blueAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}

// Extensão para capitalizar nome do mês
extension StringCasingExtension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
