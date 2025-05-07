import 'package:flutter/material.dart';

class CalculatorPromedioPasarPage extends StatefulWidget {
  const CalculatorPromedioPasarPage({super.key});

  @override
  State<CalculatorPromedioPasarPage> createState() => _CalculatorPromedioPasarPageState();
}

class _CalculatorPromedioPasarPageState extends State<CalculatorPromedioPasarPage> {
  final TextEditingController _puntosActualesController = TextEditingController();
  final TextEditingController _horasPGAController = TextEditingController();
  final TextEditingController _creditosSemestreController = TextEditingController();
  final TextEditingController _promedioDeseadoController = TextEditingController();
  final TextEditingController _promedioNecesarioController = TextEditingController();

  void _calcularPromedio() {
    final int puntosActuales = int.tryParse(_puntosActualesController.text) ?? 0;
    final int horasPGA = int.tryParse(_horasPGAController.text) ?? 0;
    final int creditosSemestre = int.tryParse(_creditosSemestreController.text) ?? 1; // evitar división por cero
    final int promedioDeseado = int.tryParse(_promedioDeseadoController.text) ?? 0;

    double promedioNecesario1 = ((promedioDeseado * (horasPGA + creditosSemestre)) - puntosActuales) / creditosSemestre;
    double promedioNecesario = double.parse(promedioNecesario1.toStringAsFixed(3));

    _promedioNecesarioController.text = promedioNecesario.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0D34D),
      appBar: AppBar(title: Text("Pasar con Promedio"), 
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 23),
      backgroundColor: Color.fromARGB(255, 45, 40, 40),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _puntosActualesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Puntos de calidad actuales'),
            ),
            TextField(
              controller: _horasPGAController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Horas PGA'),
            ),
            TextField(
              controller: _creditosSemestreController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Créditos del semestre'),
            ),
            TextField(
              controller: _promedioDeseadoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Promedio deseado'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularPromedio,
              child: Text('Calcular Promedio Necesario'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _promedioNecesarioController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Promedio Necesario'),
            ),
          ],
        ),
      ),
    );
  }
}
