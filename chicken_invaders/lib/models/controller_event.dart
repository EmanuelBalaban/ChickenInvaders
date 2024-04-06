// ignore_for_file: comment_references

import 'package:gamepads/gamepads.dart';

part 'controller_button.dart';

/// [ControllerEvent] tries to port [GamepadEvent] to a standard format so that
/// it can be reused across controllers, with mostly the same interface.
///
/// It works by interpreting and mapping the raw [value]s read from the gamepad
/// and translating them into [0.0, 1.0] intervals and known [button]s.
///
/// Known issues:
/// - The left trigger and right trigger have the same value on the default
/// position. This means that if left trigger is pressed, you can get a right
/// trigger event when releasing the left trigger. To work around this, you can
/// ignore events from left/right trigger that are below a threshold (0.1). This
/// causes a small dead zone to the buttons but fixes the issue.
///
/// - Home button events are not implemented. Flame's [gamepads] pub doesn't
/// register the home button being pressed.
///
/// - Sometimes, when releasing left/right sticks, the value is not reported as
/// 0, but very close to 0. This can be fixed by dropping the value precision.
///
/// To do this, create an extension on the double type:
///
/// ```dart
/// extension FractionalPrecision on double {
///   double withPrecision(int digits) {
///     final tenToPower = pow(10, digits);
///
///     return (this * tenToPower).truncateToDouble() / tenToPower;
///   }
/// }
/// ```
///
/// Then use the extension as follows:
///
/// ```dart
/// value.withPrecision(2)
/// ```
class ControllerEvent {
  const ControllerEvent({
    required this.button,
    required this.type,
    required this.key,
    required this.value,
  });

  final ControllerButton button;
  final KeyType type;
  final String key;
  final double value;

  /// Regular buttons are pressed if the [value] is [1.0].
  /// Analog buttons are pressed if the [value] is more or equal to [0.1].
  bool get isPressed =>
      type == KeyType.button ? value == 1.0 : value.abs() >= 0.1;

  @override
  String toString() {
    return '''ControllerEvent(button: $button, type: $type, key: $key, value: $value)''';
  }

  static const _gamepadAnalogMaxVal = 0xFFFF / 2;

  factory ControllerEvent.fromGamepadEvent(GamepadEvent event) {
    var button = ControllerButton.unknown;
    var value = event.value;

    if (event.type == KeyType.analog) {
      value = value / _gamepadAnalogMaxVal - 1.0;
    }

    switch (event.key) {
      case 'dwXpos':
        button = ControllerButton.leftStickX;
        break;
      case 'dwYpos':
        button = ControllerButton.leftStickY;
        break;
      case 'dwUpos':
        button = ControllerButton.rightStickX;
        break;
      case 'dwRpos':
        button = ControllerButton.rightStickY;
        break;
      case 'dwZpos':
        button = value < 0
            ? ControllerButton.rightTrigger
            : ControllerButton.leftTrigger;
        value = value.abs();
        break;
      case 'pov':
        if (event.value == 0xFFFF) {
          button = ControllerButton.dPadNone;
          value = 0;
          break;
        }

        value = 1.0;

        final dPadButton = event.value ~/ 9000;

        switch (dPadButton) {
          case 0:
            button = ControllerButton.dPadUp;
            break;
          case 1:
            button = ControllerButton.dPadRight;
            break;
          case 2:
            button = ControllerButton.dPadDown;
            break;
          case 3:
            button = ControllerButton.dPadLeft;
            break;
          default:
        }
        break;
      case 'button-0':
        button = ControllerButton.a;
        break;
      case 'button-1':
        button = ControllerButton.b;
        break;
      case 'button-2':
        button = ControllerButton.x;
        break;
      case 'button-3':
        button = ControllerButton.y;
        break;
      case 'button-4':
        button = ControllerButton.leftBumper;
        break;
      case 'button-5':
        button = ControllerButton.rightBumper;
        break;
      case 'button-6':
        button = ControllerButton.back;
        break;
      case 'button-7':
        button = ControllerButton.start;
        break;
      case '':
        button = ControllerButton.home;
        break;
      case 'button-8':
        button = ControllerButton.leftTriggerBumper;
        break;
      case 'button-9':
        button = ControllerButton.rightTriggerBumper;
        break;
    }

    return ControllerEvent(
      type: event.type,
      key: event.key,
      button: button,
      value: value,
    );
  }
}
