import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/math.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/components/enemies/egg.dart';
import 'package:chicken_invaders/components/ship/projectile.dart';
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
  BlueBird({super.position}) : super(priority: 1) {
    // debugMode = true;
  }

  // Constants
  static const _animationStepTime = 0.05; // 50 ms
  final double _hitAnimationTime =
      BlueBirdState.hit.sequenceAmount * _animationStepTime;
  static const _moves = 350;
  static const _speed = 10.0;
  static const _eggFixedDt = 2.0;

  // Variables
  double _eggAccumulatedDt = 0;
  double _hitAccumulatedDt = 0;
  double _health = 100;
  int _remainingMoves = _moves;
  bool _moveLeft = true;

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
      if (game.playSounds) {
        FlameAudio.play('rdfx31.wav', volume: game.soundVolume);
      }

      current = BlueBirdState.hit;
      _hitAccumulatedDt = 0;

      _health -= other.current?.damage ?? 0;

      if (_health <= 0) {
        // TODO: add sound effects
        // TODO: drop chicken
        removeFromParent();
      }
    }
  }

  @override
  void update(double dt) {
    if (current == BlueBirdState.hit) {
      _hitAccumulatedDt += dt;

      if (_hitAccumulatedDt >= _hitAnimationTime) {
        current = BlueBirdState.flying;
      }
    }

    position.x += _speed * dt * (_moveLeft ? -1 : 1);
    _remainingMoves--;

    if (_remainingMoves == 0) {
      _moveLeft = !_moveLeft;
      _remainingMoves = _moves;
    }

    _eggAccumulatedDt += dt;
    if (_eggAccumulatedDt >= _eggFixedDt) {
      _eggAccumulatedDt = 0;
      _spawnEgg();
    }

    super.update(dt);
  }

  void _spawnEgg() {
    // 33.33% chance
    if ((randomFallback.nextInt(100) % 10) != 0) {
      return;
    }

    if (game.playSounds) {
      FlameAudio.play('fx110.wav', volume: game.soundVolume * 0.6);
    }

    final egg = Egg();

    game.world.add(egg);

    egg.position = absolutePositionOfAnchor(Anchor.bottomCenter) +
        Vector2(egg.scaledSize.x / 2, -egg.scaledSize.y);
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
