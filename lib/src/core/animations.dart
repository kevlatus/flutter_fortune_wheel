part of 'core.dart';

/// A selection of commonly used curves for animating when the value of
/// [FortuneWidget.selected] changes.
class FortuneCurve {
  const FortuneCurve._();

  /// The default curve used when spinning a [FortuneWidget].
  static const Curve spin = Cubic(0, 1.0, 0, 1.0);

  /// A curve used for disabling spin animations.
  static const Curve none = Threshold(0.0);
}

/// Result of [useFortuneAnimation].
class FortuneAnimation {
  final AnimationController controller;
  final Animation<double> animation;
  final ValueNotifier<int> selectedIndex;

  const FortuneAnimation({
    required this.controller,
    required this.animation,
    required this.selectedIndex,
  });
}

/// A hook for handling fortune animations.
FortuneAnimation useFortuneAnimation({
  required Duration duration,
  required Curve curve,
  required Stream<int> selected,
  required bool animateFirst,
  VoidCallback? onAnimationStart,
  VoidCallback? onAnimationEnd,
}) {
  final controller = useAnimationController(duration: duration);
  final animation = CurvedAnimation(parent: controller, curve: curve);
  final selectedIndex = useState<int>(0);

  Future<void> animate() async {
    if (controller.isAnimating) {
      return;
    }

    await Future.microtask(() => onAnimationStart?.call());
    await controller.forward(from: 0);
    await Future.microtask(() => onAnimationEnd?.call());
  }

  useEffect(() {
    if (animateFirst) animate();
    return null;
  }, []);

  useEffect(() {
    final subscription = selected.listen((event) {
      selectedIndex.value = event;
      animate();
    });
    return subscription.cancel;
  }, []);

  return FortuneAnimation(
    controller: controller,
    animation: animation,
    selectedIndex: selectedIndex,
  );
}
