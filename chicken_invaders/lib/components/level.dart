import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'package:chicken_invaders/components/collision_block.dart';
import 'package:chicken_invaders/components/player.dart';

class Level extends World {
  Level({
    required this.name,
    required this.player,
  });

  final String name;
  final Player player;

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

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

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    for (final collision in collisionsLayer?.objects ?? []) {
      if (collision is! TiledObject) {
        continue;
      }

      final block = CollisionBlock(
        position: Vector2(collision.x, collision.y),
        size: Vector2(collision.width, collision.height),
      );

      // switch (collision.type) {
      //   case 'Platform':
      //     break;
      //   default:
      // }

      collisionBlocks.add(block);
      add(block);
    }

    player.collisionBlocks = collisionBlocks;

    return super.onLoad();
  }
}
