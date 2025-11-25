import 'package:flutter/material.dart';
import 'package:mandaily/anotacoes.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 1. Classe auxiliar para representar um Evento no calendário (seja consulta ou remédio)
class EventoCalendario {
  final String id;
  final String titulo;
  final String tipo; // "Consulta" ou "Remédio"
  final String horario;
  final Color cor;

  EventoCalendario({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.horario,
    required this.cor,
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 2. Listas para armazenar os dados crus vindos da API
  List<dynamic> _listaRemedios = [];
  List<dynamic> _listaConsultas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _normalizeDate(DateTime.now());
    _carregarDadosDoUsuario(); // Busca dados ao iniciar
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  // 3. Função para buscar Consultas e Remédios
  Future<void> _carregarDadosDoUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) return;

    // URLs (Verifique seu IP)
    final String urlConsultas = 'http://192.168.1.128:3000/consultas/user/$userId';
    final String urlRemedios = 'http://192.168.1.128:3000/medicamentos/user/$userId';

    try {
      final responses = await Future.wait([
        http.get(Uri.parse(urlConsultas)),
        http.get(Uri.parse(urlRemedios)),
      ]);

      if (mounted) {
        setState(() {
          if (responses[0].statusCode == 200) {
            _listaConsultas = jsonDecode(responses[0].body);
          }
          if (responses[1].statusCode == 200) {
            _listaRemedios = jsonDecode(responses[1].body);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Erro ao carregar calendário: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // 4. Lógica Inteligente: Verifica quais eventos existem num dia específico
  List<EventoCalendario> _getEventosDoDia(DateTime dia) {
    List<EventoCalendario> eventos = [];
    final diaNormalizado = _normalizeDate(dia);

    // A. Processar Consultas
    for (var consulta in _listaConsultas) {
      DateTime dataConsulta = DateTime.parse(consulta['data']);
      if (isSameDay(dataConsulta, diaNormalizado)) {
        eventos.add(EventoCalendario(
          id: consulta['_id'],
          titulo: consulta['nomeConsulta'],
          tipo: "Consulta",
          horario: consulta['horario'],
          cor: Colors.blueAccent,
        ));
      }
    }

    // B. Processar Remédios (Mesma lógica da TelaRemedio)
    for (var remedio in _listaRemedios) {
      DateTime dataInicio = DateTime.parse(remedio['dataInicio']);
      // Ajustar para ignorar horas na comparação
      DateTime inicioTratamento = DateTime(dataInicio.year, dataInicio.month, dataInicio.day);

      int numeroDias = remedio['numeroDias'] ?? 1;
      DateTime fimTratamento = inicioTratamento.add(Duration(days: numeroDias - 1));
      String frequencia = remedio['dias'] ?? 'Diariamente';

      // Verifica se o dia está dentro do período do tratamento
      // Usamos subtract/add 1 dia para garantir inclusão das bordas
      bool estaNoPeriodo = diaNormalizado.isAfter(inicioTratamento.subtract(const Duration(days: 1))) &&
          diaNormalizado.isBefore(fimTratamento.add(const Duration(days: 1)));

      if (estaNoPeriodo) {
        bool deveMostrar = false;

        if (frequencia == 'Diariamente') {
          deveMostrar = true;
        } else if (frequencia == 'Dias alternados') {
          final diferenca = diaNormalizado.difference(inicioTratamento).inDays;
          if (diferenca % 2 == 0) deveMostrar = true;
        } else if (frequencia == 'Semanalmente') {
          final diferenca = diaNormalizado.difference(inicioTratamento).inDays;
          if (diferenca % 7 == 0) deveMostrar = true;
        } else if (frequencia == 'Uma vez') {
          if (isSameDay(diaNormalizado, inicioTratamento)) deveMostrar = true;
        }

        if (deveMostrar) {
          eventos.add(EventoCalendario(
            id: remedio['_id'],
            titulo: remedio['nome'],
            tipo: "Remédio",
            horario: remedio['horarioInicio'],
            cor: const Color(0xFF55CE98), // Verde do app
          ));
        }
      }
    }

    return eventos;
  }

  // 5. Modal para mostrar os detalhes quando clica no dia
  void _mostrarDetalhesDoDia(BuildContext context, DateTime dia) {
    final eventos = _getEventosDoDia(dia);
    final dataFormatada = DateFormat("dd 'de' MMMM", 'pt_BR').format(dia);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2C2C2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tarefas de $dataFormatada",
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              if (eventos.isEmpty)
                const Text("Nenhuma tarefa para este dia.", style: TextStyle(color: Colors.white70)),

              Expanded(
                child: ListView.builder(
                  itemCount: eventos.length,
                  itemBuilder: (context, index) {
                    final evento = eventos[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                        border: Border(left: BorderSide(color: evento.cor, width: 4)),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(evento.titulo, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              Text("${evento.tipo} • ${evento.horario}", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateTime.now().month;
    final monthsRemaining = 12 - currentMonth + 1;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF121212),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E1E1E),
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
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.note, color: Colors.white),
              title: const Text('Anotações', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AnotacoesPage()));
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
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset('lib/assets/images/icon3barras.png', width: 28, height: 28),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        const SizedBox(height: 10),
        TableCalendar(
          locale: 'pt_BR',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: date,

          // --- 6. Conectar o carregador de eventos ---
          eventLoader: _getEventosDoDia,

          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

          // --- 7. Ação ao clicar no dia ---
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            // Abre o modal com as tarefas
            _mostrarDetalhesDoDia(context, selectedDay);
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
            todayDecoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
            selectedDecoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            selectedTextStyle: GoogleFonts.poppins(color: Colors.black),

            // --- Estilo dos Marcadores (Bolinhas) ---
            markerDecoration: const BoxDecoration(color: Color(0xFF55CE98), shape: BoxShape.circle),

            defaultDecoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle),
            weekendDecoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle),
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
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
