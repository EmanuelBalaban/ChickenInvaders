import 'dart:async';

import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/mixins/debug_enum.dart';

enum ShipHealthState with DebugEnum {
  fullHealth('Full health', 75),
  slightDamage('Slight damage', 50),
  damaged('Damaged', 25),
  veryDamaged('Very damaged', 0);

  const ShipHealthState(this.assetName, this.threshold);

  final String assetName;

  /// The ship will have the current health state until health value goes below
  /// this threshold.
  final double threshold;

  factory ShipHealthState.fromHealth(double health) =>
      ShipHealthState.values.firstWhere(
        (element) => health >= element.threshold,
      );
}

class ShipBase extends SpriteGroupComponent<ShipHealthState>
    with HasGameRef<ChickenInvaders> {
  ShipBase({
    super.position,
    super.anchor,
    super.priority,
  });

  @override
  FutureOr<void> onLoad() {
    sprites = Map.fromEntries(
      ShipHealthState.values.map(
        (state) => MapEntry(
          state,
          _createSprite(state: state),
        ),
      ),
    );

    _updateState();

    game.state.player.health.addListener(_updateState);

    return super.onLoad();
  }

  @override
  void onRemove() {
    game.state.player.health.removeListener(_updateState);

    super.onRemove();
  }

  void _updateState() {
    current = ShipHealthState.fromHealth(game.state.player.health.value);
  }

  Sprite _createSprite({
    required ShipHealthState state,
  }) =>
      Sprite(
        game.images.fromCache(
          'Main Ship/Main Ship - Bases/Main Ship - Base - ${state.assetName}.png',
        ),
      );
}
