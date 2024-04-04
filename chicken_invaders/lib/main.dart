import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:window_manager/window_manager.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/models/platform.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final platform = Platform.current();

  // Desktop
  if (platform.isDesktop) {
    await windowManager.ensureInitialized();

    const windowSize = Size(1280, 750);
    const windowOptions = WindowOptions(
      size: windowSize,
      title: 'Chicken Invaders',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setResizable(false);
      await windowManager.setMaximizable(false);

      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Mobile
  if (platform.isMobile) {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
  }

  final game = ChickenInvaders();

  runApp(
    GameWidget(
      game: kDebugMode ? ChickenInvaders() : game,
    ),
  );
}
