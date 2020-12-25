part of 'util.dart';

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
