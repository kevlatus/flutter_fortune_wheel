import 'package:flutter/widgets.dart';
import 'package:quiver/core.dart';

import 'animations.dart';
import 'indicators/indicators.dart';
import 'band/band.dart';
import 'wheel/wheel.dart';

@immutable
class FortuneItem {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final Widget child;

  const FortuneItem({
    this.color,
    this.borderColor,
    this.borderWidth,
    @required this.child,
  }) : assert(child != null);

  @override
  int get hashCode => hash4(color, borderColor, borderWidth, child);

  @override
  bool operator ==(Object other) {
    return other is FortuneItem &&
        color == other.color &&
        borderColor == other.borderColor &&
        borderWidth == other.borderWidth &&
        child == other.child;
  }
}

abstract class FortuneWidget implements Widget {
  static const Duration kAnimationDuration = const Duration(seconds: 5);
  static const int kRotationCount = 100;

  List<FortuneItem> get items;

  int get selected;

  int get rotationCount;

  Duration get duration;

  FortuneAnimation get animationType;

  VoidCallback get onAnimationStart;

  VoidCallback get onAnimationEnd;

  const factory FortuneWidget.wheel({
    Key key,
    @required int selected,
    @required List<FortuneItem> items,
    int rotationCount,
    Duration duration,
    FortuneAnimation animationType,
    List<FortuneWheelIndicator> indicators,
    VoidCallback onAnimationStart,
    VoidCallback onAnimationEnd,
  }) = FortuneWheel;

  const factory FortuneWidget.band({
    Key key,
    @required List<FortuneItem> items,
    @required int selected,
    int rotationCount,
    Duration duration,
    FortuneAnimation animationType,
    List<FortuneWheelIndicator> indicators,
    VoidCallback onAnimationStart,
    VoidCallback onAnimationEnd,
    double height,
  }) = FortuneBand;

  factory FortuneWidget({
    Key key,
    @required List<FortuneItem> items,
    @required int selected,
    int rotationCount,
    Duration duration,
    FortuneAnimation animationType,
    List<FortuneWheelIndicator> indicators,
    VoidCallback onAnimationStart,
    VoidCallback onAnimationEnd,
  }) {
    if (items.length % 2 == 0) {
      return FortuneWidget.wheel(
        key: key,
        items: items,
        selected: selected,
        rotationCount: rotationCount,
        duration: duration,
        animationType: animationType,
        indicators: indicators,
        onAnimationStart: onAnimationStart,
        onAnimationEnd: onAnimationEnd,
      );
    } else {
      return FortuneWidget.band(
        key: key,
        items: items,
        selected: selected,
        rotationCount: rotationCount,
        duration: duration,
        animationType: animationType,
        indicators: indicators,
        onAnimationStart: onAnimationStart,
        onAnimationEnd: onAnimationEnd,
      );
    }
  }
}
