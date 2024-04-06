import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

class JoystickBackground extends SvgComponent {
  JoystickBackground({
    super.priority,
    super.anchor,
    super.position,
  });

  @override
  FutureOr<void> onLoad() async {
    svg = await Svg.load('images/HUD/Joystick.svg');

    const spriteSize = 64.0;
    const renderSize = 256.0;

    size = Vector2.all(renderSize);
    scale = Vector2.all(spriteSize / renderSize);

    return super.onLoad();
  }
}
