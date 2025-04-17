import 'package:flutter/material.dart';
import 'package:unimap/pages/map_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final List<Widget> pages = [MapPage()];
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            if (value < pages.length) {
              currentPageIndex = value;
            }
          });
        },
        currentIndex: currentPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'UniMapa'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculadora'),
        ],
      ),
    );
  }
}