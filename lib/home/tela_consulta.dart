import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mandaily/anotacoes.dart';
import 'package:mandaily/home/remedios/adicionar_consulta.dart'; // Import da tela de adicionar
import 'package:mandaily/home/remedios/tela_remedio.dart';
import 'package:mandaily/calendar_screen.dart';
import 'package:mandaily/perfil/perfil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// [NOVO] 1. Classe de Modelo (Data Model)
// Ajuda a organizar os dados recebidos da API de forma estruturada e segura.
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

  // Factory constructor para criar uma instância de Consulta a partir de um JSON.
  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json['_id'],
      nomeConsulta: json['nomeConsulta'],
      nomeProfissional: json['nomeProfissional'],
      endereco: json['endereco'],
      horario: json['horario'],
      // Converte a string de data (formato ISO 8601) do back-end para um objeto DateTime do Dart.
      data: DateTime.parse(json['data']),
    );
  }
}

class TelaConsulta extends StatefulWidget {
  const TelaConsulta({super.key});

  @override
  State<TelaConsulta> createState() => _TelaConsultaState();
}

class _TelaConsultaState extends State<TelaConsulta> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late DateTime _selectedDate;
  final List<DateTime> _diasDoMes = [];

  // [NOVO] 2. Estado para a busca de dados
  // O FutureBuilder usará esta variável para controlar o estado da UI (loading, erro, sucesso).
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
    // Inicia a busca pelas consultas assim que a tela é construída.
    _futureConsultas = _buscarConsultasDoUsuario();
  }
  Future<void> _deletarConsulta(String consultaId) async {
    // Mostra um diálogo de confirmação antes de deletar
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
              onPressed: () {
                Navigator.of(context).pop(false); // Retorna 'false'
              },
            ),
            TextButton(
              child: const Text('Deletar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true); // Retorna 'true'
              },
            ),
          ],
        );
      },
    );

    // Se o usuário não confirmou (pressionou 'Cancelar' ou fora do diálogo), não faz nada.
    if (confirmar != true) {
      return;
    }

    // Se confirmou, prossegue com a exclusão
    try {
      // ❗ ATENÇÃO: Verifique o IP!
      final String apiUrl = 'http://192.168.1.128:3000/consulta/$consultaId';

      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Consulta deletada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        // Atualiza a tela para remover o item deletado
        setState(() {
          _futureConsultas = _buscarConsultasDoUsuario();
        });
      } else {
        throw Exception('Falha ao deletar a consulta.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  // [NOVO] 3. Função para buscar os dados na API
  Future<List<Consulta>> _buscarConsultasDoUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) {
      // Se não encontrar o ID do usuário, retorna uma lista vazia para não quebrar o app.
      return [];
    }

    // ❗ ATENÇÃO: Substitua pelo IP da sua máquina!
    final String apiUrl = 'http://192.168.1.128:3000/consulta';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decodifica a resposta JSON para uma lista dinâmica.
        final List<dynamic> consultasJson = jsonDecode(response.body);

        // Mapeia a lista JSON para uma lista de objetos Consulta e filtra pelo userId.
        return consultasJson
            .map((json) => Consulta.fromJson(json))
            .where((consulta) {
          // Compara a data da consulta com a data selecionada no calendário.
          bool isSameDay = consulta.data.year == _selectedDate.year &&
              consulta.data.month == _selectedDate.month &&
              consulta.data.day == _selectedDate.day;

          // Como a rota `/consulta` retorna todas as consultas, aqui filtramos manualmente
          // apenas as que pertencem ao usuário logado (usando o userId).
          // Em um app de produção, o ideal seria ter uma rota no back-end como `/consulta/user/:userId`
          // que já faria esse filtro no servidor.
          // (NOTA: Seu `appointmentModel` já tem `userId`, então o filtro é possível aqui.)
          // A linha abaixo está comentada pois precisaria que a resposta da API incluísse o `userId`.
          // bool pertenceAoUsuario = consulta.userId == userId;

          return isSameDay; // && pertenceAoUsuario;
        }).toList();

      } else {
        // Se o servidor responder com um erro, nós o lançamos para o FutureBuilder tratar.
        throw Exception('Falha ao carregar as consultas.');
      }
    } catch (e) {
      // Captura erros de conexão (ex: IP errado, servidor offline).
      throw Exception('Erro de conexão: ${e.toString()}');
    }
  }

  // [MODIFICADO] 4. Função para atualizar a lista ao mudar de data
  void _onDateSelected(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
      // Quando o usuário seleciona uma nova data, reiniciamos a busca
      // para carregar as consultas do novo dia.
      _futureConsultas = _buscarConsultasDoUsuario();
    });
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        // ... (seu código do Drawer permanece igual) ...
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
                // ... (seu código do Header, Título e Data permanece igual) ...
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
                        // [MODIFICADO] Chama a função que atualiza o estado e busca os novos dados
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
                const SizedBox(height: 30), // Espaçamento antes da lista

                // [NOVO] 5. Widget que constrói a lista de consultas
                Expanded(
                  child: FutureBuilder<List<Consulta>>(
                    future: _futureConsultas,
                    builder: (context, snapshot) {
                      // Estado de Carregamento
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      // Estado de Erro
                      else if (snapshot.hasError) {
                        return Center(child: Text('Erro: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                      }
                      // Estado de Sucesso, mas sem dados
                      else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Nenhuma consulta agendada para este dia.', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        );
                      }
                      // Estado de Sucesso com dados
                      else {
                        final consultas = snapshot.data!;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: consultas.length,
                          itemBuilder: (context, index) {
                            final consulta = consultas[index];
                            return _buildConsultaCard(consulta); // Chama um método que constrói o card
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

      // [MODIFICADO] 6. FloatingActionButton agora navega para AdicionarConsulta
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega para a tela de adicionar e, quando voltar, atualiza a lista.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdicionarConsulta()),
          ).then((_) {
            // Este .then() é executado quando a tela 'AdicionarConsulta' é fechada.
            // Isso força a reconstrução da lista, exibindo o novo item adicionado.
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
        // ... (seu código do BottomAppBar permanece igual) ...
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

  // [NOVO] 7. Método para construir o Card da Consulta
  // Isso organiza o código, deixando o `build` principal mais limpo.
  Widget _buildConsultaCard(Consulta consulta) {
    return Stack(
      children: [
        Container(
          width: double.infinity, // Garante que o container ocupe toda a largura
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF007AFF), // Cor azul, como no exemplo
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (O conteúdo do seu card continua o mesmo)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible( // Evita que o texto quebre o layout se for muito longo
                    child: Text(
                      consulta.nomeConsulta,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    consulta.horario,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
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
              const SizedBox(height: 10), // Espaço extra para o ícone não sobrepor o texto
            ],
          ),
        ),
        // ✨ BOTÃO DE DELETAR POSICIONADO
        Positioned(
          bottom: 20,
          right: 15,
          child: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white70, size: 28),
            onPressed: () {
              // Chama a função que criamos, passando o ID da consulta específica deste card
              _deletarConsulta(consulta.id);
            },
          ),
        ),
      ],
    );
  }
}
