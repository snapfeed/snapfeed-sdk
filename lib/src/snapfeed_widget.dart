import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:snapfeed/src/common/config/config_api_response.dart';
import 'package:snapfeed/src/common/config/config_container.dart';
import 'package:snapfeed/src/common/config/snapfeed_config.dart';
import 'package:snapfeed/src/common/network/api_client.dart';
import 'package:snapfeed/src/common/network/data_state.dart';
import 'package:snapfeed/src/common/theme.dart';
import 'package:snapfeed/src/common/ui_state.dart';
import 'package:snapfeed/src/common/widgets/animated_content.dart';
import 'package:snapfeed/src/common/widgets/corner_radius_transition.dart';
import 'package:snapfeed/src/common/widgets/dismissible_card.dart';
import 'package:snapfeed/src/common/widgets/internal_app.dart';
import 'package:snapfeed/src/common/widgets/teaser_card_content.dart';
import 'package:snapfeed/src/feedback/drawer/feedback_drawer.dart';
import 'package:snapfeed/src/feedback/feedback_card_content.dart';
import 'package:snapfeed/src/feedback/feedback_state.dart';
import 'package:snapfeed/src/feedback/feedback_ui_state.dart';
import 'package:snapfeed/src/feedback/sketcher/sketcher.dart';

class Snapfeed extends StatefulWidget {
  const Snapfeed({
    Key key,
    @required this.projectId,
    @required this.secret,
    this.config,
    @required this.child,
  })  : assert(projectId != null),
        assert(secret != null),
        assert(child != null),
        super(key: key);

  final String projectId;
  final String secret;
  final SnapfeedConfig config;
  final Widget child;

  @override
  SnapfeedState createState() => SnapfeedState();

  static SnapfeedState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<SnapfeedState>())
          as SnapfeedState;
}

class SnapfeedState extends State<Snapfeed> with TickerProviderStateMixin {
  final _sketcherKey = GlobalKey<FeedbackSketcherState>();

  SnapfeedApiClient _apiClient;
  SnapfeedConfig _config;
  FeedbackState _feedbackState = FeedbackState();
  SnapfeedUiState _uiState = SnapfeedUiState.hidden;

  AnimationController _animationControllerScreen;
  AnimationController _animationControllerSheet;

  Animation<double> _scaleAnimation;
  Animation<double> _cornerRadiusAnimation;
  Animation<Offset> _contentSlideAnimation;
  Animation<Offset> _sheetSlideAnimation;

  Animation<Offset> _slideDrawPanelIn;
  Animation<Offset> _slideDrawPanelInOverlay;

  ConfigApiResponse _response;

