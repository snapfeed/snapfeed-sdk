import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:snapfeed/src/common/theme.dart';

class SnapfeedConfiguration {
  const SnapfeedConfiguration({
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

  SnapfeedConfiguration.defaultConfig({
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

  SnapfeedConfiguration copyWith({
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
    return SnapfeedConfiguration(
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
