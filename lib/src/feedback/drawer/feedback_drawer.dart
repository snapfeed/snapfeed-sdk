import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snapfeed/src/common/config/config_container.dart';
import 'package:snapfeed/src/common/theme.dart';
import 'package:snapfeed/src/feedback/drawer/color_picker.dart';
import 'package:snapfeed/src/feedback/drawer/feedback_pen.dart';
import 'package:snapfeed/src/feedback/feedback_state.dart';
import 'package:snapfeed/src/feedback/feedback_ui_state.dart';

typedef FeedbackStateChangeCallback = void Function(FeedbackState newState);

class FeedbackDrawer extends StatefulWidget {
  static const width = 80.0;

  const FeedbackDrawer({Key key, this.onStateChanged})
      : assert(onStateChanged != null),
        super(key: key);

  final FeedbackStateChangeCallback onStateChanged;

  @override
  _FeedbackDrawerState createState() => _FeedbackDrawerState();
}

class _FeedbackDrawerState extends State<FeedbackDrawer> {
  @override
  Widget build(BuildContext context) {
    final feedbackState = SnapfeedConfigContainer.of(context).feedbackState;
    return SizedBox(
      width: FeedbackDrawer.width,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 24),
          Image.asset(
            'assets/images/logo_draw.png',
            width: 40,
            package: 'snapfeed',
          ),
          const Spacer(),
          RotatedBox(
            quarterTurns: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildModeButton(FeedbackUiState.navigate),
                const SizedBox(width: 24),
                _buildModeButton(FeedbackUiState.draw),
              ],
            ),
          ),
          const Spacer(),
          ColorPicker(
            selectedColor: feedbackState.penColor,
            onColorSelected: (color) {
              widget.onStateChanged(
                feedbackState.copyWith(
                  uiState: FeedbackUiState.draw,
                  penColor: color,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          FeedbackPen(color: feedbackState.penColor),
        ],
      ),
    );
  }

  Widget _buildModeButton(FeedbackUiState state) {
    final settingsContainer = SnapfeedConfigContainer.of(context);
    final isNavigate = state == FeedbackUiState.navigate;
    final isSelected = settingsContainer.feedbackState.uiState == state;
    final title = isNavigate ? 'Navigate' : 'Draw';

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (!isSelected) {
          widget.onStateChanged(
            settingsContainer.feedbackState.copyWith(
                uiState: isNavigate
                    ? FeedbackUiState.navigate
                    : FeedbackUiState.draw),
          );
        }
      },
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: SnapfeedTheme.drawerTitle,
            ),
            const SizedBox(height: 8),
            Container(
              width: 48,
              height: 2,
              color: isSelected
                  ? settingsContainer.config.accentColor
                  : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
