import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chicken_invaders/business_logic/app_layout_cubit.dart';
import 'package:chicken_invaders/models/app_layout.dart';

/// [AdaptiveLayout] is an adaptive builder which uses [Theme] and [MediaQuery]
/// under the hood to create a responsive layout effect. The widget reacts to
/// both [platform] and screen [size] changes.
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    required this.mobile,
    required this.desktop,
    this.tablet,
    this.web,
    super.key,
  });

  /// The builder for a phone device.
  final WidgetBuilder mobile;

  /// The builder for a tablet device.
  ///
  /// When not provided, [mobile] is used by default.
  final WidgetBuilder? tablet;

  /// The builder for a desktop device.
  final WidgetBuilder desktop;

  /// The replacement for desktop if [kIsWeb] is [true].
  ///
  /// When not provided, [desktop] is used instead.
  final WidgetBuilder? web;

  @override
  Widget build(BuildContext context) {
    final layout = context.watch<AppLayoutCubit>().state;

    return switch (layout) {
      AppLayout.mobile => mobile,
      AppLayout.tablet => tablet ?? mobile,
      AppLayout.desktop => desktop,
      AppLayout.web => web ?? desktop,
      AppLayout.unknown => (context) => const SizedBox.shrink(),
    }(context);
  }
}
