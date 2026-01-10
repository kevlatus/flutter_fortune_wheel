part of 'bar.dart';

/// A fortune bar visualizes a (random) selection process as a horizontal bar
/// divided into uniformly sized boxes, which correspond to the number of
/// [items]. When spinning, items are moved horizontally for [duration].
///
/// See also:
///  * [FortuneWheel], which provides an alternative visualization
///  * [FortuneWidget()], which automatically chooses a fitting widget
///  * [Fortune.randomItem], which helps selecting random items from a list
///  * [Fortune.randomDuration], which helps choosing a random duration
class FortuneBar extends StatefulWidget implements FortuneWidget {
  static const int kDefaultVisibleItemCount = 3;

  static const List<FortuneIndicator> kDefaultIndicators = <FortuneIndicator>[
    FortuneIndicator(
      alignment: Alignment.topCenter,
      child: BarIndicator(),
    ),
  ];

  static const StyleStrategy kDefaultStyleStrategy =
      UniformStyleStrategy(borderWidth: 4);

  /// Requires this widget to have exactly this height.
  final double height;

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

  /// {@macro flutter_fortune_wheel.FortuneWidget.physics}
  final PanPhysics physics;

  /// {@macro flutter_fortune_wheel.FortuneWidget.onFling}
  final VoidCallback? onFling;

  /// If this value is true, this widget expands to the screen width and ignores
  /// width constraints imposed by parent widgets.
  ///
  /// This is disabled by default.
  final bool fullWidth;

  /// {@macro flutter_fortune_wheel.FortuneWidget.animateFirst}
  final bool animateFirst;

  final int visibleItemCount;

  /// {@template flutter_fortune_wheel.FortuneBar}
  /// Creates a new [FortuneBar] with the given [items], which is centered
  /// on the [selected] value.
  ///
  /// {@macro flutter_fortune_wheel.FortuneWidget.ctorArgs}.
  ///
  /// See also:
  ///  * [FortuneWheel], which provides an alternative visualization.
  /// {@endtemplate}
  FortuneBar({
    Key? key,
    this.height = 56.0,
    this.duration = FortuneWidget.kDefaultDuration,
    this.onAnimationStart,
    this.onAnimationEnd,
    this.curve = FortuneCurve.spin,
    required this.selected,
    this.rotationCount = FortuneWidget.kDefaultRotationCount,
    required this.items,
    this.indicators = kDefaultIndicators,
    this.fullWidth = false,
    this.styleStrategy = kDefaultStyleStrategy,
    this.animateFirst = true,
    this.visibleItemCount = kDefaultVisibleItemCount,
    this.onFling,
    PanPhysics? physics,
  })  : physics = physics ?? DirectionalPanPhysics.horizontal(),
        super(key: key);

  @override
  _FortuneBarState createState() => _FortuneBarState();
}

class _FortuneBarState extends State<FortuneBar> with TickerProviderStateMixin {
  late FortuneAnimationManager _animationManager;
  double _scrollWeightOffset = 0;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
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

    final totalWeight = _getTotalWeight();

    // If we are stopping from an indefinite spin, the controller's animation
    // value may not reflect the current visual position. In that case we
    // compute the effective scroll weight directly from the ticker-backed
    // `progress` (which accumulates cycles) so the transition to the
    // definitive selection starts from the true current position.
    if (oldIndex == Fortune.indefinite) {
      final animationValue = _animationManager.progress.value;
      final oldScrollWeight =
          animationValue * widget.rotationCount * totalWeight;
      _scrollWeightOffset = oldScrollWeight;
      _previousIndex = newIndex;
      return;
    }

    final currentRotation = _animationManager.animation.value;

    final oldTarget = _getItemCenterWeight(oldIndex);
    final oldTotalWeight = widget.rotationCount * totalWeight + oldTarget;

    final oldScrollWeight = _scrollWeightOffset * (1 - currentRotation) +
        currentRotation * oldTotalWeight;

