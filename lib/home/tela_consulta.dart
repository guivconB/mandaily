import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mandaily/anotacoes.dart';
import 'package:mandaily/home/remedios/adicionar_remedio.dart';
import 'package:mandaily/home/remedios/tela_remedio.dart';
import 'package:mandaily/calendar_screen.dart';
import 'package:mandaily/perfil/perfil.dart';
import 'package:mandaily/anotacoes.dart';
class TelaConsulta extends StatefulWidget {
  const TelaConsulta({super.key});

  @override
  State<TelaConsulta> createState() => _TelaConsultaState();
}

class _TelaConsultaState extends State<TelaConsulta> {
  // 1. Crie uma GlobalKey para o Scaffold
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
      // 2. Associe a key ao Scaffold
      key: _scaffoldKey,

      // 3. Adicione o Drawer (o menu lateral)
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E1E1E), // Cor de fundo do menu
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Cabeçalho do Drawer (opcional, mas recomendado)
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
            // Item 1 do Menu
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text('Início', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navegar para a tela inicial ou fechar o drawer
                Navigator.pop(context);
              },
            ),
            // Item 2 do Menu
            ListTile(
              leading: const Icon(Icons.note, color: Colors.white),
              title: const Text('Anotações', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Ação para o item
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AnotacoesPage()), // Certifique-se que o nome da classe está correto
                );
              },
            ),
            // Item 3 do Menu
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text('Perfil', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Ação para o item
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (
                      context) => Perfil()), // Certifique-se que o nome da classe está correto
                );
              }),
            // Adicione mais seções (ListTile) aqui
          ],
        ),
      ),

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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CalendarScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: Image.asset('lib/assets/images/icon3barras.png', width: 28, height: 28),
                      // 4. Modifique o onPressed para abrir o Drawer
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
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

      // --- O RESTANTE DO SEU CÓDIGO (floatingActionButton, bottomNavigationBar) PERMANECE O MESMO ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF2C2C2E),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // --- ÍCONE DA ESQUERDA (ATIVO) ---
              IconButton(
                // Ícone de saúde preenchido, pois estamos na tela de consulta.
                icon: Image.asset('lib/assets/images/iconesaude.png', width: 30, height: 30),
                onPressed: () {
                  // Ação desnecessária, já estamos nesta tela.
                  print('Já está na Tela de Consulta.');
                },
              ),

              // --- ÍCONE DA DIREITA (INATIVO) ---
              IconButton(
                // Ícone de pílula vazio, para navegar para a tela de remédios.
                // ATENÇÃO: Substitua 'pilulavazia.png' pelo nome correto do seu arquivo de imagem.
                icon: Image.asset('lib/assets/images/iconpilula.png', width: 30, height: 30),
                onPressed: () {
                  // A navegação com PageRouteBuilder que já fizemos.
                  Navigator.pushReplacement( // Usando pushReplacement para não empilhar telas
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const TelaRemedio(),
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

            ],
          ),
        ),
      ),
    );
  }
}
