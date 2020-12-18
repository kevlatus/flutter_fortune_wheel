import 'package:flutter/widgets.dart';
import 'package:quiver/core.dart';

import 'animations.dart';

@immutable
class FortuneItem {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final Widget child;

  const FortuneItem({
    this.color,
    this.borderColor,
    this.borderWidth = 1,
    this.child,
  }) : assert(borderWidth != null);

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
}
