class Node {
  final String id;
  final String building;
  final double x;
  final double y;
  final int floor;
  final List neighbors;

  Node({
    required this.building,
    required this.x, 
    required this.y,
    required this.floor,
    required this.neighbors,
  }) : id = '${building}_$floor';

  (double, double) getPos() {
    return (x, y);
  }

  void addNeighbor(neighbor, cost, type) {
    neighbors.add((neighbor, cost, type));
  }
}