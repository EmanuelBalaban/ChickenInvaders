import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';

import 'package:chicken_invaders/chicken_invaders.dart';

class FireButton extends SvgComponent
    with HasGameRef<ChickenInvaders>, TapCallbacks {
  @override
  FutureOr<void> onLoad() async {
    svg = await Svg.load('images/HUD/FireButton.svg');

    const spriteSize = 64.0;
    const renderSize = 256.0;

    size = Vector2.all(renderSize);
    scale = Vector2.all(spriteSize / renderSize);

    position = Vector2(
      game.size.x - scaledSize.x - 32,
      game.size.y - scaledSize.y - 32,
    );

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    game.state.player.firePressed.value = true;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);

    game.state.player.firePressed.value = false;
  }
}
