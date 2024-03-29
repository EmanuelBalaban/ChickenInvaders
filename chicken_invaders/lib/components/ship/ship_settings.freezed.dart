// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ship_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShipSettings {
  double get health => throw _privateConstructorUsedError;
  ShipEngineType get engine => throw _privateConstructorUsedError;
  ShipWeaponType get weapon => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ShipSettingsCopyWith<ShipSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShipSettingsCopyWith<$Res> {
  factory $ShipSettingsCopyWith(
          ShipSettings value, $Res Function(ShipSettings) then) =
      _$ShipSettingsCopyWithImpl<$Res, ShipSettings>;
  @useResult
  $Res call({double health, ShipEngineType engine, ShipWeaponType weapon});
}

/// @nodoc
class _$ShipSettingsCopyWithImpl<$Res, $Val extends ShipSettings>
    implements $ShipSettingsCopyWith<$Res> {
  _$ShipSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? health = null,
    Object? engine = null,
    Object? weapon = null,
  }) {
    return _then(_value.copyWith(
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as double,
      engine: null == engine
          ? _value.engine
          : engine // ignore: cast_nullable_to_non_nullable
              as ShipEngineType,
      weapon: null == weapon
          ? _value.weapon
          : weapon // ignore: cast_nullable_to_non_nullable
              as ShipWeaponType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShipSettingsImplCopyWith<$Res>
    implements $ShipSettingsCopyWith<$Res> {
  factory _$$ShipSettingsImplCopyWith(
          _$ShipSettingsImpl value, $Res Function(_$ShipSettingsImpl) then) =
      __$$ShipSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double health, ShipEngineType engine, ShipWeaponType weapon});
}

/// @nodoc
class __$$ShipSettingsImplCopyWithImpl<$Res>
    extends _$ShipSettingsCopyWithImpl<$Res, _$ShipSettingsImpl>
    implements _$$ShipSettingsImplCopyWith<$Res> {
  __$$ShipSettingsImplCopyWithImpl(
      _$ShipSettingsImpl _value, $Res Function(_$ShipSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? health = null,
    Object? engine = null,
    Object? weapon = null,
  }) {
    return _then(_$ShipSettingsImpl(
      health: null == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as double,
      engine: null == engine
          ? _value.engine
          : engine // ignore: cast_nullable_to_non_nullable
              as ShipEngineType,
      weapon: null == weapon
          ? _value.weapon
          : weapon // ignore: cast_nullable_to_non_nullable
              as ShipWeaponType,
    ));
  }
}

/// @nodoc

class _$ShipSettingsImpl implements _ShipSettings {
  const _$ShipSettingsImpl(
      {required this.health, required this.engine, required this.weapon});

  @override
  final double health;
  @override
  final ShipEngineType engine;
  @override
  final ShipWeaponType weapon;

  @override
  String toString() {
    return 'ShipSettings(health: $health, engine: $engine, weapon: $weapon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShipSettingsImpl &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.engine, engine) || other.engine == engine) &&
            (identical(other.weapon, weapon) || other.weapon == weapon));
  }

  @override
  int get hashCode => Object.hash(runtimeType, health, engine, weapon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShipSettingsImplCopyWith<_$ShipSettingsImpl> get copyWith =>
      __$$ShipSettingsImplCopyWithImpl<_$ShipSettingsImpl>(this, _$identity);
}

abstract class _ShipSettings implements ShipSettings {
  const factory _ShipSettings(
      {required final double health,
      required final ShipEngineType engine,
      required final ShipWeaponType weapon}) = _$ShipSettingsImpl;

  @override
  double get health;
  @override
  ShipEngineType get engine;
  @override
  ShipWeaponType get weapon;
  @override
  @JsonKey(ignore: true)
  _$$ShipSettingsImplCopyWith<_$ShipSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
