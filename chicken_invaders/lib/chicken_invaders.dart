import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:chicken_invaders/components/level.dart';
import 'package:chicken_invaders/components/ship.dart';
import 'package:chicken_invaders/old_components/joystick.dart';
import 'package:chicken_invaders/old_components/player.dart';
import 'package:chicken_invaders/utils/platform.dart';

class ChickenInvaders extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final Player player;
  late final Ship ship;

  Joystick? joystick;

  bool showJoystick = Platform.current().isMobile;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    if (showJoystick) {
      await addJoystick();
    }

    player = Player(
      character: 'Mask Dude',
      joystick: joystick,
    );

    ship = Ship();

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

    return super.onLoad();
  }

  Future<void> addJoystick() async {
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
