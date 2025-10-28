import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


// Modelo de Dados simples para a Nota (melhor que apenas String)
class Nota {
  String conteudo;
  // Alterado para String para simplificar a conversão JSON (ISO 8601)
  String dataCriacao;

  // CONSTRUTOR: Cria uma nova nota com a data atual formatada
  Nota(this.conteudo) : dataCriacao = DateTime.now().toIso8601String();

  // CONSTRUTOR NOMEADO: Cria uma nota a partir de um mapa JSON (para carregar)
  Nota.fromJson(Map<String, dynamic> json)
      : conteudo = json['conteudo'] as String,
        dataCriacao = json['dataCriacao'] as String;

  // MÉTODO: Converte a nota em um mapa JSON (para salvar)
  Map<String, dynamic> toJson() => {
    'conteudo': conteudo,
    'dataCriacao': dataCriacao,
  };
}


// 1. TELA PRINCIPAL: AnotacoesPage

class AnotacoesPage extends StatefulWidget {
  const AnotacoesPage({super.key});

  @override
  State<AnotacoesPage> createState() => _AnotacoesPageState();
}

class _AnotacoesPageState extends State<AnotacoesPage> {
  // Lista que armazena todas as notas
  final List<Nota> _notas = [];

  // ADICIONADO: Carrega as notas salvas quando a tela é iniciada
  @override
  void initState() {
    super.initState();
    _carregarNotas();
  }

  // ADICIONADO: Função assíncrona para carregar as notas salvas
  Future<void> _carregarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    // Tenta obter a lista de Strings (que são os JSONs das notas)
    final List<String>? notasJsonList = prefs.getStringList('anotacoes_salvas');

    if (notasJsonList != null) {
      setState(() {
        // Converte cada string JSON de volta para o objeto Nota
        _notas.clear(); // Limpa a lista antes de carregar
        for (var jsonString in notasJsonList) {
          try {
            final Map<String, dynamic> notaMap = jsonDecode(jsonString);
            _notas.add(Nota.fromJson(notaMap));
          } catch (e) {
            // Caso alguma string salva esteja corrompida, ignora
            print('Erro ao decodificar nota: $e');
          }
        }
      });
    }
  }

  // ADICIONADO: Função assíncrona para salvar a lista de notas
  Future<void> _salvarNotas() async {
    final prefs = await SharedPreferences.getInstance();

    // Converte a lista de objetos Nota em uma lista de strings JSON
    final List<String> notasJsonList = _notas
        .map((nota) => jsonEncode(nota.toJson()))
        .toList();

    // Salva a lista de strings
    await prefs.setStringList('anotacoes_salvas', notasJsonList);
  }

  // Função para abrir a tela de adicionar nota
  void _adicionarNota() async {
    // Espera o resultado (a nota) que virá da AdicionarNotaPage
    final novaNotaConteudo = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const AdicionarNotaPage()),
    );

    // Se o conteúdo não for nulo, adiciona a nota
    if (novaNotaConteudo != null && novaNotaConteudo.isNotEmpty) {
      setState(() {
        _notas.add(Nota(novaNotaConteudo));
      });
      // ADICIONADO: Salva a lista após adicionar
      _salvarNotas();
    }
  }

  // Função para remover uma anotação
  void _removerNota(int index) {
    setState(() {
      _notas.removeAt(index);
    });
    // ADICIONADO: Salva a lista após remover
    _salvarNotas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Fundo escuro consistente
      appBar: AppBar(
        title: Text(
          'Anotações',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E), // Cor da barra superior consistente
        iconTheme: const IconThemeData(color: Colors.white), // Ícone de voltar branco
      ),

      // Lista de anotações salvas
      body: _notas.isEmpty
          ? Center(
        child: Text(
          'Nenhuma anotação ainda.\nUse o botão "+" para adicionar.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _notas.length,
        itemBuilder: (context, index) {
          final nota = _notas[index];
          // CONVERTENDO A STRING ISO DE VOLTA PARA DATETIME para formatação
          final dataOriginal = DateTime.parse(nota.dataCriacao);

          return Card(
            color: const Color(0xFF1E1E1E), // Cor de fundo de cada nota
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(
                nota.conteudo,
                maxLines: 2, // Limita a visualização
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                // Usando a data convertida para exibir
                'Criado em: ${dataOriginal.day.toString().padLeft(2, '0')}/${dataOriginal.month.toString().padLeft(2, '0')} ${dataOriginal.hour.toString().padLeft(2, '0')}:${dataOriginal.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _removerNota(index),
              ),
              onTap: () {
                // Opcional: Implementar a edição da nota aqui
              },
            ),
          );
        },
      ),

      // Botão Flutuante (para adicionar)
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarNota,
        backgroundColor: const Color(0xFF007AFF), // Cor do botão de ação (pode ser ajustada para o padrão do seu app)
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


// 2. TELA SECUNDÁRIA: AdicionarNotaPage
// Não precisa de mudanças, pois apenas retorna a string

class AdicionarNotaPage extends StatefulWidget {
  const AdicionarNotaPage({super.key});

  @override
  State<AdicionarNotaPage> createState() => _AdicionarNotaPageState();
}

class _AdicionarNotaPageState extends State<AdicionarNotaPage> {
  final TextEditingController _controller = TextEditingController();

  // Função para salvar a nota e retornar para a tela anterior
  void _salvarERetornar() {
    // Retorna o texto digitado para a tela anterior (AnotacoesPage)
    Navigator.pop(context, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Nova Anotação',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _salvarERetornar,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          autofocus: true, // Abre o teclado automaticamente
          maxLines: null, // Permite múltiplas linhas
          keyboardType: TextInputType.multiline,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          decoration: const InputDecoration(
            hintText: 'Digite sua anotação aqui...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none, // Remove a borda padrão para um visual mais limpo
          ),
        ),
      ),
    );
  }
}