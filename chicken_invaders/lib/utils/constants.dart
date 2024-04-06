part 'sound_constants.dart';

part 'ship_constants.dart';

class Constants {
  const Constants._();

  static const breakpoints = _AdaptiveBreakpoints._();

  static const sound = _Sound._();

  static const ship = _Ship._();
}

/// https://iiro.dev/implementing-adaptive-master-detail-layouts/
class _AdaptiveBreakpoints {
  const _AdaptiveBreakpoints._();

  double get mobile => 600;

  double get tablet => 900;
}
