import 'dart:async';

import 'package:flutter/services.dart';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/components/ship/ship_base.dart';
import 'package:chicken_invaders/components/ship/ship_engine.dart';
import 'package:chicken_invaders/components/ship/ship_engine_effect.dart';
import 'package:chicken_invaders/components/ship/ship_settings.dart';
import 'package:chicken_invaders/components/ship/ship_weapon.dart';
import 'package:chicken_invaders/old_components/joystick.dart';

class Ship extends PositionComponent
    with HasGameRef<ChickenInvaders>, KeyboardHandler, CollisionCallbacks {
  Ship({
    required ShipSettings settings,
    this.joystick,
  }) : _settings = settings {
    // debugMode = true;
  }

  final Joystick? joystick;

  ShipSettings get settings => _settings;

  set settings(ShipSettings settings) {
    _settings = settings;

    final shipHealth = ShipHealthState.fromHealth(_settings.health);

    _base.current = shipHealth;
    _engine.current = _settings.engine;

    // TODO: fix
    // _engineEffect.engineType = _settings.engine;

    _weapon.current = _settings.weapon;
  }

  // Constants
  static const _horizontalSpeed = 6.0;
  static const _verticalSpeed = 3.0;
  static const _horizontalDeceleration = 0.02;
  static const _verticalDeceleration = 0.01;
  static const _horizontalTerminalVelocity = 300.0;
  static const _verticalTerminalVelocity = 150.0;

  // Variables
  ShipSettings _settings;
  late final ShipBase _base;
  late final ShipEngine _engine;
  late final ShipEngineEffect _engineEffect;
  late final ShipWeapon _weapon;

  bool _spaceDown = false;
  double _projectileAccumulatedDt = 0;

  Vector2 _movement = Vector2.zero();
  final _velocity = Vector2.zero();

  bool _canMoveLeft = true;
  bool _canMoveRight = true;
  bool _canMoveUp = true;
  bool _canMoveDown = true;

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(48, 48);

    final shipHealth = ShipHealthState.fromHealth(settings.health);

    _base = ShipBase(
      position: size / 2,
      anchor: Anchor.center,
      current: shipHealth,
    );

    await add(_base);

    _engine = ShipEngine(
      priority: -1,
      position: size / 2,
      anchor: Anchor.center,
      current: settings.engine,
    );

    await add(_engine);

    _engineEffect = ShipEngineEffect(
      priority: -2,
      position: size / 2,
      anchor: Anchor.center,
      engineType: settings.engine,
    );
    await add(_engineEffect);

    _weapon = ShipWeapon(
      priority: -1,
      position: size / 2,
      anchor: Anchor.center,
      current: settings.weapon,
    );
    await add(_weapon);

    final hitbox = RectangleHitbox.relative(
      Vector2.all(0.6),
      parentSize: size,
      anchor: Anchor.center,
    );

    await add(hitbox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _projectileAccumulatedDt += dt;
    if (_spaceDown) {
      if (_projectileAccumulatedDt >= settings.weapon.coolDownDt) {
        _projectileAccumulatedDt = 0;
        _weapon.fire();
      }
    }

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

    // Update engine effect
    if (_movement != Vector2.zero()) {
      _engineEffect.current = ShipEngineEffectType.powering;
    } else {
      _engineEffect.current = ShipEngineEffectType.idle;
    }

    // Update position
    position.x += _velocity.x * dt;
    position.y += _velocity.y * dt;

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _movement = Vector2.zero();

    // Fire projectile
    if (event.logicalKey == LogicalKeyboardKey.space) {
      _spaceDown = event is RawKeyDownEvent;
    }

    // Switch weapon
    if (event.logicalKey == LogicalKeyboardKey.enter &&
        event is RawKeyUpEvent) {
      _switchWeapon();
    }

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
      // Inside collisions
      for (final point in intersectionPoints) {
        if (point.x <= other.x) {
          _canMoveLeft = false;
        }

        if (point.x >= other.x + other.width) {
          _canMoveRight = false;
        }

        if (point.y <= other.y) {
          _canMoveUp = false;
        }

        if (point.y >= other.y + other.height) {
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

  @override
  void onMount() {
    joystick?.addListener(_updateJoystick);

    super.onMount();
  }

  @override
  void onRemove() {
    joystick?.removeListener(_updateJoystick);

    super.onRemove();
  }

  /// Updates player's [_movement] based on [joystick]'s state.
  void _updateJoystick() {
    _movement = joystick?.relativeDelta ?? Vector2.zero();
  }

  void _allowAllMovement() {
    _canMoveLeft = true;
    _canMoveRight = true;
    _canMoveUp = true;
    _canMoveDown = true;
  }

  void _switchWeapon() {
    final nextWeaponIndex =
        (settings.weapon.index + 1) % ShipWeaponType.values.length;

    settings = settings.copyWith(
      weapon: ShipWeaponType.values[nextWeaponIndex],
    );
  }
}
