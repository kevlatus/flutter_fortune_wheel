import 'package:flutter/animation.dart';

import 'fortune_widget.dart' show FortuneWidget;

/// The type of animation, which is used when the value of
/// [FortuneWidget.selected] changes.
enum FortuneAnimation {
  /// Animate to the [FortuneWidget.selected] item using a spinning animation.
  Spin,
  // TODO: Move,
  /// Directly show the [FortuneWidget.selected] item without animating.
  None,
}

typedef AnimationFunc = Future<void> Function(AnimationController controller);

final AnimationFunc _animateSpin = (AnimationController controller) async {
  await controller.forward(from: 0);
};

final AnimationFunc _animateNone = (AnimationController controller) async {
  controller.value = 0;
};

AnimationFunc getAnimationFunc(FortuneAnimation animation) {
  switch (animation) {
    case FortuneAnimation.Spin:
      return _animateSpin;

    case FortuneAnimation.None:
      return _animateNone;
  }

  throw ArgumentError('Unknown animation type $animation');
}
