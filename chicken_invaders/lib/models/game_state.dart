import 'package:flutter/material.dart';

import 'package:flame/game.dart';

import 'package:chicken_invaders/components/ship/ship_engine.dart';
import 'package:chicken_invaders/components/ship/ship_engine_effect.dart';
import 'package:chicken_invaders/components/ship/ship_weapon.dart';
import 'package:chicken_invaders/models/app_layout.dart';
import 'package:chicken_invaders/utils/constants.dart';

class GameState {
  const GameState({
    required this.playSounds,
    required this.volume,
    required this.showFPS,
    required this.appLayout,
    required this.player,
  });

  factory GameState.initial() => GameState(
        playSounds: ValueNotifier(true),
        volume: ValueNotifier(Constants.sound.baseVolume),
        showFPS: ValueNotifier(false),
        appLayout: ValueNotifier(AppLayout.current()),
        player: PlayerState.initial(),
      );

  final ValueNotifier<bool> playSounds;
  final ValueNotifier<double> volume;
  final ValueNotifier<bool> showFPS;
  final ValueNotifier<AppLayout> appLayout;
  final PlayerState player;
}

class PlayerState {
  const PlayerState({
    required this.health,
    required this.shipEngine,
    required this.shipEngineEffect,
    required this.shipWeapon,
    required this.firePressed,
    required this.movement,
    required this.velocity,
    required this.canMoveLeft,
    required this.canMoveRight,
    required this.canMoveUp,
    required this.canMoveDown,
  });

  factory PlayerState.initial() => PlayerState(
        health: ValueNotifier(100),
        shipEngine: ValueNotifier(ShipEngineType.base),
        shipEngineEffect: ValueNotifier(ShipEngineEffectType.idle),
        shipWeapon: ValueNotifier(ShipWeaponType.autoCannon),
        firePressed: ValueNotifier(false),
        movement: ValueNotifier(Vector2.zero()),
        velocity: ValueNotifier(Vector2.zero()),
        canMoveLeft: ValueNotifier(true),
        canMoveRight: ValueNotifier(true),
        canMoveUp: ValueNotifier(true),
        canMoveDown: ValueNotifier(true),
      );

  final ValueNotifier<double> health;
  final ValueNotifier<ShipEngineType> shipEngine;
  final ValueNotifier<ShipEngineEffectType> shipEngineEffect;
  final ValueNotifier<ShipWeaponType> shipWeapon;

  final ValueNotifier<bool> firePressed;
  final ValueNotifier<Vector2> movement;
  final ValueNotifier<Vector2> velocity;

  final ValueNotifier<bool> canMoveLeft;
  final ValueNotifier<bool> canMoveRight;
  final ValueNotifier<bool> canMoveUp;
  final ValueNotifier<bool> canMoveDown;

  void switchWeapon() {
    final weaponNotifier = shipWeapon;

    final weapon = weaponNotifier.value;

    final nextWeaponIndex = (weapon.index + 1) % ShipWeaponType.values.length;

    weaponNotifier.value = ShipWeaponType.values[nextWeaponIndex];
  }
}
