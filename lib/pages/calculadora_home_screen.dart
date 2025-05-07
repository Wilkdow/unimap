import 'package:flutter/material.dart';
import 'package:unimap/pages/calculator_promedio.dart';
import 'package:unimap/pages/calculator_pga.dart';
import 'package:unimap/pages/calculator_definitiva.dart';
import 'package:unimap/pages/calculator_promedio_pasar.dart';
import 'package:unimap/pages/calculator_mejor_promedio.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CalculadoraHomeScreen(),
  ));
}

class CalculadoraHomeScreen extends StatelessWidget {
  const CalculadoraHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 45, 40, 40),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 80), //caja arriba pa no pegada al techo
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "Calculadoras de Notas",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 1), //box which contains buttons
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      BotonCalculadora(
                        texto: 'Calculador de PGA',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CalculatorPGAPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BotonCalculadora(
                        texto: 'Calculador de Definitiva',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CalculatorDefinitivaPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BotonCalculadora(
                        texto: 'Calculador de Promedio',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CalculatorPromedioPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BotonCalculadora(
                        texto: 'Calculador Promedio Pasar',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CalculatorPromedioPasarPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      BotonCalculadora(
                        texto: 'Calculador Promedio Mejorado',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CalculatorMejorPromedioPage(),
                            ),
                          );
                        },
                      ),
                    ],
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

class BotonCalculadora extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;

  const BotonCalculadora({super.key, required this.texto, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
