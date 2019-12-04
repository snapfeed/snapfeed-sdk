import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snapfeed/src/common/config/config_container.dart';
import 'package:snapfeed/src/common/theme.dart';

class SnapfeedTeaserCardContent extends StatefulWidget {
  const SnapfeedTeaserCardContent({
    Key key,
    @required this.onCancel,
    @required this.onFeedback,
  })  : assert(onCancel != null),
        assert(onFeedback != null),
        super(key: key);

  final VoidCallback onCancel;
  final VoidCallback onFeedback;

  @override
  _SnapfeedTeaserCardContentState createState() =>
      _SnapfeedTeaserCardContentState();
}

class _SnapfeedTeaserCardContentState extends State<SnapfeedTeaserCardContent> {
  @override
  Widget build(BuildContext context) {
    final config = SnapfeedConfigContainer.of(context).config;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              clipBehavior: Clip.antiAlias,
              child: FadeInImage.assetNetwork(
                placeholder: 'packages/snapfeed/assets/images/default.png',
                image: config.teaserPhotoUrl,
                width: 48,
                height: 48,
              ),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 4),
                  Text(
                    config.teaserTitle,
                    style: SnapfeedTheme.cardTitle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    config.teaserMessage,
                    style: SnapfeedTheme.cardContent,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            alignment: WrapAlignment.end,
            children: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: widget.onCancel,
                color: SnapfeedTheme.lightGrey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    config.teaserCancelButton,
                    style: SnapfeedTheme.button
                        .copyWith(color: SnapfeedTheme.darkGrey),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: FlatButton(
                  color: config.accentColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  onPressed: widget.onFeedback,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      config.teaserFeedbackButton,
                      style: SnapfeedTheme.button
                          .copyWith(color: config.accentColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
