import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';

mixin DebugState<T> on SpriteAnimationGroupComponent<T> {
  Vector2 get debugStatePosition => Vector2(0, -30);

  @override
  void renderDebugMode(Canvas canvas) {
    super.renderDebugMode(canvas);

    final text = 'state: $current';

    final matrix = Matrix4.identity()..scale(scale.x, scale.y);

    canvas.transform(matrix.storage);

    final textWidth = debugTextPaint.toTextPainter(text).width;

    final position = debugStatePosition..x += textWidth * scale.x / 2;

    debugTextPaint.render(
      canvas,
      text,
      position,
      anchor: Anchor.topCenter,
    );

    canvas.transform(matrix.storage);
  }
}
