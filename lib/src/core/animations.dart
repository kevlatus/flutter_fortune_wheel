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

  // Ticker-based indefinite progress (in cycles). We expose a `progress`
  // ValueNotifier that emits the current animation progress used by the
  // widgets. For definitive animations this is in [0,1]. For indefinite
  // animations this grows continuously (e.g. 3.2 = 3 cycles + 20%).
  final ValueNotifier<double> progress = ValueNotifier<double>(0.0);

  Ticker? _indefiniteTicker;
  Duration _lastTick = Duration.zero;
  double _indefiniteCycles = 0.0;

  FortuneAnimationManager({
    required TickerProvider vsync,
    required Duration duration,
    required Curve curve,
    required Stream<int> selected,
    this.onAnimationStart,
    this.onAnimationEnd,
  }) : controller = AnimationController(vsync: vsync, duration: duration) {
    animation = CurvedAnimation(parent: controller, curve: curve);

    // Keep progress in sync for definitive animations.
    animation.addListener(() {
      if (selectedIndex.value != Fortune.indefinite) {
        progress.value = animation.value;
      }
    });

    // Ticker for continuous indefinite mode will update `progress` directly.
    _indefiniteTicker = vsync.createTicker((elapsed) {
      final delta = elapsed - _lastTick;
      _lastTick = elapsed;
      final cycleDurationMs = controller.duration?.inMilliseconds ?? 1000;
      if (cycleDurationMs == 0) return;
      _indefiniteCycles += delta.inMilliseconds / cycleDurationMs;
      progress.value = _indefiniteCycles;
    });

    _subscription = selected.listen((event) {
      selectedIndex.value = event;
      animate();
    });
  }

  set duration(Duration value) {
    controller.duration = value;
  }

  set curve(Curve value) {
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
    // Debugging logs to help with flaky test investigation.
    // Ignore in release builds.
    // If an animation is already running, only interrupt it if the new
    // selection is a definitive index (i.e. not `Fortune.indefinite`).
    // This ensures a running indefinite repeat can be stopped when a target
    // index is requested.
    // ignore: avoid_print
    print(
        'animate() called sel=${selectedIndex.value} isAnimating=${controller.isAnimating} tickerActive=${_indefiniteTicker?.isActive}');

    if (controller.isAnimating) {
      if (selectedIndex.value != Fortune.indefinite) {
        // Stop any running repeat and reset cycle tracking so subsequent
        // definitive animations behave normally.
        // ignore: avoid_print
        print(
            'animate: stopping running controller for definitive selection ${selectedIndex.value}');
        controller.stop();
        _stopIndefinite();
        _indefiniteCycles = 0.0;
        // Continue to start the requested forward animation below.
      } else {
        // Still indefinite and already animating -> nothing to do.
        if (_indefiniteTicker?.isActive ?? false) return;
      }
    }

    // ignore: avoid_print
    print('animate: calling onAnimationStart');
    await Future.microtask(() => onAnimationStart?.call());
    try {
      if (selectedIndex.value == Fortune.indefinite) {
        // Start continuous ticker-based indefinite animation.
        // ignore: avoid_print
        print('animate: starting indefinite ticker');
        _indefiniteCycles = 0.0;
        _lastTick = Duration.zero;
        progress.value = 0.0;
        _indefiniteTicker?.start();
        // Do not await; indefinite mode runs until stopped by a definitive selection.
      } else {
        // Stop any ticking indefinite animation and run a definitive animation.
        // ignore: avoid_print
        print(
            'animate: starting definitive animation to ${selectedIndex.value}');
        _stopIndefinite();
        _indefiniteCycles = 0.0;
        await controller.forward(from: 0);
      }
    } catch (e) {
      // Controller might be disposed
      // ignore: avoid_print
      print('animate: caught exception $e');
      return;
    }

    // Call onAnimationEnd only for definitive animations which reach
    // here after `controller.forward` completes. Indefinite mode should
    // not trigger onAnimationEnd until it's stopped by a definitive
    // selection which will call this later.
    if (selectedIndex.value != Fortune.indefinite) {
      // ignore: avoid_print
      print('animate: calling onAnimationEnd');
      await Future.microtask(() => onAnimationEnd?.call());
    }
  }

  void _stopIndefinite() {
    if (_indefiniteTicker?.isActive ?? false) {
      _indefiniteTicker?.stop();
    }
  }

  void dispose() {
    _subscription?.cancel();
    _stopIndefinite();
    _indefiniteTicker?.dispose();
    controller.dispose();
    selectedIndex.dispose();
    progress.dispose();
  }
}
