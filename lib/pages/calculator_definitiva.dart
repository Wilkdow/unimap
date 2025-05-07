import 'package:flutter/material.dart';

class CalculatorDefinitivaPage extends StatefulWidget {
  const CalculatorDefinitivaPage({super.key});

  @override
  State<CalculatorDefinitivaPage> createState() => _CalculatorDefinitivaState();
}

class _CalculatorDefinitivaState extends State<CalculatorDefinitivaPage> {
  final TextEditingController cantidadController = TextEditingController();
  List<TextEditingController> notaControllers = [];
  List<TextEditingController> porcentajeControllers = [];

  String resultado = '';

  void generarInputs() {
    // Liberar los controladores anteriores
    for (var controller in notaControllers) {
      controller.dispose();
    }
    for (var controller in porcentajeControllers) {
      controller.dispose();
    }

    notaControllers.clear();
    porcentajeControllers.clear();

    int cantidad = int.tryParse(cantidadController.text) ?? 0;

    notaControllers =
        List.generate(cantidad, (_) => TextEditingController());
    porcentajeControllers =
        List.generate(cantidad, (_) => TextEditingController());

    setState(() {});
  }

  void calcularResultado() {
    double totalNotas = 0.0;
    double totalPorcentaje = 0.0;

    for (int i = 0; i < notaControllers.length; i++) {
      double nota = double.tryParse(notaControllers[i].text) ?? 0.0;
      double porcentaje = double.tryParse(porcentajeControllers[i].text) ?? 0.0;

      totalNotas += nota * (porcentaje * 0.01);
      totalPorcentaje += porcentaje;
    }

    setState(() {
      resultado =
          'La nota final de la materia es ${totalNotas.toStringAsFixed(2)} y el porcentaje total: $totalPorcentaje%';
    });
  }

  @override
  void dispose() {
    cantidadController.dispose();
    for (var controller in notaControllers) {
      controller.dispose();
    }
    for (var controller in porcentajeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0D34D),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 45, 40, 40),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Calculadora de Nota Final",
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Calculadora de Nota Final",
          labelStyle: TextStyle(color: Colors.white, )),
              onChanged: (_) => generarInputs(),
            ),
            SizedBox(height: 16),
            for (int i = 0; i < notaControllers.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: notaControllers[i],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Nota ${i + 1}'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: porcentajeControllers[i],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: '% ${i + 1}'),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calcularResultado,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            Text(
              resultado,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
