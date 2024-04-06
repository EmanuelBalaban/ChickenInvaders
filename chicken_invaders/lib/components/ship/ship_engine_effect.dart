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
    super.position,
    super.anchor,
    super.priority,
  });

  static const _animationStepTime = 0.05;

  @override
  FutureOr<void> onLoad() {
    _updateAnimations();
    _updateState();

    game.state.player.shipEngine.addListener(_updateAnimations);
    game.state.player.shipEngineEffect.addListener(_updateState);

    return super.onLoad();
  }

  @override
  void onRemove() {
    game.state.player.shipEngine.removeListener(_updateAnimations);
    game.state.player.shipEngineEffect.removeListener(_updateState);

    super.onRemove();
  }

  void _updateState() {
    current = game.state.player.shipEngineEffect.value;
  }

  void _updateAnimations() {
    final shipEngine = game.state.player.shipEngine.value;

    animations = Map.fromEntries(
      ShipEngineEffectType.values.map(
        (state) => MapEntry(
          state,
          _createAnimation(
            state: state,
            engine: shipEngine,
          ),
        ),
      ),
    );
  }

  SpriteAnimation _createAnimation({
    required ShipEngineEffectType state,
    required ShipEngineType engine,
  }) =>
      SpriteAnimation.fromFrameData(
        game.images.fromCache(
          'Main Ship/'
          'Main Ship - Engine Effects/'
          'Main Ship - Engines - ${engine.assetName} Engine - '
          '${state.assetName}.png',
        ),
        SpriteAnimationData.sequenced(
          amount: state.sequenceAmount,
          stepTime: _animationStepTime,
          textureSize: Vector2.all(48),
        ),
      );
}
