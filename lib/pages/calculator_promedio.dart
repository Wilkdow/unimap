import 'package:flutter/material.dart';

class CalculatorPromedioPage extends StatefulWidget {
  const CalculatorPromedioPage({super.key});

  @override
  State<CalculatorPromedioPage> createState() => _CalculatorPromedioPageState();
}

class _CalculatorPromedioPageState extends State<CalculatorPromedioPage> {
  final TextEditingController cantidadCursosController = TextEditingController();

  List<TextEditingController> notaControllers = [];
  List<TextEditingController> creditoControllers = [];

  String promedio = "";
  String puntosDeCalidad = "";

  void generarCampos() {
    int cantidad = int.tryParse(cantidadCursosController.text) ?? 0;

    notaControllers = List.generate(cantidad, (_) => TextEditingController());
    creditoControllers = List.generate(cantidad, (_) => TextEditingController());

    setState(() {}); // actualizar interfaz
  }

  void calcularPromedio() {
    double sumaNotasPorCreditos = 0.0;
    int sumaCreditos = 0;
    int totalPuntosDeCalidad = 0;

    for (int i = 0; i < notaControllers.length; i++) {
      double nota = double.tryParse(notaControllers[i].text) ?? 0.0;
      int creditos = int.tryParse(creditoControllers[i].text) ?? 0;

      double puntos = nota * creditos;
      sumaNotasPorCreditos += puntos;
      sumaCreditos += creditos;
      totalPuntosDeCalidad += (puntos * 1000).toInt();
    }

    double promedioFinal = sumaCreditos > 0 ? sumaNotasPorCreditos / sumaCreditos : 0;

    setState(() {
      promedio = "Promedio: ${promedioFinal.toStringAsFixed(3)}";
      puntosDeCalidad = "Puntos de calidad totales: $totalPuntosDeCalidad";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0D34D),
      appBar: AppBar(title: Text('Calculadora de Definitiva'),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 23),
      backgroundColor: Color.fromARGB(255, 45, 40, 40),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cantidadCursosController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Cantidad de cursos'),
              onChanged: (_) => generarCampos(),
            ),
            SizedBox(height: 16),
            for (int i = 0; i < notaControllers.length; i++)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: notaControllers[i],
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Nota del curso ${i + 1}'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: creditoControllers[i],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Créditos ${i + 1}'),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: calcularPromedio, child: Text('Calcular')),
            SizedBox(height: 20),
            Text(promedio, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(puntosDeCalidad, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
