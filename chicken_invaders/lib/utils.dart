import 'package:flame/components.dart';

bool checkCollision(PositionComponent a, PositionComponent b) {
  // TODO: use rect (more reliable)
  // print(a.toRect());

  final aX = a.isFlippedHorizontally ? a.x - a.width : a.x;
  final aY = a.isFlippedVertically ? a.y - a.height : a.y;
  final aWidth = a.width;
  final aHeight = a.height;

  final bX = b.isFlippedHorizontally ? b.x - b.width : b.x;
  final bY = b.isFlippedVertically ? b.y - b.height : b.y;
  final bWidth = b.width;
  final bHeight = b.height;

  return aY < bY + bHeight && // above
      aY + aHeight > bY && // below
      aX < bX + bWidth && // to the right
      aX + aWidth > bX; // to the left
}
