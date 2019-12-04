import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CornerRadiusTransition extends AnimatedWidget {
  const CornerRadiusTransition({Key key, @required this.radius, this.child})
      : assert(radius != null),
        super(key: key, listenable: radius);

  final Animation<double> radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.lerp(
          BorderRadius.circular(0), BorderRadius.circular(16), radius.value),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
