import 'package:snapfeed/snapfeed.dart';
import 'package:snapfeed/src/snapfeed_widget.dart';

/// This class represents the public API of Snapfeed. You'll use this class
/// to interact with Snapfeeds functionality.
class SnapfeedController {
  SnapfeedController(this._state) : assert(_state != null);

  final SnapfeedState _state;

  /// This will trigger the Snapfeed feedback process. Snapfeed will fetch
  /// the configuration for the project (e.g. project icon, accent color, etc.)
  /// and then show a bottom sheet asking the user for feedback.
  ///
  /// Currently you can customize the feedback process in multiple ways.
  /// 1. Online through the Snapfeed admin console (e.g. project icon and
  ///  accent color.
  /// 2. By providing your own [SnapfeedConfig] to the [Snapfeed] widget.
  void startFeedback() => _state.startFeedback();
}
