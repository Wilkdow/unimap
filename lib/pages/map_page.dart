import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeText('Moises'),
            _mapVisualizer(),
          ],
        ),
      ),
    );
  }

  Expanded _mapVisualizer() {
    return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(
                  constrained: false,
                  child: SizedBox(
                    height: 1500,
                    child: Image.asset(
                      'assets/unimap.png',
                      fit: BoxFit.cover,
                      ),
                  ),
                ),
              ),
            ),
          );
  }
}

Padding _welcomeText(String name) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome,',
          //TODO: tune style
          style: TextStyle(fontSize: 24),
        ),
        Text(name, style: TextStyle(fontSize: 20)),
      ],
    ),
  );
}
