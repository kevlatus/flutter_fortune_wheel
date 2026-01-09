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

/// Manages the animation state for a [FortuneWidget].
class FortuneAnimationManager {
  final AnimationController controller;
  late final Animation<double> animation;
  final ValueNotifier<int> selectedIndex = ValueNotifier(0);

  final Stream<int> selected;
  final bool animateFirst;
  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;
  StreamSubscription? _subscription;

  FortuneAnimationManager({
    required TickerProvider vsync,
    required Duration duration,
    required Curve curve,
    required this.selected,
    required this.animateFirst,
    this.onAnimationStart,
    this.onAnimationEnd,
  }) : controller = AnimationController(vsync: vsync, duration: duration) {
    animation = CurvedAnimation(parent: controller, curve: curve);
    if (animateFirst) animate();
    _subscription = selected.listen((event) {
      selectedIndex.value = event;
      animate();
    });
  }

  Future<void> animate() async {
    if (controller.isAnimating) {
      return;
    }

    await Future.microtask(() => onAnimationStart?.call());
    await controller.forward(from: 0);
    await Future.microtask(() => onAnimationEnd?.call());
  }

  void dispose() {
    _subscription?.cancel();
    controller.dispose();
    selectedIndex.dispose();
  }
}
