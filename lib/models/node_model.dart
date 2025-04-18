class Node {
  final String id;
  final String building;
  final int x;
  final int y;
  final int floor;
  final List neighbors;

  Node({
    required this.building,
    required this.x, 
    required this.y,
    required this.floor,
    required this.neighbors,
  }) : id = '${building}_$floor';

  (int, int) getPos() {
    return (x, y);
  }

  void addNeighbor(neighbor, cost, type) {
    neighbors.add((neighbor, cost, type));
  }
}