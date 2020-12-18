import 'package:flutter/widgets.dart';
import 'package:quiver/core.dart';

import 'animations.dart';

@immutable
class FortuneItem {
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  final Widget child;

  const FortuneItem({
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1,
    this.child,
  }) : assert(strokeWidth != null);

  @override
  int get hashCode => hash4(fillColor, strokeColor, strokeWidth, child);

  @override
  bool operator ==(Object other) {
    return other is FortuneItem &&
        fillColor == other.fillColor &&
        strokeColor == other.strokeColor &&
        strokeWidth == other.strokeWidth &&
        child == other.child;
  }
}

abstract class FortuneWidget implements Widget {
  List<FortuneItem> get items;

  int get selected;

  int get rotationCount;

  Duration get duration;

  FortuneAnimation get animationType;

  VoidCallback get onAnimationStart;

  VoidCallback get onAnimationEnd;
}
