import 'package:flutter/material.dart';
import 'package:unimap/pages/map_page.dart';
import 'package:unimap/pages/calculadora_home_screen.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final List<Widget> pages = [
    MapPage(),
    CalculadoraHomeScreen(),
  ];

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFE0D34D),
        onTap: (value) {
          setState(() {
            if (value < pages.length) {
              currentPageIndex = value;
            }
          });
        },
        currentIndex: currentPageIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color.fromARGB(255, 52, 48, 48),
        iconSize: 30.0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'UniMapa'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculadora'),
        ],
      ),
    );
  }
}
