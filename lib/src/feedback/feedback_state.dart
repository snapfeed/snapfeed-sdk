import 'dart:ui';

import 'package:snapfeed/src/common/theme.dart';
import 'package:snapfeed/src/feedback/feedback_ui_state.dart';

class FeedbackState {
  FeedbackState({
    FeedbackUiState uiState,
    Color penColor,
  })  : uiState = uiState ?? FeedbackUiState.navigate,
        penColor = penColor ?? SnapfeedTheme.penColors[0];

  FeedbackState copyWith({
    FeedbackUiState uiState,
    Color penColor,
  }) {
    return FeedbackState(
      uiState: uiState ?? this.uiState,
      penColor: penColor ?? this.penColor,
    );
  }

  final FeedbackUiState uiState;
  final Color penColor;
}
