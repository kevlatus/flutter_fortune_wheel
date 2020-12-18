import 'package:flutter/widgets.dart';

import 'animations.dart';

abstract class FortuneWidget implements Widget {
  int get selected;

  int get rotationCount;

  Duration get duration;

  FortuneAnimation get animationType;

  VoidCallback get onAnimationStart;

  VoidCallback get onAnimationEnd;
}
