import 'package:flutter/material.dart';

class SnapfeedInternalApp extends StatefulWidget {
  const SnapfeedInternalApp({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  _SnapfeedInternalAppState createState() => _SnapfeedInternalAppState();
}

class _SnapfeedInternalAppState extends State<SnapfeedInternalApp>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    setState(() {
      // Update when MediaQuery properties change
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
