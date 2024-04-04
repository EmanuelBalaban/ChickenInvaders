import 'dart:io' as io;

import 'package:flutter/foundation.dart';

enum Platform {
  android,
  iOS,
  macOS,
  linux,
  windows,
  web,
  unknown;

  factory Platform.current() {
    if (kIsWeb) {
      return Platform.web;
    }

    if (io.Platform.isLinux) {
      return Platform.linux;
    }

    if (io.Platform.isMacOS) {
      return Platform.macOS;
    }

    if (io.Platform.isWindows) {
      return Platform.windows;
    }

    if (io.Platform.isAndroid) {
      return Platform.android;
    }

    if (io.Platform.isIOS) {
      return Platform.iOS;
    }

    return Platform.unknown;
  }

  bool get isMobile => this == Platform.android || this == Platform.iOS;

  bool get isDesktop =>
      this == Platform.linux ||
      this == Platform.macOS ||
      this == Platform.windows;

  bool get isWeb => this == Platform.web;
}
