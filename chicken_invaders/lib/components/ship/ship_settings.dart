import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:chicken_invaders/components/ship/ship_engine.dart';
import 'package:chicken_invaders/components/ship/ship_weapon.dart';

part 'ship_settings.freezed.dart';

@freezed
class ShipSettings with _$ShipSettings {
  const factory ShipSettings({
    required double health,
    required ShipEngineType engine,
    required ShipWeaponType weapon,
  }) = _ShipSettings;
}
