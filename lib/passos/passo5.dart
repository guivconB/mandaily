import 'package:flutter/material.dart';

class Passo5 extends StatelessWidget {
  const Passo5({super.key});

  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('lib/assets/images/background-login.png'),
                fit: BoxFit.cover,
        ),
      ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 220),
            Image.asset('lib/assets/images/logo_branca.png'),
            const SizedBox(height: 15),
            const Text(
              'ManDaily',
              style: TextStyle(
              fontFamily: 'Nexa',
                fontWeight: FontWeight.w400,
                fontSize: 78,
                letterSpacing: -5 ,
                color: Colors.white

            ),
            ),

            ElevatedButton(
                onPressed: () {
              //Ação botão
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
              child: const Text(
                  'Registrar',
                style: TextStyle(
                  fontFamily: 'Coolvetica',
                  fontSize: 23,
                  color: Colors.black
                ),

              ),
            ),
            const SizedBox(height: 15),//espaçamento
            ElevatedButton( //Entrar
              onPressed: () {
                //Ação botão
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                padding: const EdgeInsets.symmetric(horizontal: 144, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Entrar',
              style: TextStyle(
                fontFamily: 'Coolvetica',
                fontSize: 23,
                color: Colors.white
              ),
              ),
            ),
            const Text(
                'Ao criar uma conta, você concorda com os nossos Termos de Serviço e Políticas de privacidade',
              style: TextStyle(
                fontFamily: 'Nexa',
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.white,
              ),
            ),

          ],
        ),
      ),
    )
    );
  }
}