import 'package:flutter/material.dart';

class CalculatorMejorPromedioPage extends StatefulWidget {
  const CalculatorMejorPromedioPage({super.key});

  @override
  State<CalculatorMejorPromedioPage> createState() => _CalculatorMejorPromedioPageState();
}

class _CalculatorMejorPromedioPageState extends State<CalculatorMejorPromedioPage> {
  final TextEditingController puntosController = TextEditingController();
  final TextEditingController horasPGAController = TextEditingController();
  final TextEditingController creditosController = TextEditingController();
  final TextEditingController promedioDeseadoController = TextEditingController();
  String promedioNecesario = "";

  void calcularPromedio() {
    final int puntosActuales = int.tryParse(puntosController.text) ?? 0;
    final int horasPGA = int.tryParse(horasPGAController.text) ?? 0;
    final int creditosSemestre = int.tryParse(creditosController.text) ?? 0;
    final int promedioDeseado = int.tryParse(promedioDeseadoController.text) ?? 0;

    if (creditosSemestre == 0) {
      setState(() {
        promedioNecesario = "Los créditos del semestre no pueden ser cero.";
      });
      return;
    }

    final double resultado = ((promedioDeseado * (horasPGA + creditosSemestre)) - puntosActuales) / creditosSemestre;

    setState(() {
      promedioNecesario = "El promedio que necesitas el semestre actual es: ${resultado.toStringAsFixed(2)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0D34D),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 45, 40, 40),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Mejorar Promedio"), titleTextStyle: TextStyle(color: Colors.white, fontSize: 23),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: puntosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Puntos de calidad actuales"),
            ),
            TextField(
              controller: horasPGAController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Horas PGA"),
            ),
            TextField(
              controller: creditosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Créditos del semestre"),
            ),
            TextField(
              controller: promedioDeseadoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Promedio deseado"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calcularPromedio,
              child: Text("Calcular Promedio Necesario"),
            ),
            SizedBox(height: 20),
            Text(
              promedioNecesario,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
