import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/components/ship/ship.dart';

enum ProjectileType {
  autoCannonBullet(
    assetName: 'Auto cannon bullet',
    sequenceAmount: 4,
    damage: 20,
  ),
  bigSpaceGun(
    assetName: 'Big Space Gun',
    sequenceAmount: 10,
    damage: 100,
  ),
  rocket(
    assetName: 'Rocket',
    sequenceAmount: 3,
    damage: 75,
  ),
  zapper(
    assetName: 'Zapper',
    sequenceAmount: 8,
    damage: 50,
  );

  const ProjectileType({
    required this.assetName,
    required this.sequenceAmount,
    required this.damage,
  });

  final String assetName;
  final int sequenceAmount;
  final double damage;
}

class Projectile extends SpriteAnimationGroupComponent<ProjectileType>
    with HasGameRef<ChickenInvaders>, CollisionCallbacks {
  Projectile({
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

    scale = Vector2(0.6, 0.6);

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

    if (other is! Ship) {
      removeFromParent();
    }
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
