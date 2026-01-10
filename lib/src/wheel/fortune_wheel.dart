part of 'wheel.dart';

enum HapticImpact { none, light, medium, heavy }

Offset _calculateWheelOffset(
    BoxConstraints constraints, TextDirection textDirection) {
  final smallerSide = getSmallerSide(constraints);
  var offsetX = constraints.maxWidth / 2;
  if (textDirection == TextDirection.rtl) {
    offsetX = offsetX * -1 + smallerSide / 2;
  }
  return Offset(offsetX, constraints.maxHeight / 2);
}

double _calculateAlignmentOffset(Alignment alignment) {
  if (alignment == Alignment.topRight) {
    return _math.pi * 0.25;
  }

  if (alignment == Alignment.centerRight) {
    return _math.pi * 0.5;
  }

  if (alignment == Alignment.bottomRight) {
    return _math.pi * 0.75;
  }

  if (alignment == Alignment.bottomCenter) {
    return _math.pi;
  }

  if (alignment == Alignment.bottomLeft) {
    return _math.pi * 1.25;
  }

  if (alignment == Alignment.centerLeft) {
    return _math.pi * 1.5;
  }

  if (alignment == Alignment.topLeft) {
    return _math.pi * 1.75;
  }

  return 0;
}

class _WheelData {
  final BoxConstraints constraints;
  final int itemCount;
  final TextDirection textDirection;

  late final double smallerSide = getSmallerSide(constraints);
  late final double largerSide = getLargerSide(constraints);
  late final double sideDifference = largerSide - smallerSide;
  late final Offset offset = _calculateWheelOffset(constraints, textDirection);
  late final Offset dOffset = Offset(
    (constraints.maxHeight - smallerSide) / 2,
    (constraints.maxWidth - smallerSide) / 2,
  );
  late final double diameter = smallerSide;
  late final double radius = diameter / 2;
  late final double itemAngle = 2 * _math.pi / itemCount;

  _WheelData({
    required this.constraints,
    required this.itemCount,
    required this.textDirection,
  });
}

/// A fortune wheel visualizes a (random) selection process as a spinning wheel
/// divided into uniformly sized slices, which correspond to the number of
/// [items].
///
/// ![](https://raw.githubusercontent.com/kevlatus/flutter_fortune_wheel/main/images/img-wheel-256.png?sanitize=true)
///
/// See also:
///  * [FortuneBar], which provides an alternative visualization
///  * [FortuneWidget()], which automatically chooses a fitting widget
///  * [Fortune.randomItem], which helps selecting random items from a list
///  * [Fortune.randomDuration], which helps choosing a random duration
class FortuneWheel extends StatefulWidget implements FortuneWidget {
  /// The default value for [indicators] on a [FortuneWheel].
  /// Currently uses a single [TriangleIndicator] on [Alignment.topCenter].
  static const List<FortuneIndicator> kDefaultIndicators = <FortuneIndicator>[
    FortuneIndicator(
      alignment: Alignment.topCenter,
      child: TriangleIndicator(),
    ),
  ];

  static const StyleStrategy kDefaultStyleStrategy = AlternatingStyleStrategy();

  /// {@macro flutter_fortune_wheel.FortuneWidget.items}
  final List<FortuneItem> items;

  /// {@macro flutter_fortune_wheel.FortuneWidget.selected}
  final Stream<int> selected;

  /// {@macro flutter_fortune_wheel.FortuneWidget.rotationCount}
  final int rotationCount;

  /// {@macro flutter_fortune_wheel.FortuneWidget.duration}
  final Duration duration;

  /// {@macro flutter_fortune_wheel.FortuneWidget.indicators}
  final List<FortuneIndicator> indicators;

  /// {@macro flutter_fortune_wheel.FortuneWidget.animationType}
  final Curve curve;

  /// {@macro flutter_fortune_wheel.FortuneWidget.onAnimationStart}
  final VoidCallback? onAnimationStart;

  /// {@macro flutter_fortune_wheel.FortuneWidget.onAnimationEnd}
  final VoidCallback? onAnimationEnd;

  /// {@macro flutter_fortune_wheel.FortuneWidget.styleStrategy}
  final StyleStrategy styleStrategy;

  /// {@macro flutter_fortune_wheel.FortuneWidget.animateFirst}
  final bool animateFirst;

  /// {@macro flutter_fortune_wheel.FortuneWidget.physics}
  final PanPhysics physics;

  /// {@macro flutter_fortune_wheel.FortuneWidget.onFling}
  final VoidCallback? onFling;

  /// The position to which the wheel aligns the selected value.
  ///
  /// Defaults to [Alignment.topCenter]
  final Alignment alignment;

  /// HapticFeedback strength on each section border crossing.
  ///
  /// Defaults to [HapticImpact.none]
  final HapticImpact hapticImpact;

  /// Called with the index of the item at the focused [alignment] whenever
  /// a section border is crossed.
  final ValueChanged<int>? onFocusItemChanged;

  double _getAngle(double progress) {
    return 2 * _math.pi * rotationCount * progress;
  }

