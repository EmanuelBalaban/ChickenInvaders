import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

class JoystickKnob extends SvgComponent {
  JoystickKnob({
    super.priority,
    super.anchor,
    super.position,
  });

  double get radius => scaledSize.x / 2;

  @override
  FutureOr<void> onLoad() async {
    svg = await Svg.load('images/HUD/Knob.svg');

    const spriteSize = 32.0;
    const renderSize = 128.0;

    size = Vector2.all(renderSize);
    scale = Vector2.all(spriteSize / renderSize);

    return super.onLoad();
  }
}
