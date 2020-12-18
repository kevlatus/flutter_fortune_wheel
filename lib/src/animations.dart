import 'package:flutter/animation.dart';

enum FortuneAnimation {
  Roll,
  // TODO: Move,
  None,
}

typedef AnimationFunc = Future<void> Function(AnimationController controller);

final AnimationFunc _animateRoll = (AnimationController controller) async {
  await controller.forward(from: 0);
};

final AnimationFunc _animateNone = (AnimationController controller) async {
  controller.value = 0;
};

AnimationFunc getAnimationFunc(FortuneAnimation animation) {
  switch (animation) {
    case FortuneAnimation.Roll:
      return _animateRoll;

    case FortuneAnimation.None:
      return _animateNone;
  }

  throw ArgumentError('Unknown animation type $animation');
}
