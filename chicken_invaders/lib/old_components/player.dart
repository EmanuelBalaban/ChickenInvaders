import 'dart:async';

import 'package:flutter/services.dart';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/mixins/debug_state.dart';
import 'package:chicken_invaders/old_components/collision_block.dart';
import 'package:chicken_invaders/old_components/joystick.dart';
import 'package:chicken_invaders/utils/collision_detection.dart';

enum PlayerState {
  idle,
  running,
  jump,
  doubleJump,
  wallJump,
  fall,
  hit;

  @override
  String toString() => name;
}

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with
        HasGameRef<ChickenInvaders>,
        KeyboardHandler,
        CollisionCallbacks,
        DebugState {
  Player({
    required this.character,
    this.joystick,
    super.position,
  }) : speed = maxSpeed {
    debugMode = true;
  }

  final String character;
  final Joystick? joystick;

  List<CollisionBlock> collisionBlocks = [];

  static const stepTime = 0.05;
  static const maxSpeed = 100.0;
  static const gravity = 9.8;
  static const jumpForce = 460.0;
  static const terminalVelocity = 300.0;

  double speed;
  Vector2 movement = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool jump = false;

  @override
  FutureOr<void> onLoad() async {
    animations = {
      PlayerState.idle: _createAnimation(state: 'Idle', amount: 11),
      PlayerState.running: _createAnimation(state: 'Run', amount: 12),
      PlayerState.jump: _createAnimation(state: 'Jump', amount: 1),
      PlayerState.doubleJump: _createAnimation(state: 'Double Jump', amount: 6),
      PlayerState.wallJump: _createAnimation(state: 'Wall Jump', amount: 5),
      PlayerState.fall: _createAnimation(state: 'Fall', amount: 1),
      PlayerState.hit: _createAnimation(state: 'Hit', amount: 7),
    };

    current = PlayerState.idle;

    add(RectangleHitbox());

    return super.onLoad();
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

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkCollisions(horizontal: true);
    _applyGravity(dt);
    _checkCollisions(horizontal: false);

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    movement = Vector2.zero();

    for (final keyPressed in keysPressed) {
      if (keyPressed == LogicalKeyboardKey.arrowLeft ||
          keyPressed == LogicalKeyboardKey.keyA) {
        movement.x -= 1;
      }

      if (keyPressed == LogicalKeyboardKey.arrowRight ||
          keyPressed == LogicalKeyboardKey.keyD) {
        movement.x += 1;
      }

      if (keyPressed == LogicalKeyboardKey.arrowUp ||
          keyPressed == LogicalKeyboardKey.keyW ||
          keyPressed == LogicalKeyboardKey.space) {
        jump = true;
      }

      if (keyPressed == LogicalKeyboardKey.arrowDown ||
          keyPressed == LogicalKeyboardKey.keyS) {
        // movement.y += 1;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  /// Updates player's [movement] and [speed] based on [joystick]'s state.
  void _updateJoystick() {
    movement = joystick?.relativeDelta ?? Vector2.zero();
  }

  /// Updates player's [current] state based on [velocity] and [scale].
  void _updatePlayerState() {
    var state = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x != 0) {
      state = PlayerState.running;
    }

    if (velocity.y > 0) {
      state = PlayerState.fall;
    } else if (velocity.y < 0) {
      state = PlayerState.jump;
    }

    current = state;
  }

  /// Updates player's [position] and [velocity]
  /// based on [movement] and [speed].
  void _updatePlayerMovement(double dt) {
    if (jump) {
      if (isOnGround) {
        velocity.y = -jumpForce;
        position.y += velocity.y * dt;
      }
      isOnGround = false;
      jump = false;
    }

    velocity.x = movement.x * speed;
    position.x += velocity.x * dt;
  }

  void _checkCollisions({required bool horizontal}) {
    isOnGround = false;

    for (final block in collisionBlocks) {
      if (checkCollision(this, block)) {
        if (horizontal) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - width;
          }

          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + width;
          }
        } else {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - height;
            isOnGround = true;
          }

          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += gravity;
    velocity.y = velocity.y.clamp(-jumpForce, terminalVelocity);
    position.y += velocity.y * dt;
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
