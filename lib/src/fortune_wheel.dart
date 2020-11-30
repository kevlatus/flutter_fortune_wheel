import 'dart:math' as Math;

import 'package:flutter/material.dart';

import 'circle_slice.dart';
import 'indicators/indicators.dart';
import 'sliced_circle.dart';
import 'util.dart';

class FortuneWheel extends StatefulWidget {
  final List<CircleSlice> slices;
  final int selected;
  final int rotationCount;
  final Duration minDuration;
  final Duration maxDuration;
  final List<FortuneWheelIndicator> indicators;

  const FortuneWheel({
    Key key,
    @required this.slices,
    this.rotationCount = 100,
    this.selected = 0,
    this.minDuration = const Duration(seconds: 3),
    this.maxDuration = const Duration(seconds: 3),
    this.indicators = const <FortuneWheelIndicator>[
      const FortuneWheelIndicator(
        alignment: Alignment.topCenter,
        child: const TriangleIndicator(),
      ),
    ],
  })  : assert(slices != null && slices.length > 1),
        assert(selected >= 0 && selected < slices.length),
        super(key: key);

  @override
  _FortuneWheelState createState() => _FortuneWheelState();
}

class _FortuneWheelState extends State<FortuneWheel>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  double _getMaxAngle() {
    return -kPiDouble * (widget.slices.length * widget.rotationCount);
  }

  double _getTargetAngle() {
    final previousRotations = widget.selected / widget.rotationCount;
    final itemScale =
        widget.slices.length * widget.slices.length * widget.rotationCount;
    return previousRotations + widget.selected / itemScale;
  }

  Tween<double> _getAngleTween() {
    return Tween(
      begin: 0.0,
      end: _getMaxAngle(),
    );
  }

  Widget _buildIndicator(
    FortuneWheelIndicator indicator,
    BoxConstraints constraints,
  ) {
    if (indicator.child == null) {
      return Container();
    }

    final smallerSide = getSmallerSide(constraints);
    final radius = smallerSide / 2;
    final marginX = (constraints.maxWidth - smallerSide) / 2;
    final marginY = (constraints.maxHeight - smallerSide) / 2;
    final topRightCircleX = (radius - Math.cos(Math.pi / 4) * radius);
    final topRightCircleY = (radius - Math.sin(Math.pi / 4) * radius);
    Offset offset = Offset(0, 0);
    double angle = 0;
    if (indicator.alignment == Alignment.topCenter) {
      offset = Offset(0, marginY);
    }
    if (indicator.alignment == Alignment.bottomCenter) {
      offset = Offset(0, -marginY);
      angle = Math.pi;
    }
    if (indicator.alignment == Alignment.centerLeft) {
      offset = Offset(marginX, 0);
      angle = -Math.pi * 0.5;
    }
    if (indicator.alignment == Alignment.centerRight) {
      offset = Offset(-marginX, 0);
      angle = Math.pi * 0.5;
    }
    if (indicator.alignment == Alignment.topLeft) {
      offset = Offset(marginX + topRightCircleX, marginY + topRightCircleY);
      angle = -Math.pi * 0.25;
    }
    if (indicator.alignment == Alignment.topRight) {
      offset = Offset(-marginX - topRightCircleX, marginY + topRightCircleY);
      angle = Math.pi * 0.25;
    }
    if (indicator.alignment == Alignment.bottomRight) {
      offset = Offset(-marginX - topRightCircleX, -marginY - topRightCircleY);
      angle = Math.pi * 0.75;
    }
    if (indicator.alignment == Alignment.bottomLeft) {
      offset = Offset(marginX + topRightCircleX, -marginY - topRightCircleY);
      angle = Math.pi * 1.25;
    }
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
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _animation = _controller.drive(_getAngleTween());
  }

  @override
  void didUpdateWidget(FortuneWheel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.slices != oldWidget.slices) {
      _animation = _controller.drive(_getAngleTween());
    }

    _controller.animateTo(
      _getTargetAngle(),
      duration: rangedRandomDuration(widget.minDuration, widget.maxDuration),
      curve: Curves.easeOutExpo,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox.expand(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _animation.value,
                      child: SlicedCircle(
                        slices: widget.slices,
                      ),
                    );
                  },
                ),
              ),
            ),
            ...widget.indicators
                .map((indicator) => _buildIndicator(indicator, constraints))
                .toList(),
          ],
        );
      },
    );
  }
}
