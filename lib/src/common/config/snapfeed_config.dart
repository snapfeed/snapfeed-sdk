import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:snapfeed/src/common/theme.dart';

/// Used to configure Snapfeed. You can overwrite all values by directly
/// invoking it's constructor, or, if you just want to overwrite a few options,
/// use `SnapfeedConfig.defaultConfig(...)`.
///
/// Keep in mind that a few options may be overridden by your current
/// configuration in the Snapfeed admin console (e.g. accent color).
class SnapfeedConfig {
  const SnapfeedConfig({
    @required this.accentColor,
    @required this.teaserPhotoUrl,
    @required this.teaserTitle,
    @required this.teaserMessage,
    @required this.teaserCancelButton,
    @required this.teaserFeedbackButton,
    @required this.feedbackTitle,
    @required this.feedbackMessage,
    @required this.feedbackHint,
    @required this.feedbackSendButton,
  });

  /// Creates a default [SnapfeedConfig] and overrides the specified
  /// values.
  ///
  /// Keep in mind that a few options may be overridden by your current
  /// configuration in the Snapfeed admin console (e.g. accent color).
  SnapfeedConfig.defaultConfig({
    Color primaryColor,
    String teaserPhotoUrl,
    String teaserTitle,
    String teaserMessage,
    String teaserCancelButton,
    String teaserFeedbackButton,
    String feedbackTitle,
    String feedbackMessage,
    String feedbackHint,
    String feedbackSendButton,
  })  : accentColor = primaryColor ?? SnapfeedTheme.purple,
        teaserPhotoUrl = teaserPhotoUrl ??
            'https://api.snapfeed.dev/assets/images/default.png',
        teaserTitle = teaserTitle ?? 'Hey there!',
        teaserMessage = teaserMessage ??
            'We just wanted to check if everything is alright with our app 🙂',
        teaserCancelButton = teaserCancelButton ?? 'Close',
        teaserFeedbackButton = teaserFeedbackButton ?? 'Give Feedback',
        feedbackTitle = feedbackTitle ?? 'We\'re listening',
        feedbackMessage = feedbackMessage ??
            'Write down what’s on your mind. You can also draw on the screen for better context. Thanks for helping us out!',
        feedbackHint = feedbackHint ?? 'Tell us something',
        feedbackSendButton = feedbackSendButton ?? 'Send Feedback';

  SnapfeedConfig copyWith({
    Color accentColor,
    String teaserPhotoUrl,
    String teaserTitle,
    String teaserMessage,
    String teaserCancelButton,
    String teaserFeedbackButton,
    String feedbackTitle,
    String feedbackMessage,
    String feedbackHint,
    String feedbackSendButton,
  }) {
    return SnapfeedConfig(
      accentColor: accentColor ?? this.accentColor,
      teaserPhotoUrl: teaserPhotoUrl ?? this.teaserPhotoUrl,
      teaserTitle: teaserTitle ?? this.teaserTitle,
      teaserMessage: teaserMessage ?? this.teaserMessage,
      teaserCancelButton: teaserCancelButton ?? this.teaserCancelButton,
      teaserFeedbackButton: teaserFeedbackButton ?? this.teaserFeedbackButton,
      feedbackTitle: feedbackTitle ?? this.feedbackTitle,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
      feedbackHint: feedbackHint ?? this.feedbackHint,
      feedbackSendButton: feedbackSendButton ?? this.feedbackSendButton,
    );
  }

  final Color accentColor;
  final String teaserPhotoUrl;
  final String teaserTitle;
  final String teaserMessage;
  final String teaserCancelButton;
  final String teaserFeedbackButton;
  final String feedbackTitle;
  final String feedbackMessage;
  final String feedbackHint;
  final String feedbackSendButton;
}
