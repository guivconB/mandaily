import 'package:flutter/material.dart';

import '../auth/login.dart';
import '../auth/register.dart';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 385),

            Transform.translate( //mover imagem pra direita
              offset: const Offset(20, 0),
              child: Image.asset(
                'lib/assets/images/logo_branca.png',
                width: 240,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'ManDaily',
              style: TextStyle(
              fontFamily: 'Nexa',
                fontWeight: FontWeight.w900,
                fontSize: 78,
                letterSpacing: -5 ,
                color: Colors.white

            ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 117, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
              child: const Text(
                  'Registrar',
                style: TextStyle(
                  fontFamily: 'Coolvetica',
                  fontSize: 19,
                  color: Colors.black
                ),

              ),
            ),
            const SizedBox(height: 20),
            //espaçamento
            ElevatedButton( //Entrar
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
                //Ação botão
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                padding: const EdgeInsets.symmetric(horizontal: 131, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Entrar',
              style: TextStyle(
                fontFamily: 'Coolvetica',
                fontSize: 19,
                color: Color(0xFFC4C4C4)
              ),
              ),
            ),
            const SizedBox(height: 20), // espaçamento
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Ao criar uma conta, você concorda com os nossos ',
                style: TextStyle(
                  fontFamily: 'Nexa',
                  fontWeight: FontWeight.w200,
                  fontSize: 16,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: '        Termos de Serviço',
                    style: TextStyle(
                      fontFamily: 'Nexa',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: ' e ',
                    style: TextStyle(
                      fontFamily: 'Nexa',
                      fontWeight: FontWeight.w200,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'Políticas de Privacidade',
                    style: TextStyle(
                      fontFamily: 'Nexa',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    )
    );
  }
}