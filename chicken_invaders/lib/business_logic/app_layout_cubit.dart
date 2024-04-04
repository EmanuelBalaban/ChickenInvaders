import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chicken_invaders/models/app_layout.dart';

class AppLayoutCubit extends Cubit<AppLayout> {
  AppLayoutCubit() : super(AppLayout.current()) {
    _updateOrientation();
  }

  void update({Size? screenSize}) {
    final layout = AppLayout.current(screenSize: screenSize);

    if (state == layout) {
      return;
    }

    emit(layout);

    _updateOrientation();
  }

  /// Updates the screen orientation lock based on the current app layout:
  ///
  /// * For the mobile layout, the orientation is locked to [portrait] mode.
  /// * For the tablet layout, the orientation is not locked.
  /// * For the desktop layout, the orientation is locked to [landscape] mode.
  /// * For the web layout, the orientation is not locked as it can render all
  /// the other layouts depending on the screen size.
  void _updateOrientation() {
    switch (state) {
      case AppLayout.mobile:
        SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
        );

      case AppLayout.desktop:
        SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
        );

      case AppLayout.tablet:
      case AppLayout.web:
      case AppLayout.unknown:
        SystemChrome.setPreferredOrientations([]);
    }
  }
}
