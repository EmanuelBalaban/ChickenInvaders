import 'dart:async';

import 'package:flutter/services.dart';

import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';

enum PlayerState {
  idle,
  running,
  jump,
  doubleJump,
  wallJump,
  fall,
  hit,
}

enum PlayerDirection {
  left(-1),
  none(0),
  right(1);

  const PlayerDirection(this.delta);

  final double delta;
}

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<ChickenInvaders>, KeyboardHandler {
  Player({
    required this.character,
    this.joystick,
    super.position,
  });

  final String character;
  final JoystickComponent? joystick;

  final stepTime = 0.05;
  final fullSpeed = 100.0;

  PlayerDirection playerDirection = PlayerDirection.none;
  late double moveSpeed = fullSpeed;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() async {
    animations = {
      PlayerState.idle: _createAnimation(state: 'Idle', amount: 11),
      PlayerState.running: _createAnimation(state: 'Run', amount: 12),
    };

    current = PlayerState.idle;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateJoystick();
    _updatePlayerMovement(dt);

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    var delta = 0.0;

    for (final keyPressed in keysPressed) {
      if (keyPressed == LogicalKeyboardKey.arrowLeft ||
          keyPressed == LogicalKeyboardKey.keyA) {
        delta += PlayerDirection.left.delta;
      }

      if (keyPressed == LogicalKeyboardKey.arrowRight ||
          keyPressed == LogicalKeyboardKey.keyD) {
        delta += PlayerDirection.right.delta;
      }
    }

    playerDirection =
        PlayerDirection.values.firstWhere((element) => element.delta == delta);

    return super.onKeyEvent(event, keysPressed);
  }

  void _updateJoystick() {
    if (joystick == null) {
      return;
    }

    switch (joystick?.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        playerDirection = PlayerDirection.right;
        break;
      default:
        playerDirection = PlayerDirection.none;
        break;
    }

    final delta = joystick?.relativeDelta.x ?? 1;

    moveSpeed = (delta * fullSpeed).abs();
  }

  void _updatePlayerMovement(double dt) {
    current = playerDirection == PlayerDirection.none
        ? PlayerState.idle
        : PlayerState.running;
    final dirX = moveSpeed * playerDirection.delta;

    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        break;
      default:
    }

    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }

  SpriteAnimation _createAnimation({
    required String state,
    required int amount,
  }) =>
      SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
        ),
      );
}
