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
      child: RectangleIndicator(),
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

class _FortuneBarState extends State<FortuneBar> with SingleTickerProviderStateMixin {
  late FortuneAnimationManager _animationManager;

  @override
  void initState() {
    super.initState();
    _animationManager = FortuneAnimationManager(
      vsync: this,
      duration: widget.duration,
      curve: widget.curve,
      selected: widget.selected,
      rotationCount: widget.rotationCount,
      itemCount: widget.items.length,
      getPosition: (index, progress, itemCount, rotationCount) {
        return (itemCount * rotationCount + index) * progress;
      },
      onAnimationStart: () => widget.onAnimationStart?.call(),
      onAnimationEnd: () => widget.onAnimationEnd?.call(),
    );

    if (widget.animateFirst) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _animationManager.animate();
      });
    }
  }

  @override
  void dispose() {
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
    if (widget.items.length != oldWidget.items.length) {
      _animationManager.itemCount = widget.items.length;
    }
    if (widget.rotationCount != oldWidget.rotationCount) {
      _animationManager.rotationCount = widget.rotationCount;
    }
    if (widget.selected != oldWidget.selected) {
      _animationManager.updateSelected(widget.selected);
    }
    // animateFirst is only for initState
  }

  @override
  Widget build(BuildContext context) {
    final visibleItemCount = _math.min(widget.visibleItemCount, widget.items.length);
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

            return Stack(
              children: [
                AnimatedBuilder(
                    animation: Listenable.merge([
                      _animationManager.animation,
                      _animationManager.valueOffset,
                    ]),
                    builder: (context, _) {
                      final itemPosition = (widget.items.length * widget.rotationCount +
                          _animationManager.selectedIndex.value);
                      final isAnimatingPanFactor =
                          _animationManager.controller.isAnimating ? 0 : 1;
                      final panFactor = 2 / size.width;
                      final panOffset = -panState.distance * panFactor;
                      final position = _animationManager.animation.value * itemPosition +
                          panOffset * isAnimatingPanFactor + _animationManager.valueOffset.value;

                      return _InfiniteBar(
                        centerPosition: 1,
                        visibleItemCount: visibleItemCount,
                        size: size,
                        position: position,
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
                      );
                    }),
                for (var it in widget.indicators)
                  IgnorePointer(
                    child: Align(
                      alignment: it.alignment,
                      child: SizedBox(
                        width: size.width / visibleItemCount,
                        height: widget.height,
                        child: it.child,
                      ),
                    ),
                  ),
              ],
            );
          });
        });
  }
}
