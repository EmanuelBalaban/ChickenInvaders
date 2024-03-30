import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:flame/camera.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:chicken_invaders/components/hud/joystick.dart';
import 'package:chicken_invaders/components/level.dart';
import 'package:chicken_invaders/components/ship/ship.dart';
import 'package:chicken_invaders/components/ship/ship_engine.dart';
import 'package:chicken_invaders/components/ship/ship_settings.dart';
import 'package:chicken_invaders/components/ship/ship_weapon.dart';
import 'package:chicken_invaders/utils/platform.dart';

class ChickenInvaders extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasQuadTreeCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final Ship ship;

  Joystick? joystick;

  bool showJoystick = Platform.current().isMobile;

  bool playSounds = true;
  double soundVolume = 1.0;

  bool showFPS = true;

  @override
  FutureOr<void> onLoad() async {
    // Menu song: 2001.wav

    await images.loadAllImages();

    if (showJoystick) {
      await _addJoystick();
    }

    ship = Ship(
      settings: const ShipSettings(
        health: 100,
        engine: ShipEngineType.base,
        weapon: ShipWeaponType.autoCannon,
      ),
      joystick: joystick,
    );

    world = Level(
      name: 'Level-01',
      ship: ship,
    );

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(640, 360),
    );
    camera.viewfinder.anchor = Anchor.topLeft;

    if (showJoystick) {
      await camera.viewport.add(joystick!);
    }

    await world.add(ScreenHitbox());

    if (showFPS) {
      await camera.viewport.add(FpsTextComponent());
    }

    initializeCollisionDetection(
      mapDimensions: Rect.fromLTWH(0, 0, size.x, size.y),
    );

    return super.onLoad();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);

    if ([
      AppLifecycleState.inactive,
      AppLifecycleState.detached,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ].contains(state)) {
      onGameIdle();
    }
  }

  void onGameIdle() {
    collisionDetection.broadphase.tree.optimize();
  }

  Future<void> _addJoystick() async {
    joystick = Joystick(
      knob: SpriteComponent.fromImage(
        images.fromCache('HUD/Knob.png'),
      ),
      background: SpriteComponent.fromImage(
        images.fromCache('HUD/Joystick.png'),
      ),
      margin: const EdgeInsets.only(
        left: 32,
        bottom: 32,
      ),
    );
  }
}
