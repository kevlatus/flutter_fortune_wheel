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
  late final CurvedAnimation animation;
  final ValueNotifier<int> selectedIndex = ValueNotifier(0);

  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;
  StreamSubscription? _subscription;

  FortuneAnimationManager({
    required TickerProvider vsync,
    required Duration duration,
    required Curve curve,
    required Stream<int> selected,
    this.onAnimationStart,
    this.onAnimationEnd,
  }) : controller = AnimationController(vsync: vsync, duration: duration) {
    animation = CurvedAnimation(parent: controller, curve: curve);
    _subscription = selected.listen((event) {
      selectedIndex.value = event;
      animate();
    });
  }

  void set duration(Duration value) {
    controller.duration = value;
  }

  void set curve(Curve value) {
    animation.curve = value;
  }

  void updateSelected(Stream<int> selected) {
    _subscription?.cancel();
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
    try {
      await controller.forward(from: 0);
    } catch (e) {
      // Controller might be disposed
      return;
    }
    await Future.microtask(() => onAnimationEnd?.call());
  }

  void dispose() {
    _subscription?.cancel();
    controller.dispose();
    selectedIndex.dispose();
  }
}
