import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/components/enemies/blue_bird.dart';

class Egg extends SpriteComponent
    with HasGameRef<ChickenInvaders>, CollisionCallbacks {
  Egg({super.position, this.damage = 20.0}) {
    // debugMode = true;
  }

  final double damage;

  // Constants
  static const _speed = 30.0;

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(
      game.images.fromCache('Solid Eggs/White.png'),
    );

    scale = Vector2(0.13, 0.13);

    await add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += _speed * dt;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is! BlueBird && other is! Egg) {
      removeFromParent();
    }

    super.onCollision(intersectionPoints, other);
  }
}
