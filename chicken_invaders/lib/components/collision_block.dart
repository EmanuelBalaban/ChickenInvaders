import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  CollisionBlock({
    super.position,
    super.size,
  }) {
    debugMode = true;
  }

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());

    return super.onLoad();
  }
}
