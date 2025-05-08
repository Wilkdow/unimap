import 'package:flutter/material.dart';

class Node {
  final String id;
  final String building;
  final String? type;
  final double x;
  final double y;
  final double z;
  final int? floor;
  final bool showOnSearch;
  final List<(Node, double, String)> neighbors;

  Node({
    required this.id,
    required this.x,
    required this.y,
    required this.z,
    required this.showOnSearch,
    required this.neighbors,
  }) : building = id.split('_')[0],
       floor = int.tryParse(_safeGet(id.split('_'), 1) ?? ''),
       type = _safeGet(id.split('_'), 2);

  (double, double, double) getPos() {
    return (x, y, z);
  }

  Offset getOffset() {
    return Offset(x, y);
  }

  static T? _safeGet<T>(List<T> list, int index) {
    if (index >= 0 && index < list.length) {
      return list[index];
    }
    return null;
  }

  void addNeighbor(neighbor, cost, type) {
    neighbors.add((neighbor, cost, type));
  }
}