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
  final String mapPngPath = 'assets/Map/unimap.png';

  final TransformationController _transformationController =
      TransformationController();

  final List<Offset> markers = [];
  final List<Offset> pathLineCoords = [];
  final offsetIcon = Offset(14, 27);
  final List<String> suggestions = [];

  Map<String, Node> graph = {};
  late List<Node> shortestPath;
  Node? start;
  Node? end;

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
    _loadSuggestions(graph);
    setState(() {});
  }

  void _loadSuggestions(Map<String, Node> graph) {
    for (Node node in graph.values) {
      if (node.showOnSearch) {
        suggestions.add(node.id);
      }
    }
    setState(() {});
  }

  void _calculateShortestPath(Map graph, Node start, Node end) {
    shortestPath = astar.algorithm(graph, start, end);
    setState(() {});
  }

  void _setMarkers(Node start, Node end) {
    markers.addAll([start.getOffset(), end.getOffset()]);
  }

  void _setPathLinesCoords(List<Node> path) {
    for (var node in path) {
      pathLineCoords.add(node.getOffset());
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
      pathLineCoords.add(transformedPos);
    });
  }

  void _handleAlgortihm() {
    print(start);
    print(end);
    print(graph);
    _calculateShortestPath(graph, start!, end!);
    _setPathLinesCoords(shortestPath);
    print('Path');
    for (var node in shortestPath) {
      print(node.id);
    }
  }

  void _resetEverything() {
    markers.clear();
    pathLineCoords.clear();
    shortestPath.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [_mapVisualizer(), _searchField()]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _handleAlgortihm();
        },
      ),
    );
  }

  Padding _searchField() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        children: [
          _autocompleteField(true),
          _autocompleteField(false),
        ],
      ),
    );
  }

  Autocomplete<String> _autocompleteField(bool isOrigin) {
    return Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable.empty();
            }
            return suggestions.where((String option) {
              return option.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              );
            });
          },
          onSelected: (option) {
            setState(() {
              isOrigin ? start = graph[option] :  end = graph[option];
            });
          },
          fieldViewBuilder: (
            context,
            textEditingController,
            focusNode,
            onFieldSubmitted,
          ) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: isOrigin ? 'Origen...' : 'Destino...',
                prefixIcon: Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.vertical(
                    top: isOrigin ? Radius.circular(18) : Radius.zero,
                    bottom: isOrigin ? Radius.zero : Radius.circular(18)
                  ),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                _resetEverything();
                if (suggestions.contains(value)) {
                  setState(() {
                    isOrigin ? start = graph[value] :  end = graph[value];
                  });
                }
                else {
                  setState(() {
                    isOrigin ? start = null :  end = null;
                  });
                }
              },
            );
          },
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
              CustomPaint(painter: LinePainter(waypoints: pathLineCoords)),
              //Add markers and stuff
              ...markers.map(
                (offSet) => Positioned(
                  left: offSet.dx - offsetIcon.dx,
                  top: offSet.dy - offsetIcon.dy,
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
