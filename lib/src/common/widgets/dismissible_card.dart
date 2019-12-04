import 'dart:math' as math;

import 'package:flutter/material.dart';

class SnapfeedDismissibleCard extends StatelessWidget {
  const SnapfeedDismissibleCard({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = math.max(
        16.0, mediaQuery.padding.bottom + mediaQuery.viewInsets.bottom);

    return Material(
      elevation: 12,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          top: 24,
          right: 24,
          bottom: bottomPadding,
        ),
        child: child,
      ),
    );
  }
}
