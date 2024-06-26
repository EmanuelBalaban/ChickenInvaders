// ignore_for_file: missing_whitespace_between_adjacent_strings

import 'dart:async';

import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/components/ship/projectile.dart';
import 'package:chicken_invaders/mixins/debug_enum.dart';
import 'package:chicken_invaders/utils/assets.dart';
import 'package:chicken_invaders/utils/audio_player.dart';
import 'package:chicken_invaders/utils/constants.dart';

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
  });

  static const _animationStepTime = 0.05;

  double _projectileAccumulatedDt = 0;

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

    _setupAnimationTicker();
    _updateState();

    game.state.player.shipWeapon.addListener(_updateState);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _projectileAccumulatedDt += dt;
    if (game.state.player.firePressed.value) {
      final coolDownDt = current?.coolDownDt ?? 0;

      if (_projectileAccumulatedDt >= coolDownDt) {
        _projectileAccumulatedDt = 0;
        _fire();
      }
    }

    super.update(dt);
  }

  @override
  void onRemove() {
    game.state.player.shipWeapon.removeListener(_updateState);

    super.onRemove();
  }

  @override
  set current(ShipWeaponType? value) {
    super.current = value;

    _setupAnimationTicker();
  }

  void _updateState() {
    current = game.state.player.shipWeapon.value;
  }

  void _fire() {
    if (game.playSounds) {
      AudioPlayer.play(
        Assets.audio.fireProjectile,
        volume: Constants.sound.fireProjectileVolume,
      );
    }

    animationTicker?.reset();

    void spawnProjectile(Vector2 position) {
      final projectile = Projectile(current: current?.projectileType);
      game.world.add(projectile);
      projectile.position = position;
      projectile.priority = -1;
    }

    switch (current) {
      case ShipWeaponType.autoCannon:
        spawnProjectile(
          absolutePositionOfAnchor(Anchor.topLeft) + Vector2(8, 2),
        );

        Future.delayed(
          const Duration(
            milliseconds: 20,
          ),
          () => spawnProjectile(
            absolutePositionOfAnchor(Anchor.topRight) + Vector2(-21, 2),
          ),
        );
        break;
      case ShipWeaponType.bigSpaceGun:
        spawnProjectile(
          absolutePositionOfAnchor(Anchor.topCenter) + Vector2(-10, 2),
        );
        break;
      case ShipWeaponType.rockets:
        // 1st row
        spawnProjectile(
          absolutePositionOfAnchor(Anchor.topLeft) + Vector2(2, 7.0),
        );
        spawnProjectile(
          absolutePositionOfAnchor(Anchor.topLeft) + Vector2(15, 7.0),
        );

        // 2nd row
        Future.delayed(
          const Duration(
            milliseconds: 200,
          ),
          () {
            spawnProjectile(
              absolutePositionOfAnchor(Anchor.topLeft) + Vector2(-2, 11.5),
            );
            spawnProjectile(
              absolutePositionOfAnchor(Anchor.topLeft) + Vector2(19, 11.5),
            );
          },
        );

        // 3rd row
        Future.delayed(
          const Duration(
            milliseconds: 400,
          ),
          () {
            spawnProjectile(
              absolutePositionOfAnchor(Anchor.topLeft) + Vector2(-6.5, 15),
            );
            spawnProjectile(
              absolutePositionOfAnchor(Anchor.topLeft) + Vector2(23.5, 15),
            );
          },
        );

        break;
      case ShipWeaponType.zapper:
        spawnProjectile(
          absolutePositionOfAnchor(Anchor.topCenter) + Vector2(-32, 2),
        );
      default:
    }
  }

  void _setupAnimationTicker() {
    animationTicker?.onComplete = () {
      animationTicker?.currentIndex = 0;
      animationTicker?.clock = 0;
      animationTicker?.update(0);
    };

    animationTicker?.setToLast();
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
