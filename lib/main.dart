import 'package:flutter/material.dart';
import 'splascreen.dart';
import 'home/tela_consulta.dart';
// Remova as importações de Passo1 e Passo2 se a navegação
// for totalmente gerenciada dentro das telas (como está agora)
// import 'passos/passo1.dart';
// import 'passos/passo2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ManDaily',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(), // Define SplashScreen como a tela inicial
      // Remova initialRoute e routes se estiver usando a navegação como no SplashScreen
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const Passo1(), // SplashScreen já navega para cá
      //   '/passo2': (context) => const Passo2(),
      // },
    );
  }
}

// ... (Restante do código de MyHomePage, se ainda for necessário para outras partes)
// Se MyHomePage não for mais usado, pode ser removido.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
