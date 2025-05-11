import 'package:flutter/material.dart';

class Node {
  final String? searchName;
  final String id;
  final String building;
  final String type;
  final double x;
  final double y;
  final double z;
  final int? floor;
  final bool showOnSearch;
  final List<(Node, double, String)> neighbors;

  Node({
    required this.searchName,
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.z,
    required this.showOnSearch,
    required this.neighbors,
  }) : building = id.split('_')[0],
       floor = int.tryParse(_safeGet(id.split('_'), 1) ?? '');

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

  void addNeighbor(Node neighbor, double cost, String type) {
    neighbors.add((neighbor, cost, type));
  }
}