  /// {@template flutter_fortune_wheel.FortuneWheel}
  /// Creates a new [FortuneWheel] with the given [items], which is centered
  /// on the [selected] value.
  ///
  /// {@macro flutter_fortune_wheel.FortuneWidget.ctorArgs}.
  ///
  /// See also:
  ///  * [FortuneBar], which provides an alternative visualization.
  /// {@endtemplate}
  FortuneWheel({
    Key? key,
    required this.items,
    this.rotationCount = FortuneWidget.kDefaultRotationCount,
    this.selected = const Stream<int>.empty(),
    this.duration = FortuneWidget.kDefaultDuration,
    this.curve = FortuneCurve.spin,
    this.indicators = kDefaultIndicators,
    this.styleStrategy = kDefaultStyleStrategy,
    this.animateFirst = true,
    this.onAnimationStart,
    this.onAnimationEnd,
    this.alignment = Alignment.topCenter,
    this.hapticImpact = HapticImpact.none,
    PanPhysics? physics,
    this.onFling,
    this.onFocusItemChanged,
  })  : physics = physics ?? CircularPanPhysics(),
        assert(items.length > 1),
        super(key: key);

  @override
  _FortuneWheelState createState() => _FortuneWheelState();
}

class _FortuneWheelState extends State<FortuneWheel>
    with TickerProviderStateMixin {
  late FortuneAnimationManager _animationManager;
  late AnimationController _arrowController;
  late Animation<double> _arrowAnimation;
  double _lastVibratedAngle = 0;
  double _rotationOffset = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _arrowAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(
        parent: _arrowController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    _arrowController.addStatusListener(_arrowStatusListener);

    _animationManager = FortuneAnimationManager(
      vsync: this,
      duration: widget.duration,
      curve: widget.curve,
      selected: widget.selected,
      onAnimationStart: () => widget.onAnimationStart?.call(),
      onAnimationEnd: () => widget.onAnimationEnd?.call(),
    );

    _animationManager.selectedIndex.addListener(_handleSelectionChange);

    if (widget.animateFirst) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animationManager.animate();
      });
    }
  }

  void _handleSelectionChange() {
    final oldIndex = _previousIndex;
    final newIndex = _animationManager.selectedIndex.value;

    final oldSelectedAngle = _getAngleForIndex(oldIndex);

    // If the previous selection was indefinite, the visual rotation angle is
    // derived from the ticker-backed `progress` value. Use that value so the
    // transition to the definitive selection starts from the real current
    // rotation instead of assuming the controller's animation value.
    double oldRotationAngle;
    if (oldIndex == Fortune.indefinite) {
      oldRotationAngle = widget._getAngle(_animationManager.progress.value);
    } else {
      final currentRotation = _animationManager.animation.value;
      oldRotationAngle = _rotationOffset * (1 - currentRotation) +
          widget._getAngle(currentRotation);
    }

    final newSelectedAngle = _getAngleForIndex(newIndex);

    // We want the new animation to start at the same total angle.
    final oldTotal = oldSelectedAngle + oldRotationAngle;
    _rotationOffset = oldTotal - newSelectedAngle;

    _previousIndex = newIndex;
  }

  void _arrowStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _arrowController.reverse();
    }
  }

  void _animateArrow() {
    if (_arrowController.isCompleted) {
      _arrowController.reset();
    }
    _arrowController.forward();
  }

  @override
  void dispose() {
    _animationManager.selectedIndex.removeListener(_handleSelectionChange);
    _arrowController.removeStatusListener(_arrowStatusListener);
    _arrowController.dispose();
    _animationManager.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FortuneWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _animationManager.duration = widget.duration;
    }
    if (widget.curve != oldWidget.curve) {
      _animationManager.curve = widget.curve;
    }
    if (widget.selected != oldWidget.selected) {
      _animationManager.updateSelected(widget.selected);
    }
  }

  double _getAngleForIndex(int index) {
    if (index < 0 || index >= widget.items.length) {
      return 0;
    }

    final items = widget.items;
    final totalWeight =
        items.fold<double>(0, (prev, element) => prev + element.weight);

    // Optimize: this is O(N) inside O(1) call (when index changes).

    double weightBefore = 0;
    for (var i = 0; i < index; i++) {
      weightBefore += items[i].weight;
    }
    final itemWeight = items[index].weight;

    final anglePerWeight = 2 * _math.pi / totalWeight;
    final item0Weight = items[0].weight;

    final offsetFromZero =
        (weightBefore + itemWeight / 2 - item0Weight / 2) * anglePerWeight;

    return -offsetFromZero;
  }

  @override
  Widget build(BuildContext context) {
    return PanAwareBuilder(
      behavior: HitTestBehavior.translucent,
      physics: widget.physics,
      onFling: widget.onFling,
      builder: (context, panState) {
        return Stack(
          children: [
            AnimatedBuilder(
              animation: _animationManager.progress,
              builder: (context, _) {
                final size = MediaQuery.of(context).size;
                final meanSize = (size.width + size.height) / 2;
                final panFactor = 6 / meanSize;

                return LayoutBuilder(builder: (context, constraints) {
                  final wheelData = _WheelData(
                    constraints: constraints,
                    itemCount: widget.items.length,
                    textDirection: Directionality.of(context),
                  );

                  final isAnimatingPanFactor =
                      _animationManager.controller.isAnimating ? 0 : 1;

                  // Calculate selected angle based on weighted items
                  final selectedIndex = _animationManager.selectedIndex.value;
                  final selectedAngle = _getAngleForIndex(selectedIndex);

                  final panAngle =
                      panState.distance * panFactor * isAnimatingPanFactor;

                  // Use progress notifier which yields continuous values in
                  // ignore: lines_longer_than_80_chars
                  // indefinite mode and normalized [0,1] for definitive animations.
                  final isIndefinite = _animationManager.selectedIndex.value ==
                      Fortune.indefinite;
                  final animationValue = _animationManager.progress.value;

                  final rotationAngle = isIndefinite
                      ? widget._getAngle(animationValue)
                      : (_rotationOffset * (1 - animationValue) +
                          widget._getAngle(animationValue));

                  final alignmentOffset =
                      _calculateAlignmentOffset(widget.alignment);
                  final totalAngle = selectedAngle + panAngle + rotationAngle;

                  final focusedIndex = _borderCross(
                    totalAngle,
                    widget.items,
                    widget.hapticImpact,
                    _animateArrow,
                  );
                  if (focusedIndex != null) {
                    widget.onFocusItemChanged
                        ?.call(focusedIndex % widget.items.length);
                  }

                  // ignore: lines_longer_than_80_chars
                  // Optimization: Calculate total weight and accumulated weights once
                  final totalWeight =
                      widget.items.fold<double>(0, (p, e) => p + e.weight);
                  final anglePerWeight = 2 * _math.pi / totalWeight;
                  final item0Weight = widget.items[0].weight;
                  final angleOffset =
                      -(_math.pi / 2 + (item0Weight * anglePerWeight) / 2);

                  double currentStartAngle = 0;
                  final transformedItems = <TransformedFortuneItem>[];

                  for (var i = 0; i < widget.items.length; i++) {
                    final itemWeight = widget.items[i].weight;
                    final sweepAngle = itemWeight * anglePerWeight;

                    transformedItems.add(
                      TransformedFortuneItem(
                        item: widget.items[i],
                        angle: totalAngle +
                            alignmentOffset +
                            angleOffset +
                            currentStartAngle,
                        sweepAngle: sweepAngle,
                        offset: wheelData.offset,
                      ),
                    );
                    currentStartAngle += sweepAngle;
                  }

                  return SizedBox.expand(
                    child: _CircleSlices(
                      items: transformedItems,
                      wheelData: wheelData,
                      styleStrategy: widget.styleStrategy,
                    ),
                  );
                });
              },
            ),
            for (var it in widget.indicators)
              IgnorePointer(
                child: Container(
                  alignment: it.alignment,
                  child: AnimatedBuilder(
                    animation: _arrowAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _arrowAnimation.value),
                        child: child,
                      );
                    },
                    child: it.child,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// * vibrate and animate arrow when cross border
  int? _borderCross(
    double angle,
    List<FortuneItem> items,
    HapticImpact hapticImpact,
    VoidCallback animateArrow,
  ) {
    // ... (logic remains same, just ensure it is correct)

    final totalWeight = items.fold<double>(0, (p, e) => p + e.weight);
    final anglePerWeight = 2 * _math.pi / totalWeight;

    final item0Weight = items[0].weight;
    final item0CenterAngle = item0Weight * anglePerWeight / 2;

    var target = item0CenterAngle - angle;
    target = target % (2 * _math.pi);
    if (target < 0) target += 2 * _math.pi;

    double currentAngle = 0;
    var index = -1;

    for (var i = 0; i < items.length; i++) {
      final w = items[i].weight * anglePerWeight;
      if (target >= currentAngle && target < currentAngle + w) {
        index = i;
        break;
      }
      currentAngle += w;
    }

    if (index == -1) index = 0;

    if (_lastVibratedAngle == -1) {
      _lastVibratedAngle = index.toDouble();
      return null;
    }

    if (_lastVibratedAngle.toInt() == index) {
      return null;
    }

    final VoidCallback hapticFeedbackFunction;
    switch (hapticImpact) {
      case HapticImpact.none:
        hapticFeedbackFunction = () {};
        break;
      case HapticImpact.heavy:
        hapticFeedbackFunction = HapticFeedback.heavyImpact;
        break;
      case HapticImpact.medium:
        hapticFeedbackFunction = HapticFeedback.mediumImpact;
        break;
      case HapticImpact.light:
        hapticFeedbackFunction = HapticFeedback.lightImpact;
        break;
    }
    hapticFeedbackFunction();

    if (hapticImpact != HapticImpact.none) {
      animateArrow();
    }

    _lastVibratedAngle = index.toDouble();

    if (hapticImpact == HapticImpact.none) {
      return index;
    }

    return index;
  }
}
