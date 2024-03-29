import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';

enum ProjectileType {
  autoCannonBullet('Auto cannon bullet', 4),
  bigSpaceGun('Big Space Gun', 10),
  rocket('Rocket', 3),
  zapper('Zapper', 8);

  const ProjectileType(this.assetName, this.sequenceAmount);

  final String assetName;
  final int sequenceAmount;
}

class Bullet extends SpriteAnimationGroupComponent<ProjectileType>
    with HasGameRef<ChickenInvaders>, CollisionCallbacks {
  Bullet({
    super.position,
    super.current = ProjectileType.autoCannonBullet,
  }) {
    // debugMode = true;
  }

  // Constants
  static const _animationStepTime = 0.05; // 50 ms
  static const _speed = 200.0;

  @override
  FutureOr<void> onLoad() {
    animations = Map.fromEntries(
      ProjectileType.values.map(
        (state) => MapEntry(
          state,
          _createAnimation(state: state),
        ),
      ),
    );

    add(
      RectangleHitbox.relative(
        Vector2(0.3, 0.5),
        parentSize: size,
      ),
    );

    scale = Vector2(0.5, 0.5);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y -= _speed * dt;

    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    removeFromParent();
  }

  SpriteAnimation _createAnimation({
    required ProjectileType state,
  }) =>
      SpriteAnimation.fromFrameData(
        game.images.fromCache(
          'Main ship weapons/Main ship weapon - Projectile - ${state.assetName}.png',
        ),
        SpriteAnimationData.sequenced(
          amount: state.sequenceAmount,
          stepTime: _animationStepTime,
          textureSize: Vector2.all(32),
        ),
      );
}
