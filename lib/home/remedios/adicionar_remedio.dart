import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mandaily/home/remedios/adicionar_consulta.dart';
import 'package:mandaily/home/tela_consulta.dart';
import 'package:http/http.dart' as http; // Import para requisições HTTP
import 'dart:convert'; // Import para JSON
import 'package:shared_preferences/shared_preferences.dart'; // Import para pegar o ID do usuário

class AdicionarRemedio extends StatefulWidget {
  const AdicionarRemedio({super.key});

  @override
  State<AdicionarRemedio> createState() => _AdicionarRemedioState();
}

class _AdicionarRemedioState extends State<AdicionarRemedio> {
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário

  String? _tipoSelecionado;
  String? _frequenciaSelecionada = '6 horas'; // Valor padrão
  String? _diasSelecionado = 'Diariamente'; // Valor padrão
  int _numeroDias = 1;
  bool _notificacaoDiaria = true;

  final TextEditingController _nomeMedicacaoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _dosagemController = TextEditingController();

  // --- NOVA FUNÇÃO ---
  // Função para enviar os dados do remédio para o backend
  Future<void> _criarRemedio() async {
    // 1. Validação do formulário
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos obrigatórios.')),
      );
      return;
    }

    // Exibe um loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 2. Obter ID do usuário logado
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null) {
        throw Exception("Usuário não logado.");
      }

      // 3. Formatar a data para o padrão ISO 8601 que o backend espera
      final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
      final DateTime dateTime = inputFormat.parse(_dataController.text);
      final String dataFormatada = dateTime.toIso8601String();

      // ❗ ATENÇÃO: Substitua pelo IP da sua máquina!
      const String apiUrl = 'http://192.168.1.128:3000/medicamento';

      // 4. Enviar a requisição POST
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'userId': userId,
          'nome': _nomeMedicacaoController.text,
          'tipo': _tipoSelecionado,
          'dose': int.tryParse(_dosagemController.text) ?? 0,
          'horarioInicio': _horaController.text,
          'dataInicio': dataFormatada,
          'dias': _diasSelecionado,
          'frequencia': _frequenciaSelecionada,
          'numeroDias': _numeroDias,
          'notificacaoDiaria': _notificacaoDiaria,
        }),
      );

      Navigator.pop(context); // Fecha o loading

      // 5. Tratar a resposta
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Remédio adicionado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        // Volta para a tela anterior, que agora será atualizada
        Navigator.pop(context, true); // Retorna 'true' para indicar sucesso
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception('Erro ao criar remédio: ${responseBody['error']}');
      }
    } catch (e) {
      Navigator.pop(context); // Fecha o loading em caso de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white70,
        fontFamily: 'Coolvetica',
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      filled: true,
      fillColor: const Color(0xFF616161),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(color: Colors.yellowAccent),
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF2C2C2C),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _dataController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Colors.black,
                surface: Color(0xFF1E1E1E),
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: const Color(0xFF2C2C2C),
            ),
            child: child!,
          ),
        );
      },
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      _horaController.text = DateFormat('HH:mm').format(
        DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute),
      );
    }
  }

  @override
  void dispose() {
    _nomeMedicacaoController.dispose();
    _dataController.dispose();
    _horaController.dispose();
    _dosagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/fundo_adicionar.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form( // Adicionado Form
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const TelaConsulta()),
                              );
                            }
                          },
                        ),
                        const Center(
                          child: Text('Adicionar', style: TextStyle(color: Colors.white, fontFamily: 'Nexa', fontWeight: FontWeight.w900, fontSize: 35, letterSpacing: -3)),
                        ),
                        const SizedBox(height: 10),
                        const Text('Novo Remédio', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 40)),
                        const Center(
                          child: Text('Categoria', style: TextStyle(color: Color(0xFFC4C4C4), fontFamily: 'Coolvetica', fontSize: 18)),
                        ),
                        // Botões de Categoria
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => const AdicionarConsulta(),
                                    transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                                  ),
                                );
                              },
                              child: Image.asset('lib/assets/images/botaoconsultaapagado.png', width: 120, height: 120),
                            ),
                            const SizedBox(width: 44),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF55CE98),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                              ),
                              child: const Text('Remédio', style: TextStyle(fontFamily: 'Coolvetica', fontSize: 16)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Campos do Formulário
                        const Text('Nome da medicação', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                        TextFormField(
                          controller: _nomeMedicacaoController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('...'),
                          validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                        ),
                        const SizedBox(height: 20),

                        // Linha: Tipo e Dose
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Tipo', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: _tipoSelecionado,
                                    decoration: _inputDecoration(''),
                                    hint: const Text('Selecione', style: TextStyle(color: Colors.white70, fontFamily: 'Coolvetica')),
                                    dropdownColor: const Color(0xFF2C2C2C),
                                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                    items: ["Comprimido", "Líquido", "Pomada", "Gota", "Injeção"]
                                        .map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(color: Colors.white, fontFamily: 'Coolvetica'))))
                                        .toList(),
                                    onChanged: (v) => setState(() => _tipoSelecionado = v),
                                    validator: (v) => v == null ? 'Obrigatório' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Dose', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _dosagemController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: _inputDecoration('Ex: 1'),
                                    validator: (v) => (v?.isEmpty ?? true) ? 'Obrigatório' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Linha: Horário e Data de Início
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Horário de início', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                                  TextFormField(
                                    controller: _horaController,
                                    readOnly: true,
                                    onTap: _selectTime,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: _inputDecoration('HH:MM'),
                                    validator: (v) => (v?.isEmpty ?? true) ? 'Obrigatório' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Data de início', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                                  TextFormField(
                                    controller: _dataController,
                                    readOnly: true,
                                    onTap: _selectDate,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: _inputDecoration('DD/MM/AAAA'),
                                    validator: (v) => (v?.isEmpty ?? true) ? 'Obrigatório' : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Frequência
                        const Text('Frequência', style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                        DropdownButtonFormField<String>(
                          value: _frequenciaSelecionada,
                          decoration: _inputDecoration(''),
                          dropdownColor: const Color(0xFF2C2C2C),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          items: ['4 horas', '6 horas', '8 horas', '12 horas', '24 horas']
                              .map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(color: Colors.white, fontFamily: 'Coolvetica'))))
                              .toList(),
                          onChanged: (v) => setState(() => _frequenciaSelecionada = v),
                        ),
                        const SizedBox(height: 40),

                        // Botão de Adicionar
                        Center(
                          child: ElevatedButton(
                            onPressed: _criarRemedio,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 80),
                            ),
                            child: const Text('Adicionar', style: TextStyle(fontFamily: 'Coolvetica', fontSize: 22, color: Colors.black)),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
