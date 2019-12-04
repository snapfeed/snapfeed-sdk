import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:snapfeed/src/feedback/sketcher/sketcher_model.dart';

class FeedbackSketcher extends StatefulWidget {
  const FeedbackSketcher({
    Key key,
    @required this.isEnabled,
    @required this.color,
    @required this.child,
  })  : assert(isEnabled != null),
        assert(color != null),
        assert(child != null),
        super(key: key);

  final bool isEnabled;
  final Color color;
  final Widget child;

  @override
  FeedbackSketcherState createState() => FeedbackSketcherState();
}

class FeedbackSketcherState extends State<FeedbackSketcher> {
  final _sketcherRepaintBoundaryGlobalKey = GlobalKey();
  FeedbackSketcherModel _model = FeedbackSketcherModel(0, 0);
  bool _wasEnabled = false;

  Future<void> _futureCapture;
  Uint8List _screenshotData;
  MemoryImage _screenshotImage;

  FeedbackSketcherModel cloneModel() {
    return _model.copyWith(
      gestures: List<FeedbackSketcherGestureModel>.from(_model.gestures),
    );
  }

  @override
  void didUpdateWidget(FeedbackSketcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_wasEnabled != widget.isEnabled) {
      _clearScreenshot();

      if (!_wasEnabled) {
        _futureCapture = _captureScreenshot();
      }

      _model.clearGestures();
      _wasEnabled = widget.isEnabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.isEnabled
          ? HitTestBehavior.opaque
          : HitTestBehavior.translucent,
      dragStartBehavior: DragStartBehavior.down,
      onTapUp: widget.isEnabled ? _onTapUp : null,
      onPanDown: widget.isEnabled ? _onPanDown : null,
      onPanUpdate: widget.isEnabled ? _onPanUpdate : null,
      onPanEnd: widget.isEnabled ? _onPanEnd : null,
      child: AbsorbPointer(
        absorbing: widget.isEnabled,
        child: ClipRect(
          child: CustomPaint(
            foregroundPainter: _SketchPainter(_model, (size) {
              if (size.width != _model.width || size.height != _model.height) {
                scheduleMicrotask(() {
                  setState(() {
                    _model =
                        _model.copyWith(width: size.width, height: size.height);
                  });
                });
              }
            }),
            isComplex: true,
            willChange: true,
            child: FutureBuilder<void>(
              future: _futureCapture,
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                final isCapturing =
                    snapshot.connectionState == ConnectionState.active;
                final isCaptured =
                    snapshot.connectionState == ConnectionState.done;
                return Stack(
                  children: <Widget>[
                    Offstage(
                      offstage: isCaptured,
                      child: AbsorbPointer(
                        absorbing: isCapturing,
                        child: RepaintBoundary(
                          key: _sketcherRepaintBoundaryGlobalKey,
                          child: widget.child,
                        ),
                      ),
                    ),
                    if (isCaptured) Image(image: _screenshotImage),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onTapUp(TapUpDetails details) {
    _model.addGesture(FeedbackSketcherGestureModel.point(
        widget.color, details.localPosition));
  }

  void _onPanDown(DragDownDetails details) {
    _model.addGesture(FeedbackSketcherGestureModel.startLine(
        widget.color, details.localPosition));
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _model.updateGesture(details.localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _model.endGesture();
  }

  Future<void> _captureScreenshot() async {
    _screenshotData = await _getScreenshot();
    _screenshotImage = MemoryImage(_screenshotData);
    await precacheImage(_screenshotImage, context);
  }

  void _clearScreenshot() {
    _screenshotData = null;
    _screenshotImage = null;
    _futureCapture = null;
  }

  Future<Uint8List> _getScreenshot() async {
    final canvas = _sketcherRepaintBoundaryGlobalKey.currentContext
        .findRenderObject() as RenderRepaintBoundary;
    final image = await canvas.toImage(pixelRatio: 1.5);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> getSketch() async {
    final codec =
        await PaintingBinding.instance.instantiateImageCodec(_screenshotData);
    final image = (await codec.getNextFrame()).image;
    final width = image.width.toDouble();
    final height = image.height.toDouble();
    final size = Size(width, height);
    final recording = ui.PictureRecorder();
    final canvas = Canvas(recording, Rect.fromLTWH(0.0, 0.0, width, height))
      ..drawImage(image, Offset.zero, Paint())
      ..scale(width / _model.width, height / _model.height);
    _SketchPainter(_model).paint(canvas, size);
    final combined =
        await recording.endRecording().toImage(width.toInt(), height.toInt());
    return (await combined.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}

typedef SketchSizeReporter = void Function(Size size);

class _SketchPainter extends CustomPainter {
  _SketchPainter(this.model, [this.reporter])
      : assert(model != null),
        super(repaint: model);

  final FeedbackSketcherModel model;
  final SketchSizeReporter reporter;

  @override
  void paint(Canvas canvas, Size size) {
    reporter?.call(size);
    for (final gesture in model.gestures) {
      canvas.drawPoints(gesture.mode, gesture.points, gesture.paint);
    }
  }

  @override
  bool shouldRepaint(_SketchPainter oldDelegate) => oldDelegate.model != model;
}
