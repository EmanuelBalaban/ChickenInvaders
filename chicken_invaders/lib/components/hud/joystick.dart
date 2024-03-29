import 'package:flame/components.dart';

import 'package:chicken_invaders/mixins/listenable.dart';

class Joystick extends JoystickComponent with Listenable {
  Joystick({
    super.knob,
    super.background,
    super.position,
    super.margin,
    super.size,
    super.knobRadius,
    super.anchor = Anchor.center,
    super.children,
    super.priority,
    super.key,
  });

  Vector2? _lastRelativeDelta;

  @override
  void update(double dt) {
    super.update(dt);

    if (_lastRelativeDelta != relativeDelta) {
      notifyListeners();
    }

    _lastRelativeDelta = relativeDelta;
  }
}
