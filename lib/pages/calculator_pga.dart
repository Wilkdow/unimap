import 'package:flutter/material.dart';

class CalculatorPGAPage extends StatefulWidget {
  const CalculatorPGAPage({super.key});

  @override
  State<CalculatorPGAPage> createState() => _CalculatorPGAPageState();
}

class _CalculatorPGAPageState extends State<CalculatorPGAPage> {
  final _hController = TextEditingController(); // Créditos acumulados
  final _oController = TextEditingController(); // Puntos de calidad acumulados
  final _yController = TextEditingController(); // Número de cursos este semestre

  List<TextEditingController> _eControllers = [];
  List<TextEditingController> _rControllers = [];

  String promedio = '';
  String pga = '';

  void _generateCourseInputs(int count) {
    _eControllers = List.generate(count, (_) => TextEditingController());
    _rControllers = List.generate(count, (_) => TextEditingController());
  }

  void _calculatePGA() {
    int H = int.tryParse(_hController.text) ?? 0;
    double O = double.tryParse(_oController.text) ?? 0;
    int Y = int.tryParse(_yController.text) ?? 0;

    double sumaPuntos = 0;
    int sumaCreditos = 0;

    for (int i = 0; i < Y; i++) {
      double nota = double.tryParse(_eControllers[i].text) ?? 0;
      int creditos = int.tryParse(_rControllers[i].text) ?? 0;

      sumaPuntos += nota * creditos;
      sumaCreditos += creditos;
    }

    double promedioSemestre = sumaCreditos > 0 ? sumaPuntos / sumaCreditos : 0.0;
    double totalPuntos = sumaPuntos + O;
    int totalCreditos = sumaCreditos + H;
    double promedioPGA = totalCreditos > 0 ? totalPuntos / totalCreditos : 0.0;

    setState(() {
      promedio = promedioSemestre.toStringAsFixed(3);
      pga = promedioPGA.toStringAsFixed(3);
    });
  }

  @override
  void dispose() {
    _hController.dispose();
    _oController.dispose();
    _yController.dispose();
    for (var c in _eControllers) c.dispose();
    for (var c in _rControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0D34D),
      appBar: AppBar(title: Text('Calculadora de PGA'),
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 23),
      backgroundColor: Color.fromARGB(255, 45, 40, 40),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _hController,
              decoration: InputDecoration(labelText: 'Créditos acumulados'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _oController,
              decoration: InputDecoration(labelText: 'Puntos de calidad acumulados'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _yController,
              decoration: InputDecoration(labelText: 'Número de cursos este semestre'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final count = int.tryParse(value) ?? 0;
                setState(() {
                  _generateCourseInputs(count);
                });
              },
            ),
            SizedBox(height: 16),
            for (int i = 0; i < _eControllers.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _eControllers[i],
                    decoration: InputDecoration(labelText: 'Nota del curso ${i + 1}'),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  TextField(
                    controller: _rControllers[i],
                    decoration: InputDecoration(labelText: 'Créditos del curso ${i + 1}'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calculatePGA,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            if (promedio.isNotEmpty)
              Text('Promedio del semestre: $promedio', style: TextStyle(fontSize: 16)),
            if (pga.isNotEmpty)
              Text('PGA acumulado: $pga', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
