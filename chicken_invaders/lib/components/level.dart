import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'package:chicken_invaders/components/enemies/blue_bird.dart';
import 'package:chicken_invaders/components/ship/ship.dart';

class Level extends World {
  Level({
    required this.name,
    required this.ship,
  });

  final String name;
  final Ship ship;

  late TiledComponent level;

  // Constants
  static const _respawnTime = 1.0;

  // Variables
  final _enemySpawnPoints = List<Vector2>.empty(growable: true);
  int _enemiesCount = 0;
  double _accumulatedDt = 0;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$name.tmx', Vector2.all(16));

    add(level);

    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    for (final tiledObj in spawnPointLayer?.objects ?? []) {
      if (tiledObj is! TiledObject) {
        continue;
      }

      final spawnPoint = Vector2(tiledObj.x, tiledObj.y);

      switch (tiledObj.type) {
        case 'Ship':
          ship.position = spawnPoint;
          add(ship);
          break;
        case 'Enemy':
          final enemy = BlueBird(position: spawnPoint);

          _enemySpawnPoints.add(spawnPoint);

          add(enemy);
          break;
      }
    }

    _enemiesCount = _enemySpawnPoints.length;

    return super.onLoad();
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    super.onChildrenChanged(child, type);

    if (type == ChildrenChangeType.removed && child is BlueBird) {
      _enemiesCount--;

      if (_enemiesCount == 0) {
        _accumulatedDt = 0;
      }
    }
  }

  @override
  void update(double dt) {
    if (_enemiesCount == 0) {
      _accumulatedDt += dt;

      if (_accumulatedDt > _respawnTime) {
        _addEnemies();
      }
    }

    super.update(dt);
  }

  void _addEnemies() {
    addAll(
      _enemySpawnPoints.map(
        (spawnPoint) => BlueBird(position: spawnPoint),
      ),
    );
    _enemiesCount = _enemySpawnPoints.length;
  }
}
