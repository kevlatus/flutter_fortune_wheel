import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../animations.dart';
import '../fortune_widget.dart';

double _getItemWidth(double maxWidth, int itemCount) {
  final visibleItemCount = Math.min(itemCount, 3);
  return maxWidth / visibleItemCount;
}

class FortuneBand extends HookWidget implements FortuneWidget {
  final Duration duration;
  final double height;
  final VoidCallback onAnimationStart;
  final VoidCallback onAnimationEnd;
  final FortuneAnimation animationType;
  final int selected;
  final int rotationCount;
  final List<FortuneItem> items;

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

  const FortuneBand({
    Key key,
    this.height = 56.0,
    this.duration = FortuneWidget.kAnimationDuration,
    this.onAnimationStart,
    this.onAnimationEnd,
    this.animationType = FortuneAnimation.Roll,
    this.selected,
    this.rotationCount = FortuneWidget.kRotationCount,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationCtrl = useAnimationController(
      duration: duration,
    );

    Future<void> animate() async {
      if (animationCtrl.isAnimating) {
        return;
      }

      if (onAnimationStart != null) {
        await Future.delayed(Duration.zero, onAnimationStart);
      }

      animationCtrl.value = 0;
      await animationCtrl.animateTo(
        1,
        duration: duration,
        curve: Cubic(0, 1.0, 0, 1.0),
      );

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
            animation: animationCtrl,
            builder: (context, _) {
              return Stack(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Transform.translate(
                      offset: _itemOffset(
                        animationProgress: animationCtrl.value,
                        // put selected item in center
                        itemIndex: (i + 1) % items.length,
                        width: constraints.maxWidth,
                      ),
                      child: Container(
                        width: itemWidth,
                        height: height,
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide()),
                        ),
                        child: Center(child: items[i].child),
                      ),
                    )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
