// ignore_for_file: avoid-returning-widgets

import 'package:flutter/material.dart';

import 'package:chicken_invaders/widgets/adaptive_layout/adaptive_layout.dart';

abstract class AdaptiveWidget extends StatelessWidget {
  const AdaptiveWidget({super.key});

  /// The builder for a phone device.
  Widget mobile(BuildContext context);

  /// The builder for a tablet device.
  ///
  /// When not provided, [mobile] is used by default.
  Widget tablet(BuildContext context) => mobile(context);

  /// The builder for a desktop device.
  Widget desktop(BuildContext context);

  /// The replacement for desktop if [kIsWeb] is [true].
  ///
  /// When not provided, [desktop] is used instead.
  Widget web(BuildContext context) => desktop(context);

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      web: web,
    );
  }
}
