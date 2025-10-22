import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mandaily/home/tela_consulta.dart'; // Certifique-se que este import está correto

class AdicionarRemedio extends StatefulWidget {
  const AdicionarRemedio({super.key});

  @override
  State<AdicionarRemedio> createState() => _AdicionarRemedioState();
}

class _AdicionarRemedioState extends State<AdicionarRemedio> {
  // Variável do dropdown
  String? tipoSelecionado;

  // Controladores para os campos do formulário
  final TextEditingController _nomeMedicacaoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _profissionalController = TextEditingController();
  final TextEditingController _dosagemController = TextEditingController();

  // Função para padronizar o estilo dos TextFields
  InputDecoration _inputDecoration(String hint, {Color hintColor = Colors.white70}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: hintColor,
        fontFamily: 'Coolvetica',
        fontSize: 16,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      filled: true,
      fillColor: Colors.grey[700],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  // Função para mostrar o Date Picker
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
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        _dataController.text = formattedDate;
      });
    }
  }

  @override
  void dispose() {
    _nomeMedicacaoController.dispose();
    _dataController.dispose();
    _profissionalController.dispose();
    _dosagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),

      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/images/fundo_adicionar.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                // Botão de voltar
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

                // Bloco centralizado "Adicionar" e "Categoria"
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Adicionar',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Nexa',
                          fontWeight: FontWeight.w900,
                          fontSize: 35,
                          letterSpacing: -3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Novo Remédio',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Coolvetica',
                    fontSize: 40,
                  ),
                ),

                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Categoria',
                        style: TextStyle(
                          color: Color(0xFFC4C4C4),
                          fontFamily: 'Coolvetica',
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botão Consulta
                    ElevatedButton(
                      onPressed: () {
                        print('Botão 1 pressionado');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      ),
                      child: const Text(
                        'Consulta',
                        style: TextStyle(
                          fontFamily: 'Coolvetica',
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(width: 44),

                    // Botão Remédio
                    ElevatedButton(
                      onPressed: () {
                        print('Botão 2 pressionado');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF55CE98),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      ),
                      child: const Text(
                        'Remédio',
                        style: TextStyle(
                          fontFamily: 'Coolvetica',
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                const Text(
                  'Nome da medicação',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Coolvetica',
                    fontSize: 23,
                  ),
                ),
                TextField(
                  controller: _nomeMedicacaoController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('...'),
                ),

                const SizedBox(height: 15),

                // Dropdown de tipo
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: DropdownButtonFormField<String>(
                        value: tipoSelecionado,
                        decoration: _inputDecoration('Tipo        ▼', hintColor: Color(0xFF616161)), // hint branco
                        dropdownColor: const Color(0xFF2C2C2C),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Coolvetica',
                          fontSize: 18,
                        ),
                        items: ['Comprimido', 'Líquido', 'Pomada'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.white), // cor do item
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            tipoSelecionado = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  'Data de Início',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Coolvetica',
                    fontSize: 23,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _dataController,
                    readOnly: true,
                    onTap: _selectDate,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('00/00/0000'),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Profissional que prescreveu',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Coolvetica',
                    fontSize: 18,
                  ),
                ),
                TextField(
                  controller: _profissionalController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('...'),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Dosagem',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Coolvetica',
                    fontSize: 18,
                  ),
                ),
                TextField(
                  controller: _dosagemController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('...'),
                ),

                const SizedBox(height: 40),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      print('Nome: ${_nomeMedicacaoController.text}');
                      print('Data: ${_dataController.text}');
                      print('Profissional: ${_profissionalController.text}');
                      print('Dosagem: ${_dosagemController.text}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Medicação adicionada com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 100, vertical: 18),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Adicionar',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Coolvetica',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
