class Node {
  final String id;
  final String building;
  final double x;
  final double y;
  final int floor;
  final List neighbors;

  Node({
    required this.id,
    required this.x, 
    required this.y,
    required this.neighbors,
  }) : building = id.split('_')[0], floor = int.parse(id.split('_')[1]);

  (double, double) getPos() {
    return (x, y);
  }

  void addNeighbor(neighbor, cost, type) {
    neighbors.add((neighbor, cost, type));
  }
}