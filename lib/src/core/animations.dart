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

typedef double FortuneAnimationFunc(
  int index,
  double progress,
  int itemCount,
  int rotationCount,
);

/// Manages the animation state for a [FortuneWidget].
class FortuneAnimationManager {
  final AnimationController controller;
  late final CurvedAnimation animation;
  final ValueNotifier<int> selectedIndex = ValueNotifier(0);
  final ValueNotifier<double> valueOffset = ValueNotifier(0);
  final FortuneAnimationFunc getPosition;

  int rotationCount = 1;
  int itemCount = 1;

  final VoidCallback? onAnimationStart;
  final VoidCallback? onAnimationEnd;
  StreamSubscription? _subscription;

  FortuneAnimationManager({
    required TickerProvider vsync,
    required Duration duration,
    required Curve curve,
    required Stream<int> selected,
    required this.getPosition,
    this.rotationCount = 1,
    this.itemCount = 1,
    this.onAnimationStart,
    this.onAnimationEnd,
  }) : controller = AnimationController(vsync: vsync, duration: duration) {
    animation = CurvedAnimation(parent: controller, curve: curve);
    _subscription = selected.listen(_handleSelection);
  }

  void set duration(Duration value) {
    controller.duration = value;
  }

  void set curve(Curve value) {
    animation.curve = value;
  }

  void updateSelected(Stream<int> selected) {
    _subscription?.cancel();
    _subscription = selected.listen(_handleSelection);
  }

  void _handleSelection(int event) {
    if (controller.isAnimating && selectedIndex.value == Fortune.indefinite) {
      if (event == Fortune.indefinite) {
        return;
      }
    }

    final oldIndex = selectedIndex.value;
    final newIndex = event;
    final oldAngle = getPosition(oldIndex, controller.value, itemCount, rotationCount);
    final newAngle = getPosition(newIndex, 0, itemCount, rotationCount);
    final diff = oldAngle - newAngle;

    valueOffset.value += diff;
    selectedIndex.value = event;

    if (event == Fortune.indefinite) {
      controller.repeat();
    } else {
      animate();
    }
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
    valueOffset.dispose();
  }
}
