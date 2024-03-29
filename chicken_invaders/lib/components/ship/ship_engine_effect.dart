// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'dart:async';

import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/components/ship/ship_engine.dart';
import 'package:chicken_invaders/mixins/debug_enum.dart';

enum ShipEngineEffectType with DebugEnum {
  idle('Idle', 3),
  powering('Powering', 4);

  const ShipEngineEffectType(this.assetName, this.sequenceAmount);

  final String assetName;
  final int sequenceAmount;
}

class ShipEngineEffect
    extends SpriteAnimationGroupComponent<ShipEngineEffectType>
    with HasGameRef<ChickenInvaders> {
  ShipEngineEffect({
    this.engineType = ShipEngineType.base,
    super.position,
    super.anchor,
    super.priority,
    super.current = ShipEngineEffectType.idle,
  }) {
    // debugMode = true;
  }

  final ShipEngineType engineType;

  // Constants
  static const _animationStepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    animations = Map.fromEntries(
      ShipEngineEffectType.values.map(
        (state) => MapEntry(
          state,
          _createAnimation(state: state),
        ),
      ),
    );

    // scale = Vector2(0.5, 0.7);

    return super.onLoad();
  }

  SpriteAnimation _createAnimation({
    required ShipEngineEffectType state,
  }) =>
      SpriteAnimation.fromFrameData(
        game.images.fromCache(
          'Main Ship/'
          'Main Ship - Engine Effects/'
          'Main Ship - Engines - ${engineType.assetName} Engine - '
          '${state.assetName}.png',
        ),
        SpriteAnimationData.sequenced(
          amount: state.sequenceAmount,
          stepTime: _animationStepTime,
          textureSize: Vector2.all(48),
        ),
      );
}
