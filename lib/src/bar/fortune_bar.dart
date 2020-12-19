part of 'bar.dart';

double _getItemWidth(double maxWidth, int itemCount) {
  final visibleItemCount = Math.min(itemCount, 3);
  return maxWidth / visibleItemCount;
}

class FortuneBar extends HookWidget implements FortuneWidget {
  static const List<FortuneIndicator> kDefaultIndicators =
      const <FortuneIndicator>[
    FortuneIndicator(child: RectangleIndicator()),
  ];

  final Duration duration;
  final double height;
  final VoidCallback onAnimationStart;
  final VoidCallback onAnimationEnd;
  final FortuneAnimation animationType;
  final int selected;
  final int rotationCount;
  final List<FortuneItem> items;
  final List<FortuneIndicator> indicators;

  Offset _itemOffset({
    int itemIndex,
    double width,
    double animationProgress,
  }) {
    itemIndex = (itemIndex - selected) % items.length;
    final itemWidth = _getItemWidth(width, items.length);
    final rotationWidth = itemWidth * items.length;

    final norm = 1 / rotationCount;
    final rotation = (animationProgress / norm).floor();
    final rotationProgress = animationProgress / norm - rotation;
    final animationValue = rotationProgress * rotationWidth;

    double x = itemWidth * itemIndex - animationValue;
    if (itemWidth * (itemIndex + 1) < animationValue) {
      x += rotationWidth;
    }
    return Offset(x, 0);
  }

  const FortuneBar({
    Key key,
    this.height = 56.0,
    this.duration = FortuneWidget.kDefaultDuration,
    this.onAnimationStart,
    this.onAnimationEnd,
    this.animationType = FortuneAnimation.Roll,
    @required this.selected,
    this.rotationCount = FortuneWidget.kDefaultRotationCount,
    this.items,
    this.indicators = kDefaultIndicators,
  }) : super(key: key);

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = _getItemWidth(constraints.maxWidth, items.length);

        return SizedBox(
          width: constraints.maxWidth,
          height: 56,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return Stack(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Transform.translate(
                      offset: _itemOffset(
                        animationProgress: animation.value,
                        // put selected item in center
                        itemIndex: (i + 1) % items.length,
                        width: constraints.maxWidth,
                      ),
                      child: _FortuneBarItem(
                        item: items[i],
                        width: itemWidth,
                        height: height,
                      ),
                    ),
                  for (var it in indicators)
                    Align(
                      alignment: it.alignment,
                      child: SizedBox(
                        width: itemWidth,
                        child: it.child,
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
