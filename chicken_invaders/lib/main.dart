import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'package:chicken_invaders/chicken_invaders.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mobile
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  final game = ChickenInvaders();

  runApp(
    GameWidget(
      game: kDebugMode ? ChickenInvaders() : game,
    ),
  );
}
