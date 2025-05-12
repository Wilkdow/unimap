// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:math';

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
  final String csvPath = "assets/CSVs/andes_buildings1.csv";
  final String mapPngPath = 'assets/Map/unimap.png';
  final offsetIcon = Offset(12.5, 24);
  final (double, double, double) initPosCam = (-2100, -820, 0);
  final double scale = 0.55;

  final TransformationController _transformationController =
      TransformationController();

  final List<Offset> markers = [];
  final List<Offset> pathLineCoords = [];
  final Map<String, String> suggestions = {};
  ValueNotifier<Map<String, int>> preferences = ValueNotifier({
    'stairs': 0,
    'elevator': 0,
    'electricstairs': 0,
  });
  final Map<String, int> preferencesBackup = {
    'stairs': 0,
    'elevator': 0,
    'electricstairs': 0,
  };
  List<Color> preferencesColors = [
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.redAccent,
  ];

  List debugMarkers = [];

  Map<String, Node> graph = {};
  List<Node> shortestPath = [];
  Node? start;
  Node? end;

  @override
  void initState() {
    super.initState();
    _loadGraph(csvPath);
    //Set the initial pos to somewhere on the image
    _transformationController.value =
        Matrix4.identity()
          ..scale(scale)
          ..setTranslationRaw(
            initPosCam.$1 * scale,
            initPosCam.$2 * scale,
            initPosCam.$3 * scale,
          ); //"center" map
  }

  Future<void> _loadGraph(String path) async {
    graph = load.loadData(await load.readCsvAsync(path));
    _loadSuggestions(graph);
    setState(() {});
  }

  void _changePreference(String preference) {
    preferences.value[preference] = (preferences.value[preference]! + 1) % 3;
    preferences.notifyListeners();
    setState(() {});
  }

  void _changeAllPreferences(int T) {
    for (var preference in preferences.value.keys) {
      preferences.value[preference] = T;
    }
    preferences.notifyListeners();
    setState(() {});
  }

  void _restorePreference(String pref) {
    preferences.value[pref] = preferencesBackup[pref]!;
    preferences.notifyListeners();
    setState(() {});
  }

  void _restoreAllPreferences() {
    preferences.value = preferencesBackup;
    preferences.notifyListeners();
    setState(() {});
  }

  void _loadSuggestions(Map<String, Node> graph) {
    for (Node node in graph.values) {
      if (node.showOnSearch) {
        suggestions[node.searchName!] = node.id;
      }
    }
    setState(() {});
  }

  Map<String, Offset?> _getCoords(List<Offset> pathLineCoords) {
    Map<String, Offset?> coords = {'min': null, 'middle': null, 'max': null};
    for (Offset coord in pathLineCoords) {
      if (coords['min'] != null) {
        if (coords['min']!.dx > coord.dx) {
          coords['min'] = Offset(coord.dx, coords['min']!.dy);
        }
        if (coords['min']!.dy > coord.dy) {
          coords['min'] = Offset(coords['min']!.dx, coord.dy);
        }
      } else {
        coords['min'] = coord;
      }

      if (coords['max'] != null) {
        if (coords['max']!.dx < coord.dx) {
          coords['max'] = Offset(coord.dx, coords['max']!.dy);
        }
        if (coords['max']!.dy < coord.dy) {
          coords['max'] = Offset(coords['max']!.dx, coord.dy);
        }
      } else {
        coords['max'] = coord;
      }
    }
    coords['middle'] = (coords['min']! + coords['max']!) / 2;

    coords['min'] = coords['min']! - Offset(50, 150);
    coords['max'] = coords['max']! + Offset(50, 100);

    return coords;
  }

  void _calculateShortestPath(Map graph, Node start, Node end) {
    shortestPath = astar.algorithm(graph, start, end, preferences.value);
    setState(() {});
  }

  void _setMarkers(Node start, Node end) {
    markers.addAll([start.getOffset(), end.getOffset()]);
    setState(() {});
  }

  void _setPathLinesCoords(List<Node> path) {
    for (var node in path) {
      pathLineCoords.add(node.getOffset());
    }
    setState(() {});
  }

  // ignore: unused_element
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

    debugMarkers.add(transformedPos);
    print(debugMarkers);
    setState(() {});
  }

  void _handleAlgortihm(Size screenSize) {
    if (shortestPath.isEmpty) {
      _calculateShortestPath(graph, start!, end!);
      if (shortestPath.isNotEmpty) {
        _setPathLinesCoords(shortestPath);
        _setMarkers(start!, end!);

        var coords = _getCoords(pathLineCoords);
        double distanceNodesX = (coords['min']!.dx - coords['max']!.dx).abs();
        double distanceNodesY = (coords['min']!.dy - coords['max']!.dy).abs();
        double scaleX = (screenSize.width - 5) / distanceNodesX;
        double scaleY = (screenSize.height - 165) / distanceNodesY;
        double scale = min(scaleX, scaleY);

        final (double, double) translationMiddle = (
          (coords['middle']!.dx - 2.5 - screenSize.width / 2) * scale,
          (coords['middle']!.dy - 165 - screenSize.height / 2) * scale,
        );

        final (double, double) translationMin = (
          -(coords['min']!.dx - 2.5) * scale,
          -(coords['min']!.dy - 165) * scale,
        );

        final translationX =
            scaleX < scaleY ? translationMin.$1 : -translationMiddle.$1;
        final translationY =
            scaleX > scaleY ? translationMin.$2 : -translationMiddle.$2;

        _transformationController.value =
            Matrix4.identity()
              ..setTranslationRaw(translationMin.$1, translationMin.$2, 0)
              ..scale((scale));
      } else {
        _showTooltip(
          context,
          'No se encontró un camino para llegar a tu destino, revisa tus filtros/preferencias',
        );
      }
    }
  }

  void _showTooltip(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _resetEverything() {
    markers.clear();
    pathLineCoords.clear();
    shortestPath.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: [_mapVisualizer(), _searchField(screenSize)]),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          debugMarkers.removeLast();
        });
      }),
    );
  }

  FloatingActionButton _filterButton() {
    double fontSize1 = 15;

    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: Text(
                '¿Qué tipo caminos te gustaría evitar?',
                textAlign: TextAlign.center,
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      spacing: 5,
                      children: [
                        Flexible(
                          child: Text(
                            'Puedo',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize1,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: preferencesColors[0],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'Prefiero no',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize1 - 2,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: preferencesColors[1],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'No puedo',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize1,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: preferencesColors[2],
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _askPreferencesButtons('Escaleras', 'stairs'),
                  _askPreferencesButtons(
                    'Escaleras electricas',
                    'electricstairs',
                  ),
                  _askPreferencesButtons('Elevadores', 'elevator'),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Padding _askPreferencesButtons(String prefTitle, String pref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$prefTitle: '),
          GestureDetector(
            onTap: () => _changePreference(pref),
            onLongPress: () => _restorePreference(pref),
            child: ValueListenableBuilder(
              valueListenable: preferences,
              builder: (context, value, child) {
                return Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: _returnColorPreference(value[pref]!),
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _returnColorPreference(int i) {
    late Color color;
    if (i == 0) {
      color = preferencesColors[0];
    } else if (i == 1) {
      color = preferencesColors[1];
    } else {
      color = preferencesColors[2];
    }
    return color;
  }

  Padding _searchField(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Column(
        children: [
          _autocompleteField(true, screenSize),
          _autocompleteField(false, screenSize),
        ],
      ),
    );
  }

  Autocomplete<String> _autocompleteField(bool isOrigin, Size screenSize) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable.empty();
        }
        return suggestions.keys.where((String option) {
          return option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (option) {
        setState(() {
          isOrigin
              ? start = graph[suggestions[option]]
              : end = graph[suggestions[option]];
        });
        if (start != null && end != null) {
          _handleAlgortihm(screenSize);
        }
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
                bottom: isOrigin ? Radius.zero : Radius.circular(18),
              ),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) {
            _resetEverything();
            if (suggestions.keys.contains(value)) {
              setState(() {
                isOrigin
                    ? start = graph[suggestions[value]]
                    : end = graph[suggestions[value]];
              });
            } else {
              setState(() {
                isOrigin ? start = null : end = null;
              });
            }
            if (start != null && end != null) {
              _handleAlgortihm(screenSize);
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
          _handleTap(context, details);
        },
        child: InteractiveViewer(
          transformationController: _transformationController,
          boundaryMargin: EdgeInsets.all(8.0),
          constrained: false,
          minScale: 0.3,
          maxScale: 1.5,
          child: Stack(
            children: [
              Image.asset(mapPngPath, fit: BoxFit.cover),
              CustomPaint(painter: LinePainter(waypoints: pathLineCoords)),
              //Add markers and stuff
              ...markers.asMap().entries.map((entry) {
                int index = entry.key;
                Offset offset = entry.value - offsetIcon;

                IconData icon = Icons.location_on;
                if (index == markers.length - 1) {
                  icon = Icons.sports_score;
                }

                return Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: Icon(icon, color: Colors.red),
                );
              }),

              ...debugMarkers.map((marker) {
                Offset offset = marker - offsetIcon;
                return Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: Icon(Icons.location_on, color: Colors.amber),
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
