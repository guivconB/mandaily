import 'package:flutter/material.dart';
//Importa a biblioteca de widgets do Material Design

class PerfilComponentes extends StatelessWidget {
//Cria o componente visual que recebe dados e exibe o card de perfil

  final String nome;
  final String nascimento;
  final bool notificacoes;
  final bool temaEscuro;
  final ValueChanged<bool> onNotificacoesChanged;
  final ValueChanged<bool> onTemaChanged;
  final bool isSelected;
  //Variáveis que o componente recebe

  const PerfilComponentes({
    required this.nome,
    required this.nascimento,
    required this.notificacoes,
    required this.temaEscuro,
    required this.onNotificacoesChanged,
    required this.onTemaChanged,
    required this.isSelected,
  });
  //Construtor que obriga todos os campos a serem preenchido, evitando erros e garantindo que o componente sempre receba os dados necessários.

  @override
  Widget build(BuildContext context) {
  //Monta a interface visual do componente

    return Container(
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[900],
      ),
    //Cria o container principal

      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      //Espaçamento interno e externo

      child: Column(
        children: [
      //Usa uma Column para empilahr todos os elementos na vertical

          CircleAvatar(radius: 30, backgroundColor: Colors.grey[700]),
          SizedBox(height: 10),
          Text(nome, style: TextStyle(color: Colors.white, fontSize: 18)),
          Text(nascimento, style: TextStyle(color: Colors.white70)),
          //Ícone de perfil

          SwitchListTile(
            title: Text('Notificações', style: TextStyle(color: Colors.white)),
            value: notificacoes,
            onChanged: onNotificacoesChanged,
          ),
          //Cria um botão que alterna o título "Notificações"

          SwitchListTile(
            title: Text('Tema escuro', style: TextStyle(color: Colors.white)),
            value: temaEscuro,
            onChanged: onTemaChanged,
          ),
          //Alterna para o tema escuro
        ],
      ),
    );
  }
}
