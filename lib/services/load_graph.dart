import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

import '../models/node_model.dart';
import 'package:unimap/services/astar_pathfinding.dart' as astar;

Map<String, Node> loadData(List<List<String>> csvData) {
  List<Node> nodes = [];
  Map<String, Node> nodesInfo = {};
  List neighbors = [];

  for (int i = 1; i < csvData.length; i++) {
    final data = csvData[i];
    Node node = Node(
      searchName: data[6].isNotEmpty ? data[6] : null,
      id: data[0],
      type: data[5],
      x: double.parse(data[1]),
      y: double.parse(data[2]),
      z: double.parse(data[3]),
      showOnSearch: data[6].isNotEmpty,
      neighbors: [],
    );

    neighbors.add(data[4].split(' '));
    nodesInfo[node.id] = node;
    nodes.add(node);
  }

  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < neighbors[i].length; j++) {    
        double cost = astar.h(nodes[i].getPos(), nodesInfo[neighbors[i][j]]?.getPos());
        nodes[i].addNeighbor(nodesInfo[neighbors[i][j]]!, cost, nodesInfo[neighbors[i][j]]!.type);
    }
  }

  return nodesInfo;
}

Future<List<List<String>>> readCsvAsync(String path) async {
  var rawData = await rootBundle.loadString(path);
  List<List<String>> csvList = CsvToListConverter(shouldParseNumbers: false).convert(rawData);
  return csvList;
}