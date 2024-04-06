import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:chicken_invaders/chicken_invaders.dart';
import 'package:chicken_invaders/components/hud/joystick_background.dart';
import 'package:chicken_invaders/components/hud/joystick_knob.dart';
import 'package:chicken_invaders/mixins/listenable.dart' as project;

class Joystick extends PositionComponent
    with HasGameRef<ChickenInvaders>, DragCallbacks, project.Listenable {
  Joystick({
    this.dragRadiusFactor = 1.5,
  });

  /// Expands the drag radius by a given factor.
  final double dragRadiusFactor;

  /// The percentage `[0.0, 1.0]` the knob is dragged from the center to the
  /// edge.
  double intensity = 0.0;

  /// The amount the knob is dragged from the center, scaled to fit inside the
  /// bounds of the joystick.
  final Vector2 delta = Vector2.zero();

  /// The total amount the knob is dragged from the center of the joystick.
  final Vector2 _unscaledDelta = Vector2.zero();

  /// The percentage, presented as a [Vector2], and direction that the knob is
  /// currently pulled from its base position to a edge of the joystick.
  Vector2 get relativeDelta => delta / knobRadius;

  /// The radius from the center of the knob to the edge of as far as the knob
  /// can be dragged.
  double get knobRadius => _knob.radius * dragRadiusFactor;

  /// The position where the knob rests.
  late Vector2 _baseKnobPosition;

  Vector2? _lastRelativeDelta;

  late final JoystickKnob _knob;

  @override
  FutureOr<void> onLoad() async {
    size = Vector2.all(64);
    position = Vector2(
      32,
      game.size.y - size.y - 32,
    );

    _baseKnobPosition = size / 2;
    _knob = JoystickKnob(
      position: _baseKnobPosition,
      anchor: Anchor.center,
    );

    await add(
      JoystickBackground(),
    );
    await add(_knob);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    final knobRadius2 = knobRadius * knobRadius;
    delta.setFrom(_unscaledDelta);
    if (delta.isZero() && _knob.position != _baseKnobPosition) {
      _knob.position = _baseKnobPosition;
    } else if (delta.length2 > knobRadius2) {
      delta.scaleTo(knobRadius);
    }
    if (!delta.isZero()) {
      _knob.position
        ..setFrom(_baseKnobPosition)
        ..add(delta);
    }

    final lastRelativeDelta = _lastRelativeDelta?.clone();

    _lastRelativeDelta = relativeDelta;

    if (lastRelativeDelta != relativeDelta) {
      notifyListeners();
    }
  }

  @override
  bool onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _unscaledDelta.add(event.localDelta);
    return false;
  }

  @override
  bool onDragEnd(_) {
    super.onDragEnd(_);
    onDragStop();
    return false;
  }

  @override
  bool onDragCancel(_) {
    super.onDragCancel(_);
    onDragStop();
    return false;
  }

  void onDragStop() {
    _unscaledDelta.setZero();
  }

  static const double _eighthOfPi = pi / 8;

  JoystickDirection get direction {
    if (delta.isZero()) {
      return JoystickDirection.idle;
    }

    var knobAngle = delta.screenAngle();
    // Since screenAngle and angleTo doesn't care about "direction" of the angle
    // we have to use angleToSigned and create an only increasing angle by
    // removing negative angles from 2*pi.
    knobAngle = knobAngle < 0 ? 2 * pi + knobAngle : knobAngle;
    if (knobAngle >= 0 && knobAngle <= _eighthOfPi) {
      return JoystickDirection.up;
    } else if (knobAngle > 1 * _eighthOfPi && knobAngle <= 3 * _eighthOfPi) {
      return JoystickDirection.upRight;
    } else if (knobAngle > 3 * _eighthOfPi && knobAngle <= 5 * _eighthOfPi) {
      return JoystickDirection.right;
    } else if (knobAngle > 5 * _eighthOfPi && knobAngle <= 7 * _eighthOfPi) {
      return JoystickDirection.downRight;
    } else if (knobAngle > 7 * _eighthOfPi && knobAngle <= 9 * _eighthOfPi) {
      return JoystickDirection.down;
    } else if (knobAngle > 9 * _eighthOfPi && knobAngle <= 11 * _eighthOfPi) {
      return JoystickDirection.downLeft;
    } else if (knobAngle > 11 * _eighthOfPi && knobAngle <= 13 * _eighthOfPi) {
      return JoystickDirection.left;
    } else if (knobAngle > 13 * _eighthOfPi && knobAngle <= 15 * _eighthOfPi) {
      return JoystickDirection.upLeft;
    } else if (knobAngle > 15 * _eighthOfPi) {
      return JoystickDirection.up;
    } else {
      return JoystickDirection.idle;
    }
  }
}
