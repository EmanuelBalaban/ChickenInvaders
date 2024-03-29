import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/components/projectile.dart';
import 'package:chicken_invaders/mixins/debug_enum.dart';

enum BlueBirdState with DebugEnum {
  flying('Flying', 9),
  hit('Hit', 5);

  const BlueBirdState(this.assetName, this.sequenceAmount);

  final String assetName;
  final int sequenceAmount;
}

class BlueBird extends SpriteAnimationGroupComponent<BlueBirdState>
    with HasGameRef<ChickenInvaders>, CollisionCallbacks {
  BlueBird({super.position}) {
    // debugMode = true;
  }

  // Constants
  static const _animationStepTime = 0.05; // 50 ms
  final double _hitAnimationTime =
      BlueBirdState.hit.sequenceAmount * _animationStepTime;

  // Variables
  double _accumulatedDt = 0;
  double _health = 100;

  @override
  FutureOr<void> onLoad() {
    animations = Map.fromEntries(
      BlueBirdState.values.map(
        (state) => MapEntry(
          state,
          _createAnimation(state: state),
        ),
      ),
    );

    current = BlueBirdState.flying;

    add(
      RectangleHitbox.relative(
        Vector2(0.8, 0.7),
        parentSize: size,
      ),
    );

    return super.onLoad();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Projectile) {
      current = BlueBirdState.hit;
      _accumulatedDt = 0;

      _health -= other.current?.damage ?? 0;

      if (_health <= 0) {
        removeFromParent();
      }
    }
  }

  @override
  void update(double dt) {
    if (current == BlueBirdState.hit) {
      _accumulatedDt += dt;

      if (_accumulatedDt >= _hitAnimationTime) {
        current = BlueBirdState.flying;
      }
    }

    super.update(dt);
  }

  SpriteAnimation _createAnimation({
    required BlueBirdState state,
  }) =>
      SpriteAnimation.fromFrameData(
        game.images.fromCache(
          'Enemies/BlueBird/${state.assetName} (32x32).png',
        ),
        SpriteAnimationData.sequenced(
          amount: state.sequenceAmount,
          stepTime: _animationStepTime,
          textureSize: Vector2.all(32),
          loop: state != BlueBirdState.hit,
        ),
      );
}
