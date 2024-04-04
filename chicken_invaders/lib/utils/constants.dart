class Constants {
  const Constants._();

  static const breakpoints = _AdaptiveBreakpoints._();
}

/// https://iiro.dev/implementing-adaptive-master-detail-layouts/
class _AdaptiveBreakpoints {
  const _AdaptiveBreakpoints._();

  double get mobile => 600;

  double get tablet => 900;
}
