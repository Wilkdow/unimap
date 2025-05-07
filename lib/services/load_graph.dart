import 'dart:io';

import '../models/node_model.dart';
import 'package:unimap/services/astar_pathfinding.dart' as astar;

List<Node> loadData(List<String> csvData) {
  List<Node> nodes = [];
  Map nodesInfo = {};
  List neighbors = [];
  List types = [];

  for (int i = 1; i < csvData.length; i++) {
    final data = csvData[i].split(',');
    Node node = Node(
      id: data[0],
      x: double.parse(data[1]),
      y: double.parse(data[2]),
      z: double.parse(data[3]),
      neighbors: [],
    );

    neighbors.add(data[4].split(' '));
    types.add(data[5].split(' '));
    nodesInfo[node.id] = node;
    nodes.add(node);
  }

  for (int i = 0; i < nodes.length; i++) {
    for (int j = 0; j < neighbors[i].length; j++) {    
        double cost = astar.h(nodes[i].getPos(), nodesInfo[neighbors[i][j]].getPos());
        nodes[i].addNeighbor(nodesInfo[neighbors[i][j]], cost, types[i][j]);
    }
  }

  return nodes;
}

List<String> readCsvSync(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    return [];
  }

  return file.readAsLinesSync();
}

void main(List<String> args) {
  var nodes = loadData(readCsvSync("assets/CSVs/andes_buildings.csv"));
  var path = astar.algorithm(nodes, nodes[1], nodes[5]);
  print('Path: ');
  for (var x in path) {
    print(x.id);
  }
}
