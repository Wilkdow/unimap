import 'dart:math';

import 'package:collection/collection.dart';
import 'package:unimap/models/node_model.dart';

double h(p1, p2) {
  var (x1, y1, z1) = p1;
  var (x2, y2, z2) = p2;
  return sqrt( pow(x1 - x2, 2) + pow(y1 - y2, 2) + pow(z1 - z1, 2) );
}

List reconstructPath(Map cameFrom, current) {
  List path = [];
  while (cameFrom.containsKey(current)) {
    path.add(current);
    current = cameFrom[current];
  }
  path.add(current);
  return path.reversed.toList();
}

List algorithm(graph, start, end) {
  List path = [];
  final pq = PriorityQueue<(double, Node)>((a, b) => a.$1.compareTo(b.$1));
  pq.add((0, start));
  Map cameFrom = {};
  Map gScore = {
    for (var node in graph) node.id: double.infinity
  };
  gScore[start.id] = 0;
  Map fScore = {
    for (var node in graph) node.id: double.infinity
  };
  fScore[start.id] = h(start.getPos(), end.getPos());
  List pqRecord = [start];

  while (pq.isNotEmpty) {
    var current = pq.removeFirst().$2;
    pqRecord.remove(current);

    if (current != end) {
      // ignore: unused_local_variable
      for (var (neighbor, cost, type) in current.neighbors) {
        double tempGScore = gScore[current.id] + cost;

        if (tempGScore < gScore[neighbor.id]) {
          cameFrom[neighbor] = current;
          gScore[neighbor.id] = tempGScore;
          fScore[neighbor.id] = tempGScore + h(current.getPos(), end.getPos());
          if (!pqRecord.contains(neighbor)) {
            pq.add((fScore[neighbor.id], neighbor));
            pqRecord.add(neighbor);
          }
        }
      }
    }
    else {
      path = reconstructPath(cameFrom, current);
    }
  }
  return path;
}