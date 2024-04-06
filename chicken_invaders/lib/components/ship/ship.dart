import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/components/enemies/egg.dart';
import 'package:chicken_invaders/components/ship/ship_base.dart';
import 'package:chicken_invaders/components/ship/ship_engine.dart';
import 'package:chicken_invaders/components/ship/ship_engine_effect.dart';
import 'package:chicken_invaders/components/ship/ship_weapon.dart';
import 'package:chicken_invaders/utils/assets.dart';
import 'package:chicken_invaders/utils/audio_player.dart';
import 'package:chicken_invaders/utils/constants.dart';

class Ship extends PositionComponent
    with
        HasGameRef<ChickenInvaders>,
        KeyboardHandler,
        TapCallbacks,
        CollisionCallbacks {
  @override
  FutureOr<void> onLoad() async {
    size = Vector2(48, 48);

    final base = ShipBase(
      position: size / 2,
      anchor: Anchor.center,
    );

    await add(base);

    final engine = ShipEngine(
      priority: -1,
      position: size / 2,
      anchor: Anchor.center,
    );

    await add(engine);

    final engineEffect = ShipEngineEffect(
      priority: -2,
      position: size / 2,
      anchor: Anchor.center,
    );
    await add(engineEffect);

    final weapon = ShipWeapon(
      priority: -1,
      position: size / 2,
      anchor: Anchor.center,
    );
    await add(weapon);

    final hitBox = RectangleHitbox.relative(
      Vector2.all(0.6),
      parentSize: size,
      anchor: Anchor.center,
    );

    await add(hitBox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    final player = game.state.player;
    final movement = player.movement.value;
    final velocity = player.velocity.value;

    // TODO: check vector updates (since they are not triggering Value Notifier)

    // Calculate horizontal velocity
    if (movement.x != 0) {
      velocity.x += movement.x * Constants.ship.horizontalSpeed;
    } else {
      velocity.x *= 1 - Constants.ship.horizontalDeceleration;
    }

    if (velocity.x.abs() > Constants.ship.horizontalTerminalVelocity) {
      velocity.x = Constants.ship.horizontalTerminalVelocity * velocity.x.sign;
    }

    // Calculate vertical velocity
    if (movement.y != 0) {
      velocity.y += movement.y * Constants.ship.verticalSpeed;
    } else {
      velocity.y *= 1 - Constants.ship.verticalDeceleration;
    }

    if (velocity.y.abs() > Constants.ship.verticalTerminalVelocity) {
      velocity.y = Constants.ship.verticalTerminalVelocity * velocity.y.sign;
    }

    // Check if can move
    if (!player.canMoveLeft.value && velocity.x < 0) {
      velocity.x = 0;
    }
    if (!player.canMoveRight.value && velocity.x > 0) {
      velocity.x = 0;
    }
    if (!player.canMoveUp.value && velocity.y < 0) {
      velocity.y = 0;
    }
    if (!player.canMoveDown.value && velocity.y > 0) {
      velocity.y = 0;
    }

    // Update engine effect
    if (movement != Vector2.zero()) {
      player.shipEngineEffect.value = ShipEngineEffectType.powering;
    } else {
      player.shipEngineEffect.value = ShipEngineEffectType.idle;
    }

    // Update position
    final newX = position.x + velocity.x * dt;
    position.x = clampDouble(
      newX,
      0,
      game.size.x - scaledSize.x,
    );

    final clamped = newX != position.x;
    if (clamped) {
      game.state.player.velocity.value = Vector2.zero();
    }

    // position.y += velocity.y * dt;

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final player = game.state.player;

    player.movement.value = Vector2.zero();

    // Fire projectile
    if (event.logicalKey == LogicalKeyboardKey.space) {
      player.firePressed.value = event is KeyDownEvent;
    }

    // Switch weapon
    if (event.logicalKey == LogicalKeyboardKey.enter && event is KeyUpEvent) {
      _switchWeapon();
    }

    for (final keyPressed in keysPressed) {
      if (keyPressed == LogicalKeyboardKey.arrowLeft ||
          keyPressed == LogicalKeyboardKey.keyA) {
        player.movement.value.x -= 1;
      }

      if (keyPressed == LogicalKeyboardKey.arrowRight ||
          keyPressed == LogicalKeyboardKey.keyD) {
        player.movement.value.x += 1;
      }

      if (keyPressed == LogicalKeyboardKey.arrowUp ||
          keyPressed == LogicalKeyboardKey.keyW) {
        player.movement.value.y -= 1;
      }

      if (keyPressed == LogicalKeyboardKey.arrowDown ||
          keyPressed == LogicalKeyboardKey.keyS) {
        player.movement.value.y += 1;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollision(intersectionPoints, other);

    _allowAllMovement();

    if (other is ScreenHitbox) {
      final player = game.state.player;

      // Inside collisions
      for (final point in intersectionPoints) {
        if (point.x <= other.x) {
          player.canMoveLeft.value = false;
        }

        if (point.x >= other.x + other.width) {
          player.canMoveRight.value = false;
        }

        if (point.y <= other.y) {
          player.canMoveUp.value = false;
        }

        if (point.y >= other.y + other.height) {
          player.canMoveDown.value = false;
        }
      }
    }

    // Eat chicken wing: chomp.wav
    if (other is Egg) {
      _eggHit(other.damage);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    _allowAllMovement();

    super.onCollisionEnd(other);
  }

  void _allowAllMovement() {
    final player = game.state.player;

    player.canMoveLeft.value = true;
    player.canMoveRight.value = true;
    player.canMoveUp.value = true;
    player.canMoveDown.value = true;
  }

  void _switchWeapon() {
    game.state.player.switchWeapon();
  }

  void _eggHit(double damage) {
    final player = game.state.player;

    var health = player.health.value - damage;

    final gameOver = health <= 0;

    if (game.playSounds) {
      AudioPlayer.play(
        gameOver ? Assets.audio.gameOver : Assets.audio.shipHit,
        volume: gameOver
            ? Constants.sound.gameOverVolume
            : Constants.sound.shipHitVolume,
      );
    }

    if (gameOver) {
      health = 0;
      removeFromParent();

      // TODO: trigger game over screen
      // game.pauseEngine();
    }

    player.health.value = health;
  }
}
