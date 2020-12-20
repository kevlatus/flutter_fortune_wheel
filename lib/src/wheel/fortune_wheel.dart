part of 'wheel.dart';

class FortuneWheel extends HookWidget implements FortuneWidget {
  static const List<FortuneIndicator> kDefaultIndicators =
      const <FortuneIndicator>[
    const FortuneIndicator(
      alignment: Alignment.topCenter,
      child: const TriangleIndicator(),
    ),
  ];

  /// A list of circle slices this fortune wheel should contain.
  /// Must not be null and contain at least 2 slices.
  final List<FortuneItem> items;
  final int selected;
  final int rotationCount;
  final Duration duration;
  final List<FortuneIndicator> indicators;
  final FortuneAnimation animationType;
  final VoidCallback onAnimationStart;
  final VoidCallback onAnimationEnd;

  double _getAngle(double progress) {
    return 2 * Math.pi * rotationCount * progress;
  }

  const FortuneWheel({
    Key key,
    @required this.items,
    this.rotationCount = FortuneWidget.kDefaultRotationCount,
    this.selected = 0,
    this.duration = FortuneWidget.kDefaultDuration,
    this.animationType = FortuneAnimation.Roll,
    this.indicators = kDefaultIndicators,
    this.onAnimationStart,
    this.onAnimationEnd,
  })  : assert(items != null && items.length > 1),
        assert(selected >= 0 && selected < items.length),
        assert(animationType != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationCtrl = useAnimationController(duration: duration);
    final animation = CurvedAnimation(
      parent: animationCtrl,
      curve: Cubic(0, 1.0, 0, 1.0),
    );
    final AnimationFunc animFunc = getAnimationFunc(animationType);

    Future<void> animate() async {
      if (animationCtrl.isAnimating) {
        return;
      }

      if (onAnimationStart != null) {
        await Future.delayed(Duration.zero, onAnimationStart);
      }

      await animFunc(animationCtrl);

      if (onAnimationEnd != null) {
        await Future.delayed(Duration.zero, onAnimationEnd);
      }
    }

    useEffect(() {
      animate();
      return null;
    }, []);

    useValueChanged(selected, (_, __) {
      animate();
    });

    final wheel = AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform.rotate(
          angle: -2 * Math.pi * (selected / items.length),
          child: Transform.rotate(
            angle: _getAngle(animation.value),
            child: SizedBox.expand(
              child: _SlicedCircle(
                items: items,
              ),
            ),
          ),
        );
      },
    );

    return Stack(
      children: [
        wheel,
        for (var it in indicators) _WheelIndicator(indicator: it),
      ],
    );
  }
}
