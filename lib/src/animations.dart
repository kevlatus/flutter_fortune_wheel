import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

enum FortuneAnimation {
  Roll,
  // TODO: Move,
  None,
}

typedef AnimationFunc = Future<void> Function({
  @required AnimationController controller,
  @required Duration duration,
  @required double targetProgress,
});

final AnimationFunc _animateRoll = ({
  @required AnimationController controller,
  @required Duration duration,
  @required double targetProgress,
}) async {
  double ensureAnimationValue = targetProgress - 0.1;
  if (ensureAnimationValue < 0) {
    ensureAnimationValue += 0.2;
  }
  controller.value = ensureAnimationValue;

  await controller.animateTo(
    targetProgress,
    duration: duration,
    curve: Cubic(0, 1.0, 0, 1.0),
  );
};

final AnimationFunc _animateNone = ({
  @required AnimationController controller,
  @required Duration duration,
  @required double targetProgress,
}) async {
  controller.value = targetProgress;
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
