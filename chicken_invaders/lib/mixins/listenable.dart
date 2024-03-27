import 'package:flutter/services.dart';

mixin Listenable {
  final _listeners = List<VoidCallback>.empty(growable: true);

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }
}
