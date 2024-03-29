// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'dart:async';

import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/components/projectile.dart';
import 'package:chicken_invaders/mixins/debug_enum.dart';

enum ShipWeaponType with DebugEnum {
  autoCannon(
    assetName: 'Auto Cannon',
    sequenceAmount: 7,
    projectileType: ProjectileType.autoCannonBullet,
    coolDownDt: 0.2,
  ),
  bigSpaceGun(
    assetName: 'Big Space Gun',
    sequenceAmount: 12,
    projectileType: ProjectileType.bigSpaceGun,
    coolDownDt: 0.5,
  ),
  rockets(
    assetName: 'Rockets',
    sequenceAmount: 17,
    projectileType: ProjectileType.rocket,
    coolDownDt: 1,
  ),
  zapper(
    assetName: 'Zapper',
    sequenceAmount: 14,
    projectileType: ProjectileType.zapper,
    coolDownDt: 0.1,
  );

  const ShipWeaponType({
    required this.assetName,
    required this.sequenceAmount,
    required this.projectileType,

    /// Time it takes to fire a projectile (in seconds).
    required this.coolDownDt,
  });

  final String assetName;
  final int sequenceAmount;
  final ProjectileType projectileType;
  final double coolDownDt;
}

class ShipWeapon extends SpriteAnimationGroupComponent<ShipWeaponType>
    with HasGameRef<ChickenInvaders> {
  ShipWeapon({
    super.position,
    super.anchor,
    super.priority,
    super.current = ShipWeaponType.autoCannon,
  }) {
    // debugMode = true;
  }

  // Constants
  static const _animationStepTime = 0.05;

  void fire() {
    animationTicker?.reset();

    void spawnProjectile(Vector2 position) {
      final projectile = Projectile(current: current?.projectileType);
      game.world.add(projectile);
      projectile.position = position;
    }

    switch (current) {
      case ShipWeaponType.autoCannon:
        spawnProjectile(
          absolutePositionOfAnchor(Anchor.topLeft) + Vector2(5, 2),
        );
        spawnProjectile(
          absolutePositionOfAnchor(Anchor.topRight) + Vector2(-25, 2),
        );
        break;
      case ShipWeaponType.bigSpaceGun:
        spawnProjectile(
          absolutePositionOfAnchor(Anchor.topCenter) + Vector2(-10, 2),
        );
        break;
      default:
    }
  }

  @override
  FutureOr<void> onLoad() {
    animations = Map.fromEntries(
      ShipWeaponType.values.map(
        (state) => MapEntry(
          state,
          _createAnimation(state: state),
        ),
      ),
    );

    animationTicker?.onComplete = () {
      animationTicker?.currentIndex = 0;
      animationTicker?.clock = 0;
      animationTicker?.update(0);
    };

    animationTicker?.setToLast();

    return super.onLoad();
  }

  SpriteAnimation _createAnimation({
    required ShipWeaponType state,
  }) =>
      SpriteAnimation.fromFrameData(
        game.images.fromCache(
          'Main Ship/'
          'Main Ship - Weapons/'
          'Main Ship - Weapons - ${state.assetName}.png',
        ),
        SpriteAnimationData.sequenced(
          amount: state.sequenceAmount,
          stepTime: _animationStepTime,
          textureSize: Vector2.all(48),
          loop: false,
        ),
      );
}