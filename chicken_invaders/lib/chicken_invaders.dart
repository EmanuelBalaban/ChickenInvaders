import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:flame/camera.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

import 'package:chicken_invaders/components/hud/fire_button.dart';
import 'package:chicken_invaders/components/hud/joystick.dart';
import 'package:chicken_invaders/components/hud/switch_weapon_button.dart';
import 'package:chicken_invaders/components/level.dart';
import 'package:chicken_invaders/components/ship/ship.dart';
import 'package:chicken_invaders/models/app_layout.dart';
import 'package:chicken_invaders/models/game_state.dart';

class ChickenInvaders extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        TapDetector,
        HasQuadTreeCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  final state = GameState.initial();

  bool get playSounds => state.playSounds.value;

  late final Ship ship;
  late final Joystick _joystick;
  late final FireButton _fireButton;
  late final SwitchWeaponButton _switchWeaponButton;
  late final FpsTextComponent _fpsText;

  @override
  FutureOr<void> onLoad() async {
    // Menu song: 2001.wav

    await images.loadAllFromPattern(
      RegExp(r'.*\.png$'),
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

    await world.add(ScreenHitbox());

    initializeCollisionDetection(
      mapDimensions: Rect.fromLTWH(0, 0, size.x, size.y),
    );

    _joystick = Joystick();
    _joystick.addListener(_updateJoystick);

    _fireButton = FireButton();
    _switchWeaponButton = SwitchWeaponButton();

    _fpsText = FpsTextComponent();

    state.appLayout.addListener(_onAppLayoutUpdates);
    state.showFPS.addListener(_onShowFpsUpdates);

    _onAppLayoutUpdates();
    _onShowFpsUpdates();

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    state.appLayout.value = AppLayout.current(
      screenSize: size.toSize(),
    );

    super.onGameResize(size);
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

  @override
  void onDispose() {
    _joystick.removeListener(_updateJoystick);
    state.appLayout.removeListener(_onAppLayoutUpdates);
    state.showFPS.removeListener(_onShowFpsUpdates);

    super.onDispose();
  }

  void _onAppLayoutUpdates() {
    final layout = state.appLayout.value;
    final isMobileLayout =
        layout == AppLayout.mobile || layout == AppLayout.tablet;

    final mobileHud = [
      _joystick,
      _fireButton,
      _switchWeaponButton,
    ];

    for (final component in mobileHud) {
      final isVisible = camera.viewport.contains(component);

      if (isMobileLayout && !isVisible) {
        camera.viewport.add(component);
      }

      if (!isMobileLayout && isVisible) {
        camera.viewport.remove(component);
      }
    }
  }

  void _onShowFpsUpdates() {
    final showFps = state.showFPS.value;
    final isFpsVisible = camera.viewport.contains(_fpsText);

    if (showFps) {
      if (isFpsVisible) {
        return;
      }

      camera.viewport.add(_fpsText);
    } else if (isFpsVisible) {
      camera.viewport.remove(_fpsText);
    }
  }

  /// Updates player's movement based on [_joystick]'s state.
  void _updateJoystick() {
    state.player.movement.value = _joystick.relativeDelta;
  }
}