  @override
  void initState() {
    super.initState();

    final window = WidgetsBinding.instance.window;
    final screenSize = window.physicalSize / window.devicePixelRatio;
    final drawPanelSlideFraction =
        (FeedbackDrawer.width / screenSize.width) / 2;

    _animationControllerScreen =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationControllerSheet = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));

    _sheetSlideAnimation =
        Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.fastOutSlowIn))
            .animate(_animationControllerSheet);

    _scaleAnimation = Tween(begin: 1.0, end: 0.70)
        .chain(CurveTween(
            curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn)))
        .animate(_animationControllerScreen);

    _cornerRadiusAnimation = Tween(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: const Interval(0.1, 0.3, curve: Curves.ease)))
        .animate(_animationControllerScreen);

    _contentSlideAnimation =
        Tween(begin: Offset.zero, end: const Offset(0.0, -0.15))
            .chain(CurveTween(
                curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn)))
            .animate(_animationControllerScreen);

    _slideDrawPanelIn =
        Tween(begin: Offset.zero, end: Offset(drawPanelSlideFraction, 0.0))
            .chain(CurveTween(
                curve: const Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)))
            .animate(_animationControllerScreen);

    _slideDrawPanelInOverlay =
        Tween(begin: Offset.zero, end: Offset(-drawPanelSlideFraction, 0.0))
            .chain(CurveTween(
                curve: const Interval(0.6, 1.0, curve: Curves.fastOutSlowIn)))
            .animate(_animationControllerScreen);

    _apiClient = SnapfeedApiClient(
        httpClient: http.Client(),
        projectId: widget.projectId,
        secret: widget.secret);
    _config = widget.config ?? SnapfeedConfig.defaultConfig();
  }

  @override
  void didUpdateWidget(Snapfeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    _config = widget.config ?? SnapfeedConfig.defaultConfig();
  }

  @override
  Widget build(BuildContext context) {
    // Merge local and server-side config
    final mergedConfig = _response != null
        ? _config.copyWith(
            accentColor: Color(_response.accentColor),
            teaserPhotoUrl: _response.photoURL,
          )
        : _config;

    return SnapfeedInternalApp(
      child: WillPopScope(
        onWillPop: () async {
          switch (_uiState) {
            case SnapfeedUiState.feedback:
              setState(() {
                _uiState = SnapfeedUiState.hidden;
                _animationControllerScreen.reverse();
              });
              return false;
            case SnapfeedUiState.intro:
              setState(() {
                _uiState = SnapfeedUiState.hidden;
                _animationControllerSheet.reverse();
              });
              return false;
            default:
              return true;
          }
        },
        child: SnapfeedConfigContainer(
          config: mergedConfig,
          feedbackState: _feedbackState,
          child: _buildSnapfeedContent(),
        ),
      ),
    );
  }

  Widget _buildSnapfeedContent() {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.grey,
        ),
        ScaleTransition(
          scale: const AlwaysStoppedAnimation(0.70),
          child: SlideTransition(
            position: const AlwaysStoppedAnimation(Offset(0, -0.15)),
            child: SlideTransition(
              position: _slideDrawPanelIn,
              child: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(16),
                color: SnapfeedTheme.lightGrey,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: FeedbackDrawer(),
                ),
              ),
            ),
          ),
        ),
        ScaleTransition(
          scale: _scaleAnimation,
          child: SlideTransition(
            position: _contentSlideAnimation,
            child: SlideTransition(
              position: _slideDrawPanelInOverlay,
              child: CornerRadiusTransition(
                radius: _cornerRadiusAnimation,
                child: FeedbackSketcher(
                  key: _sketcherKey,
                  isEnabled: _uiState == SnapfeedUiState.feedback &&
                      _feedbackState.uiState == FeedbackUiState.draw,
                  color: _feedbackState.penColor,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
        SlideTransition(
          position: _sheetSlideAnimation,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SnapfeedDismissibleCard(
              child: AnimatedContent(
                vsync: this,
                child: _buildCardContent(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent() {
    switch (_uiState) {
      case SnapfeedUiState.hidden:
        return const SizedBox.shrink();
      case SnapfeedUiState.loading:
        return const SizedBox(
          height: 80,
          child: Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.grey)),
          ),
        );
      case SnapfeedUiState.intro:
        return SnapfeedTeaserCardContent(
          onCancel: _close,
          onFeedback: () {
            setState(() {
              _uiState = SnapfeedUiState.feedback;
              _feedbackState =
                  _feedbackState.copyWith(uiState: FeedbackUiState.draw);
              _animationControllerScreen.forward();
            });
          },
        );
      case SnapfeedUiState.feedback:
        return FeedbackCardContent(
          onCancel: _close,
          onSend: _sendFeedback,
        );
    }

    return const SizedBox.shrink();
  }

  void startFeedback() {
    setState(() {
      if (_uiState == SnapfeedUiState.hidden) {
        _uiState = SnapfeedUiState.loading;
        _getConfiguration();
        _animationControllerSheet.forward();
      } else {
        _close();
      }
    });
  }

  void setFeedbackState(FeedbackState feedbackState) {
    setState(() {
      _feedbackState = feedbackState;
    });
  }

  Future<void> _getConfiguration() async {
    await _apiClient.getConfig(
      onDataStateChanged: (DataState<ConfigApiResponse> dataState) async {
        if (dataState.isIdleOrLoading) {
          _uiState = SnapfeedUiState.loading;
        }
        if (dataState.isError) {
          _close();
        }
        if (dataState.isSuccess) {
          setState(() {
            _response = dataState.success.response;
            _uiState = SnapfeedUiState.intro;
          });
        }
      },
    );
  }

  Future<void> _sendFeedback(String message) async {
    final screenshot = await _sketcherKey.currentState.getSketch();
    _close();

    await _apiClient.sendFeedback(
      message: message,
      screenshot: screenshot,
      onDataStateChanged: (DataState<Map<String, dynamic>> dataState) {},
    );
  }

  void _close() {
    setState(() {
      _feedbackState = FeedbackState();
      _uiState = SnapfeedUiState.hidden;
      _animationControllerSheet.reverse();
      _animationControllerScreen.reverse();
    });
  }
}
