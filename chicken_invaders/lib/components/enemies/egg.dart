import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/components/enemies/blue_bird.dart';
import 'package:chicken_invaders/components/ship/ship.dart';
import 'package:chicken_invaders/utils/assets.dart';
import 'package:chicken_invaders/utils/constants.dart';

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

    scale = Vector2(0.15, 0.15);

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
      if (game.playSounds && other is! Ship) {
        FlameAudio.play(
          Assets.audio.eggDestroy,
          volume: Constants.sound.eggDestroyVolume,
        );
      }

      removeFromParent();
    }

    super.onCollision(intersectionPoints, other);
  }
}
