import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../animations.dart';
import '../fortune_widget.dart';
import '../util.dart';
import '../indicators/indicators.dart';
import 'sliced_circle.dart';

class _PositionedIndicator extends StatelessWidget {
  final FortuneWheelIndicator indicator;

  Offset _getOffset(Alignment alignment, Offset margins, Offset circleMargins) {
    if (indicator.alignment == Alignment.topCenter) {
      return margins.scale(0, 1);
    }
    if (indicator.alignment == Alignment.bottomCenter) {
      return margins.scale(0, -1);
    }
    if (indicator.alignment == Alignment.centerLeft) {
      return margins.scale(1, 0);
    }
    if (indicator.alignment == Alignment.centerRight) {
      return margins.scale(-1, 0);
    }
    if (indicator.alignment == Alignment.topLeft) {
      return margins.translate(circleMargins.dx, circleMargins.dy);
    }
    if (indicator.alignment == Alignment.topRight) {
      return margins
          .scale(-1, 1)
          .translate(-circleMargins.dx, circleMargins.dy);
    }
    if (indicator.alignment == Alignment.bottomRight) {
      return margins
          .scale(-1, -1)
          .translate(-circleMargins.dx, -circleMargins.dy);
    }
    if (indicator.alignment == Alignment.bottomLeft) {
      return margins
          .scale(1, -1)
          .translate(circleMargins.dx, -circleMargins.dy);
    }

    return Offset(0, 0);
  }

  double _getAngle(Alignment alignment) {
    if (indicator.alignment == Alignment.bottomCenter) {
      return Math.pi;
    }
    if (indicator.alignment == Alignment.centerLeft) {
      return -Math.pi * 0.5;
    }
    if (indicator.alignment == Alignment.centerRight) {
      return Math.pi * 0.5;
    }
    if (indicator.alignment == Alignment.topLeft) {
      return -Math.pi * 0.25;
    }
    if (indicator.alignment == Alignment.topRight) {
      return Math.pi * 0.25;
    }
    if (indicator.alignment == Alignment.bottomRight) {
      return Math.pi * 0.75;
    }
    if (indicator.alignment == Alignment.bottomLeft) {
      return Math.pi * 1.25;
    }

    return 0;
  }

  const _PositionedIndicator({
    Key key,
    @required this.indicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final margins = getCenteredMargins(constraints);
        final smallerSide = getSmallerSide(constraints);
        final radius = smallerSide / 2;
        final circleMargins = Offset(
          (radius - Math.cos(Math.pi / 4) * radius),
          (radius - Math.sin(Math.pi / 4) * radius),
        );
        Offset offset = _getOffset(indicator.alignment, margins, circleMargins);
        double angle = _getAngle(indicator.alignment);
        return Align(
          alignment: indicator.alignment,
          child: Transform.translate(
            offset: offset,
            child: Transform.rotate(
              angle: angle,
              child: indicator.child,
            ),
          ),
        );
      },
    );
  }
}

class FortuneWheel extends HookWidget implements FortuneWidget {
  /// A list of circle slices this fortune wheel should contain.
  /// Must not be null and contain at least 2 slices.
  final List<FortuneItem> items;
  final int selected;
  final int rotationCount;
  final Duration duration;
  final List<FortuneWheelIndicator> indicators;
  final FortuneAnimation animationType;
  final VoidCallback onAnimationStart;
  final VoidCallback onAnimationEnd;

  double _getAngle(double progress) {
    return 2 * Math.pi * rotationCount * progress;
  }

  const FortuneWheel({
    Key key,
    @required this.items,
    this.rotationCount = FortuneWidget.kRotationCount,
    this.selected = 0,
    this.duration = FortuneWidget.kAnimationDuration,
    this.animationType = FortuneAnimation.Roll,
    this.indicators = const <FortuneWheelIndicator>[
      const FortuneWheelIndicator(
        alignment: Alignment.topCenter,
        child: const TriangleIndicator(),
      ),
    ],
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
              child: SlicedCircle(
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
        for (var it in indicators) _PositionedIndicator(indicator: it),
      ],
    );
  }
}
