import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chicken_invaders/business_logic/app_layout_cubit.dart';

/// Automatically updates the app layout based on the screen size. It is meant
/// to be used as the highest widget of the application and it should be added
/// to the widgets tree just once.
class AppLayoutWatcher extends StatelessWidget {
  const AppLayoutWatcher({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    context.read<AppLayoutCubit>().update(screenSize: screenSize);

    return child;
  }
}
