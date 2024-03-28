import 'dart:async';

import 'package:flutter/services.dart';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/mixins/debug_enum.dart';

enum ShipHealthState with DebugEnum {
  fullHealth('Full health'),
  slightDamage('Slight damage'),
  damaged('Damaged'),
  veryDamaged('Very damaged');

  const ShipHealthState(this.assetName);

  final String assetName;
}

enum ShipEngineState with DebugEnum {
  idle,
  powering;
}

enum ShipEngineType with DebugEnum {
  base,
  burst,
  bigPulse,
  supercharged;
}

enum ShipShieldType with DebugEnum {
  front,
  frontAndSide,
  round,
  invincibility;
}

enum ShipWeaponType with DebugEnum {
  autoCannon,
  bigSpaceGun,
  rockets,
  zapper;
}

class Ship extends SpriteGroupComponent<ShipHealthState>
    with HasGameRef<ChickenInvaders>, KeyboardHandler, CollisionCallbacks {
  Ship() {
    // debugMode = true;
  }

  // Constants
  static const _horizontalSpeed = 6.0;
  static const _verticalSpeed = 3.0;
  static const _horizontalDeceleration = 0.02;
  static const _verticalDeceleration = 0.01;
  static const _horizontalTerminalVelocity = 300.0;
  static const _verticalTerminalVelocity = 150.0;

  // Variables
  Vector2 _movement = Vector2.zero();
  final _velocity = Vector2.zero();

  bool _canMoveLeft = true;
  bool _canMoveRight = true;
  bool _canMoveUp = true;
  bool _canMoveDown = true;

  @override
  FutureOr<void> onLoad() async {
    sprites = Map.fromEntries(
      ShipHealthState.values.map(
        (state) => MapEntry(
          state,
          _createSprite(state: state),
        ),
      ),
    );

    current = ShipHealthState.fullHealth;

    add(
      RectangleHitbox.relative(
        Vector2.all(0.6),
        parentSize: size,
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // Calculate horizontal velocity
    if (_movement.x != 0) {
      _velocity.x += _movement.x * _horizontalSpeed;
    } else {
      _velocity.x *= 1 - _horizontalDeceleration;
    }

    if (_velocity.x.abs() > _horizontalTerminalVelocity) {
      _velocity.x = _horizontalTerminalVelocity * _velocity.x.sign;
    }

    // Calculate vertical velocity
    if (_movement.y != 0) {
      _velocity.y += _movement.y * _verticalSpeed;
    } else {
      _velocity.y *= 1 - _verticalDeceleration;
    }

    if (_velocity.y.abs() > _verticalTerminalVelocity) {
      _velocity.y = _verticalTerminalVelocity * _velocity.y.sign;
    }

    // Check if can move
    if (!_canMoveLeft && _velocity.x < 0) {
      _velocity.x = 0;
    }
    if (!_canMoveRight && _velocity.x > 0) {
      _velocity.x = 0;
    }
    if (!_canMoveUp && _velocity.y < 0) {
      _velocity.y = 0;
    }
    if (!_canMoveDown && _velocity.y > 0) {
      _velocity.y = 0;
    }

    // Update position
    position.x += _velocity.x * dt;
    position.y += _velocity.y * dt;

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _movement = Vector2.zero();

    for (final keyPressed in keysPressed) {
      if (keyPressed == LogicalKeyboardKey.arrowLeft ||
          keyPressed == LogicalKeyboardKey.keyA) {
        _movement.x -= 1;
      }

      if (keyPressed == LogicalKeyboardKey.arrowRight ||
          keyPressed == LogicalKeyboardKey.keyD) {
        _movement.x += 1;
      }

      if (keyPressed == LogicalKeyboardKey.arrowUp ||
          keyPressed == LogicalKeyboardKey.keyW) {
        _movement.y -= 1;
      }

      if (keyPressed == LogicalKeyboardKey.arrowDown ||
          keyPressed == LogicalKeyboardKey.keyS) {
        _movement.y += 1;
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
      for (final point in intersectionPoints) {
        if (point.x == 0) {
          _canMoveLeft = false;
        }

        if (point.x == game.size.x) {
          _canMoveRight = false;
        }

        if (point.y == 0) {
          _canMoveUp = false;
        }

        if (point.y == game.size.y) {
          _canMoveDown = false;
        }
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    _allowAllMovement();

    super.onCollisionEnd(other);
  }

  void _allowAllMovement() {
    _canMoveLeft = true;
    _canMoveRight = true;
    _canMoveUp = true;
    _canMoveDown = true;
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
