import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:chicken_invaders/components/joystick.dart';
import 'package:chicken_invaders/components/level.dart';
import 'package:chicken_invaders/components/player.dart';

class ChickenInvaders extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final Player player;
  Joystick? joystick;

  bool showJoystick = Platform.isAndroid || Platform.isIOS;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    camera.viewport = FixedResolutionViewport(resolution: Vector2(640, 360));
    camera.viewfinder.anchor = Anchor.topLeft;

    if (showJoystick) {
      addJoystick();
    }

    player = Player(
      character: 'Mask Dude',
      joystick: joystick,
    );

    world = Level(name: 'Level-01', player: player);

    add(ScreenHitbox());

    return super.onLoad();
  }

  void addJoystick() {
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

    camera.viewport.add(joystick!);
  }
}
