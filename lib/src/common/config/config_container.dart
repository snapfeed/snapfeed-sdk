import 'package:flutter/widgets.dart';
import 'package:snapfeed/src/common/config/config_model.dart';
import 'package:snapfeed/src/feedback/feedback_state.dart';

class SnapfeedConfigContainer extends InheritedWidget {
  const SnapfeedConfigContainer({
    Key key,
    @required this.config,
    @required this.feedbackState,
    Widget child,
  })  : assert(config != null),
        super(key: key, child: child);

  final SnapfeedConfiguration config;
  final SnapfeedFeedbackState feedbackState;

  @override
  bool updateShouldNotify(SnapfeedConfigContainer oldWidget) =>
      oldWidget.config != config || oldWidget.feedbackState != feedbackState;

  static SnapfeedConfigContainer of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(SnapfeedConfigContainer)
          as SnapfeedConfigContainer;
}
