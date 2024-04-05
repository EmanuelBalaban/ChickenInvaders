class Assets {
  const Assets._();

  static const audio = _Audio._();
}

class _Audio {
  const _Audio._();

  String get gameStart => 'fanfar1.wav';

  String get gameOver => 'bonewah.wav';

  String get shipHit => 'fx113.wav';

  String get fireProjectile => 'tr3_239.wav';

  String get fireCannon => 'cannonfire.wav';

  String get birdHit => 'rdfx31.wav';

  String get eggSpawn => 'fx110.wav';

  String get eggDestroy => 'fx11.wav';
}
