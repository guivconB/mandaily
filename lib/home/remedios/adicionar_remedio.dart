import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mandaily/home/tela_consulta.dart';

class AdicionarRemedio extends StatefulWidget {
  const AdicionarRemedio({super.key});

  @override
  State<AdicionarRemedio> createState() => _AdicionarRemedioState();
}

class _AdicionarRemedioState extends State<AdicionarRemedio> {
  String? _tipoSelecionado;
  String? _frequenciaSelecionada;
  String? _diasSelecionado;
  int _numeroDias = 1;

  final TextEditingController _nomeMedicacaoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _dosagemController = TextEditingController();

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
      fillColor: Colors.grey[700],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
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
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        _dataController.text = formattedDate;
      });
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
      final formattedTime = DateFormat('HH:mm').format(
        DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute),
      );
      setState(() {
        _horaController.text = formattedTime;
      });
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
      body: Container(
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
                child: Text(
                  'Adicionar',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nexa',
                    fontWeight: FontWeight.w900,
                    fontSize: 35,
                    letterSpacing: -3,
                  ),
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
                child: Text(
                  'Categoria',
                  style: TextStyle(
                    color: Color(0xFFC4C4C4),
                    fontFamily: 'Coolvetica',
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AFF),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                    child: const Text('Consulta',
                        style: TextStyle(fontFamily: 'Coolvetica', fontSize: 16)),
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
                    child: const Text('Remédio',
                        style: TextStyle(fontFamily: 'Coolvetica', fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Text('Nome da medicação',
                  style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
              TextField(
                controller: _nomeMedicacaoController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('...'),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tipo',
                          style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 180,
                        child: DropdownButtonFormField<String>(
                          value: _tipoSelecionado,
                          decoration: _inputDecoration(''),
                          hint: const Text('Selecione o tipo',
                              style: TextStyle(color: Colors.white70, fontFamily: 'Coolvetica')),
                          dropdownColor: const Color(0xFF2C2C2C),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          items: ['Comprimido', 'Líquido', 'Pomada']
                              .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    color: Colors.white, fontFamily: 'Coolvetica')),
                          ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _tipoSelecionado = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dose',
                          style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _dosagemController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('...'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Horário de início',
                          style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _horaController,
                          readOnly: true,
                          onTap: _selectTime,
                          style: const TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 16),
                          decoration: _inputDecoration('00:00'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Data de início',
                          style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 180,
                        child: TextField(
                          controller: _dataController,
                          readOnly: true,
                          onTap: _selectDate,
                          style: const TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 16),
                          decoration: _inputDecoration('00/00/0000'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dias',
                          style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 180,
                        child: DropdownButtonFormField<String>(
                          value: _diasSelecionado,
                          decoration: _inputDecoration(''),
                          hint: const Text('Selecione',
                              style: TextStyle(color: Colors.white70, fontFamily: 'Coolvetica')),
                          dropdownColor: const Color(0xFF2C2C2C),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          items: ['Diário', 'Semanal', 'Mensal']
                              .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    color: Colors.white, fontFamily: 'Coolvetica')),
                          ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _diasSelecionado = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Frequência',
                          style: TextStyle(color: Colors.white, fontFamily: 'Coolvetica', fontSize: 23)),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 180,
                        child: DropdownButtonFormField<String>(
                          value: _frequenciaSelecionada,
                          decoration: _inputDecoration(''),
                          hint: const Text('Selecione',
                              style: TextStyle(color: Colors.white70, fontFamily: 'Coolvetica')),
                          dropdownColor: const Color(0xFF2C2C2C),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          items: ['6 Horas', '8 Horas', '12 Horas', '24 Horas']
                              .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: const TextStyle(
                                    color: Colors.white, fontFamily: 'Coolvetica')),
                          ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _frequenciaSelecionada = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Número de dias',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Coolvetica',
                          fontSize: 23,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  if (_numeroDias > 1) _numeroDias--;
                                });
                              },
                            ),
                            Text(
                              '$_numeroDias',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Coolvetica',
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _numeroDias++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Medicação adicionada com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF55CE98),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text(
                        'Adicionar Remédio',
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
            ],
          ),
        ),
      ),

    );
  }
}
