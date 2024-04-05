class Constants {
  const Constants._();

  static const breakpoints = _AdaptiveBreakpoints._();

  static const sound = _Sound._();
}

/// https://iiro.dev/implementing-adaptive-master-detail-layouts/
class _AdaptiveBreakpoints {
  const _AdaptiveBreakpoints._();

  double get mobile => 600;

  double get tablet => 900;
}

class _Sound {
  const _Sound._();

  double get baseVolume => 1.0;

  double get gameStartVolume => baseVolume * 0.5;

  double get gameOverVolume => baseVolume * 0.5;

  double get shipHitVolume => baseVolume * 0.5;

  double get fireProjectileVolume => baseVolume;

  double get fireCannonVolume => baseVolume;

  double get birdHitVolume => baseVolume * 0.6;

  double get eggSpawnVolume => baseVolume * 0.2;

  double get eggDestroyVolume => baseVolume * 0.3;
}
