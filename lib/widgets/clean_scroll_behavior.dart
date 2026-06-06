import 'package:flutter/material.dart';

class CleanScrollBehavior extends MaterialScrollBehavior {
  const CleanScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
