import 'package:flutter/material.dart';

import 'package:chicken_invaders/models/platform.dart';
import 'package:chicken_invaders/utils/constants.dart';

enum AppLayout {
  unknown,
  mobile,
  tablet,
  desktop,
  web;

  factory AppLayout.current({Size? screenSize}) {
    final platform = Platform.current();

    final shortestSide = screenSize?.shortestSide ??
        WidgetsBinding.instance.platformDispatcher.implicitView?.physicalSize
            .shortestSide ??
        0.0;

    switch (platform) {
      case Platform.web:
        if (shortestSide < Constants.breakpoints.mobile) {
          return AppLayout.mobile;
        }

        if (shortestSide < Constants.breakpoints.tablet) {
          return AppLayout.tablet;
        }

        return AppLayout.web;

      case Platform.iOS:
      case Platform.android:
        return shortestSide < Constants.breakpoints.mobile
            ? AppLayout.mobile
            : AppLayout.tablet;

      case Platform.macOS:
      case Platform.linux:
      case Platform.windows:
        return AppLayout.desktop;

      default:
        return AppLayout.unknown;
    }
  }
}
