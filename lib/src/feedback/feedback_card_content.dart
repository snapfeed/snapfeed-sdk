import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snapfeed/src/common/config/config_container.dart';
import 'package:snapfeed/src/common/theme.dart';

class FeedbackCardContent extends StatefulWidget {
  const FeedbackCardContent({
    Key key,
    @required this.onCancel,
    @required this.onSend,
  })  : assert(onCancel != null),
        assert(onSend != null),
        super(key: key);

  final VoidCallback onCancel;
  final ValueSetter<String> onSend;

  @override
  _FeedbackCardContentState createState() => _FeedbackCardContentState();
}

class _FeedbackCardContentState extends State<FeedbackCardContent> {
  TextEditingController _textEditingController;
  var _showSendButton = false;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final settings = SnapfeedConfigContainer.of(context).config;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 4),
        GestureDetector(
          onTap: widget.onCancel,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.keyboard_backspace,
                color: Colors.black26,
              ),
              const SizedBox(width: 8),
              Text(
                settings.feedbackTitle,
                style: SnapfeedTheme.cardTitle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          settings.feedbackMessage,
          style: SnapfeedTheme.cardContent,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _textEditingController,
          style: SnapfeedTheme.cardFeedback,
          enableInteractiveSelection: false,
          cursorColor: settings.accentColor,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            fillColor: SnapfeedTheme.lightGrey,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            hintText: settings.feedbackHint,
          ),
          minLines: 1,
          maxLines: 3,
          onChanged: (text) {
            setState(() {
              _showSendButton = text.length >= 7;
            });
          },
        ),
        const SizedBox(height: 12),
        if (_showSendButton) ...[
          ButtonBar(
            children: <Widget>[
              FlatButton(
                color: settings.accentColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {
                  widget.onSend(_textEditingController.text);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    settings.feedbackSendButton,
                    style: SnapfeedTheme.button
                        .copyWith(color: settings.accentColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
