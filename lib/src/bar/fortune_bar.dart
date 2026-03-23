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

class _FortuneBarState extends State<FortuneBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationCtrl;
  late CurvedAnimation _animation;
  int _selectedIndex = 0;
  StreamSubscription<int>? _subscription;

  @override
  void initState() {
    super.initState();
    _animationCtrl =
        AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _animationCtrl, curve: widget.curve);

    if (widget.animateFirst) {
      _animate();
    }

    _subscription = widget.selected.listen((event) {
      if (mounted) {
        setState(() {
          _selectedIndex = event;
        });
      }
      _animate();
    });
  }

  @override
  void didUpdateWidget(FortuneBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _animationCtrl.duration = widget.duration;
    }
    if (oldWidget.curve != widget.curve) {
      _animation.curve = widget.curve;
    }
    if (oldWidget.selected != widget.selected) {
      _subscription?.cancel();
      _subscription = widget.selected.listen((event) {
        if (mounted) {
          setState(() {
            _selectedIndex = event;
          });
        }
        _animate();
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _animationCtrl.dispose();
    super.dispose();
  }

  Future<void> _animate() async {
    if (_animationCtrl.isAnimating) {
      return;
    }

    await Future.microtask(() => widget.onAnimationStart?.call());
    await _animationCtrl.forward(from: 0);
    await Future.microtask(() => widget.onAnimationEnd?.call());
  }

  @override
  Widget build(BuildContext context) {
    final visibleItemCount =
        _math.min(widget.visibleItemCount, widget.items.length);
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
                    animation: _animation,
                    builder: (context, _) {
                      final itemPosition =
                          (widget.items.length * widget.rotationCount +
                              _selectedIndex);
                      final isAnimatingPanFactor =
                          _animationCtrl.isAnimating ? 0 : 1;
                      final panFactor = 2 / size.width;
                      final panOffset = -panState.distance * panFactor;
                      final position = _animation.value * itemPosition +
                          panOffset * isAnimatingPanFactor;

                      return _InfiniteBar(
                        centerPosition: 1,
                        visibleItemCount: visibleItemCount,
                        size: size,
                        position: position,
                        children: [
                          for (int i = 0; i < widget.items.length; i++)
                            _FortuneBarItem(
                              item: widget.items[i],
                              style: widget.styleStrategy.getItemStyle(
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