    _scrollWeightOffset = oldScrollWeight;
    _previousIndex = newIndex;
  }

  double _getTotalWeight() {
    return widget.items.fold<double>(0, (p, e) => p + e.weight);
  }

  double _getItemCenterWeight(int index) {
    if (index < 0 || index >= widget.items.length) return 0;

    double targetCenterWeight = 0;
    for (var i = 0; i < index; i++) {
      targetCenterWeight += widget.items[i].weight;
    }
    targetCenterWeight += widget.items[index].weight / 2;
    return targetCenterWeight;
  }

  @override
  void dispose() {
    _animationManager.selectedIndex.removeListener(_handleSelectionChange);
    _animationManager.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FortuneBar oldWidget) {
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
    // animateFirst is only for initState
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PanAwareBuilder(
        behavior: HitTestBehavior.translucent,
        physics: widget.physics,
        onFling: widget.onFling,
        builder: (context, panState) {
          return LayoutBuilder(builder: (context, constraints) {
            final size = Size(
              widget.fullWidth
                  ? MediaQuery.of(context).size.width
                  : constraints.maxWidth,
              widget.height,
            );

            // Calculate weights and dimensions
            final totalWeight = _getTotalWeight();
            final avgWeight = totalWeight / widget.items.length;
            final visibleWeight = widget.visibleItemCount * avgWeight;
            final unitWidth = size.width / visibleWeight;

            final itemWidths =
                widget.items.map((e) => e.weight * unitWidth).toList();
            final totalWidth = totalWeight * unitWidth;

            return AnimatedBuilder(
              animation: _animationManager.progress,
              builder: (context, _) {
                // Calculate Target
                final selectedIndex = _animationManager.selectedIndex.value;
                final targetCenterWeight = _getItemCenterWeight(selectedIndex);

                final targetTotalScrollWeight =
                    widget.rotationCount * totalWeight + targetCenterWeight;

                // Pan logic
                // We want panning width/2 to correspond to 1 item (avg weight).
                // panWeight = -dist * (2 * avgWeight / size.width)
                final panWeight =
                    -panState.distance * (2 * avgWeight / size.width);

                final isAnimating = _animationManager.controller.isAnimating;
                final isAnimatingPanFactor = isAnimating ? 0 : 1;

                final isIndefinite =
                    _animationManager.selectedIndex.value == Fortune.indefinite;
                final animationValue = _animationManager.progress.value;

                final currentScrollWeight = isIndefinite
                    // For indefinite mode, spin continuously by advancing the
                    // scroll weight proportional to rotation count and elapsed
                    // cycles so the visual strip scrolls until stopped.
                    ? animationValue * widget.rotationCount * totalWeight +
                        panWeight * isAnimatingPanFactor
                    : _scrollWeightOffset * (1 - animationValue) +
                        animationValue * targetTotalScrollWeight +
                        panWeight * isAnimatingPanFactor;

                final scrollOffset = currentScrollWeight * unitWidth;

                final minItemWidth = itemWidths.reduce((a, b) => a < b ? a : b);

                return Stack(
                  children: [
                    _InfiniteBar(
                      size: size,
                      scrollOffset: scrollOffset,
                      itemWidths: itemWidths,
                      totalWidth: totalWidth,
                      children: [
                        for (int i = 0; i < widget.items.length; i++)
                          _FortuneBarItem(
                            item: widget.items[i],
                            style: widget.items[i].style ??
                                widget.styleStrategy.getItemStyle(
                                  theme,
                                  i,
                                  widget.items.length,
                                ),
                          )
                      ],
                    ),
                    // ignore: lines_longer_than_80_chars
                    // Indicator children are centered in a slot of width `unitWidth`.
                    // ignore: lines_longer_than_80_chars
                    // To ensure the indicator visual stays proportional to the smallest
                    // ignore: lines_longer_than_80_chars
                    // item, we constrain the indicator to 80% of the smallest item width.
                    for (var it in widget.indicators)
                      IgnorePointer(
                        child: Align(
                          alignment: it.alignment,
                          child: SizedBox(
                            width: unitWidth,
                            height: widget.height,
                            child: Align(
                              alignment: Alignment(
                                  it.alignment.x,
                                  it.alignment.y < 0
                                      ? -1.0
                                      : (it.alignment.y > 0 ? 1.0 : -1.0)),
                              child: SizedBox(
                                width: minItemWidth * 0.8,
                                child: it.child,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          });
        });
  }
}
