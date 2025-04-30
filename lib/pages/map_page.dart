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

  @override
  //Set the initial pos to somewhere on the image
  void initState() {
    super.initState();
    _transformationController.value =
        Matrix4.identity()..setTranslationRaw(-1200, -430, 0);
  }

  void _handleTap(BuildContext context, TapUpDetails details) {
    //Convert global tap position to local within the InteractiveViewer
    final offset = Offset(14, 27);
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);

    final matrix = _transformationController.value;
    final inverseMatrix = matrix.clone()..invert();
    final transformedPos = MatrixUtils.transformPoint(
      inverseMatrix,
      localPosition,
    );

    setState(() {
      defaultMarkers.add(transformedPos - offset);
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
        body: Stack(
          children: [
            _mapVisualizer(),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.amber
                ),
              ),
            ),
            ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _resetMarkers(),
      ),
    );
  }

  Expanded _mapVisualizer() {
    return Expanded(
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
                  child: Icon(Icons.location_on, color: Colors.red, size: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}