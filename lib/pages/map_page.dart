import 'package:flutter/material.dart';
import 'package:unimap/models/node_model.dart';
import 'package:unimap/services/load_graph.dart' as load;
import 'package:unimap/services/astar_pathfinding.dart' as astar;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final String csvPath = "assets/CSVs/andes_buildings.csv";
  final String mapPngPath = 'assets/map/unimap.png';

  final TransformationController _transformationController =
      TransformationController();
  final List<Offset> markers = [];
  final offsetIcon = Offset(14, 27);

  late Map graph;
  late List<Node> shortestPath;

  @override
  void initState() {
    super.initState();

    _loadGraph(csvPath);
    //Set the initial pos to somewhere on the image
    _transformationController.value =
        Matrix4.identity()..setTranslationRaw(-1200, -430, 0); //"center" map
  }

  Future<void> _loadGraph(String path) async {
    graph = load.loadData(await load.readCsvAsync(path));
    setState(() {});
  }

  void _calculateShortestPath(Map graph, Node start, Node end) {
    shortestPath = astar.algorithm(graph, start, end);
    setState(() {});
  }

  void _setMarkers(List<Node> path) {
    for (var node in path) {
      markers.add(node.getOffset());
    }
    setState(() {});
  }

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
      markers.add(transformedPos);
    });
  }

  void _resetEverything() {
    markers.clear();
    shortestPath = [];
    setState(() {});
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
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(graph);
          _calculateShortestPath(graph, graph['AU_1'], graph['ML_4']);
          _setMarkers(shortestPath);
          print('Path');
          for (var node in shortestPath) {
            print(node.id);
          }
        },
      ),
    );
  }

  Expanded _mapVisualizer() {
    return Expanded(
      child: GestureDetector(
        onTapUp: (details) {
          // _handleTap(context, details);
          _resetEverything();
        },
        child: InteractiveViewer(
          transformationController: _transformationController,
          boundaryMargin: EdgeInsets.all(8.0),
          constrained: false,
          child: Stack(
            children: [
              SizedBox(
                height: 1500,
                child: Image.asset(mapPngPath, fit: BoxFit.cover),
              ),
              CustomPaint(painter: LinePainter(waypoints: markers)),
              //Add markers and stuff
              ...markers
                  .asMap()
                  .entries
                  .where(
                    (entry) =>
                        entry.key == 0 || entry.key == markers.length - 1,
                  )
                  .map((entry) {
                    final offSet = entry.value;
                    return Positioned(
                      left: offSet.dx - offsetIcon.dx,
                      top: offSet.dy - offsetIcon.dy,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 30,
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<dynamic> waypoints;

  LinePainter({required this.waypoints});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.red
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke;

    for (int i = 0; i < waypoints.length - 1; i++) {
      canvas.drawLine(waypoints[i], waypoints[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; //Redraw whenever markers change uwu
  }
}
