// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'dart:async';

import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/mixins/debug_enum.dart';

enum ShipEngineType with DebugEnum {
  base('Base'),
  burst('Burst'),
  bigPulse('Big Pulse'),
  supercharged('Supercharged');

  const ShipEngineType(this.assetName);

  final String assetName;
}

class ShipEngine extends SpriteGroupComponent<ShipEngineType>
    with HasGameRef<ChickenInvaders> {
  ShipEngine({
    super.position,
    super.anchor,
    super.priority,
  });

  @override
  FutureOr<void> onLoad() async {
    sprites = Map.fromEntries(
      ShipEngineType.values.map(
        (state) => MapEntry(
          state,
          _createSprite(state: state),
        ),
      ),
    );

    _updateState();

    game.state.player.shipEngine.addListener(_updateState);

    return super.onLoad();
  }

  @override
  void onRemove() {
    game.state.player.shipEngine.removeListener(_updateState);

    super.onRemove();
  }

  void _updateState() {
    current = game.state.player.shipEngine.value;
  }

  Sprite _createSprite({
    required ShipEngineType state,
  }) =>
      Sprite(
        game.images.fromCache(
          'Main Ship/'
          'Main Ship - Engines/'
          'Main Ship - Engines - ${state.assetName} Engine.png',
        ),
      );
}
