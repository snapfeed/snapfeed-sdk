import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FeedbackSketcherModel extends ChangeNotifier {
  factory FeedbackSketcherModel(double width, double height) =>
      FeedbackSketcherModel._([], width, height);

  FeedbackSketcherModel._(this._gestures, this.width, this.height);

  final List<FeedbackSketcherGestureModel> _gestures;
  double width;
  double height;

  List<FeedbackSketcherGestureModel> get gestures =>
      List.unmodifiable(_gestures);

  FeedbackSketcherGestureModel _last;

  FeedbackSketcherModel copyWith({
    List<FeedbackSketcherGestureModel> gestures,
    double width,
    double height,
  }) {
    return FeedbackSketcherModel._(
      gestures ?? _gestures,
      width ?? this.width,
      height ?? this.height,
    );
  }

  void addGesture(FeedbackSketcherGestureModel gesture) {
    _gestures.add(gesture);
    _last = gesture;
    notifyListeners();
  }

  void updateGesture(Offset offset) {
    _last..add(offset)..add(offset);
    notifyListeners();
  }

  void endGesture() {
    _last.add(_last.points[_last.points.length - 1]);
    notifyListeners();
  }

  void clearGestures() {
    _gestures.clear();
    notifyListeners();
  }
}

class FeedbackSketcherGestureModel {
  FeedbackSketcherGestureModel(this.mode, this.paint)
      : assert(mode != null && paint != null);

  factory FeedbackSketcherGestureModel.point(Color color, Offset point) {
    return FeedbackSketcherGestureModel(
      ui.PointMode.points,
      ui.Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 8.0
        ..color = color,
    )..add(point);
  }

  factory FeedbackSketcherGestureModel.startLine(Color color, Offset start) {
    return FeedbackSketcherGestureModel(
      ui.PointMode.lines,
      ui.Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4.0
        ..color = color,
    )..add(start);
  }

  final ui.PointMode mode;
  final Paint paint;
  final List<Offset> points = [];

  void add(Offset offset) {
    points.add(offset);
  }
}
