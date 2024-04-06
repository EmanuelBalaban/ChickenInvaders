import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_svg/flame_svg.dart';

import 'package:chicken_invaders/chicken_invaders.dart';

class SwitchWeaponButton extends SvgComponent
    with HasGameRef<ChickenInvaders>, TapCallbacks {
  @override
  FutureOr<void> onLoad() async {
    svg = await Svg.load('images/HUD/SwitchWeaponButton.svg');

    const spriteSize = 36.0;
    const renderSize = 128.0;

    size = Vector2.all(renderSize);
    scale = Vector2.all(spriteSize / renderSize);

    position = Vector2(
      game.size.x - scaledSize.x / 2 - 32 - 64,
      game.size.y - scaledSize.y / 2 - 32 - 64 - 20,
    );

    return super.onLoad();
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);

    game.state.player.switchWeapon();
  }
}
