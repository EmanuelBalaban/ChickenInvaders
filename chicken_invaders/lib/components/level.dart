import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'package:chicken_invaders/components/player.dart';

class Level extends World {
  Level({
    required this.name,
    required this.player,
  });

  final String name;
  final Player player;

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$name.tmx', Vector2.all(16));

    add(level);

    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    for (final spawnPoint in spawnPointLayer?.objects ?? []) {
      if (spawnPoint is! TiledObject) {
        continue;
      }

      switch (spawnPoint.type) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);
          break;
      }
    }

    return super.onLoad();
  }
}
