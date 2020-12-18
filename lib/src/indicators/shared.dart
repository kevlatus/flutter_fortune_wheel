import 'package:flutter/widgets.dart';

class FortuneWheelIndicator {
  final Alignment alignment;
  final Widget child;

  const FortuneWheelIndicator({
    this.alignment = Alignment.center,
    @required this.child,
  }) : assert(child != null);
}
