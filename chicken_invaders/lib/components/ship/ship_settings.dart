import 'package:chicken_invaders/components/ship/ship_engine.dart';
import 'package:chicken_invaders/components/ship/ship_weapon.dart';

class ShipSettings {
  const ShipSettings({
    required this.health,
    required this.engine,
    required this.weapon,
  });

  final double health;
  final ShipEngineType engine;
  final ShipWeaponType weapon;
}
