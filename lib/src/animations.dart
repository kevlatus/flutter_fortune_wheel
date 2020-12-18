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
});

final AnimationFunc _animateRoll = ({
  @required AnimationController controller,
  @required Duration duration,
}) async {
  controller.value = 0;

  await controller.animateTo(
    1,
    duration: duration,
    curve: Cubic(0, 1.0, 0, 1.0),
  );
};

final AnimationFunc _animateNone = ({
  @required AnimationController controller,
  @required Duration duration,
}) async {
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
