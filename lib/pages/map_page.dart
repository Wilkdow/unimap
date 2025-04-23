import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TransformationController _transformationController =
      TransformationController();
  final List defaultMarkers = [];

  void _handleTap(BuildContext context, TapUpDetails details) {
    //Convert global tap position to local within the InteractiveViewer
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    final matrix = _transformationController.value;
    final inverseMatrix = matrix.clone()..invert();
    final transformedPos = MatrixUtils.transformPoint(
      inverseMatrix,
      localPosition,
    );

    setState(() {
      defaultMarkers.add(transformedPos - Offset(33.5, 155));
    });
  }

  void _resetMarkers() {
    setState(() {
      defaultMarkers.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _welcomeText('Moises'), 
            _mapVisualizer()
            ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _resetMarkers(),
      ),
    );
  }

  Expanded _mapVisualizer() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GestureDetector(
            onTapUp: (details) {
              _handleTap(context, details);
              print(defaultMarkers);
              },
            child: InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: EdgeInsets.all(8.0),
              constrained: false,
              child: Stack(
                children: [
                  SizedBox(
                    height: 1500,
                    child: Image.asset('assets/unimap.png', fit: BoxFit.cover),
                  ),
                    //Add markers and stuff
                  ...defaultMarkers.map(
                    (offSet) => Positioned(
                      left: offSet.dx,
                      top: offSet.dy,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ),
                ],
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
