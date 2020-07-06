import 'package:flutter/material.dart';

import 'sliced_circle.dart';
import 'triangle_indicator.dart';
import 'util.dart';

class FortuneWheel extends StatefulWidget {
  final List<CircleSlice> slices;
  final int selected;
  final int rotationCount;
  final Duration minDuration;
  final Duration maxDuration;
  final Widget topIndicator;

  const FortuneWheel({
    Key key,
    @required this.slices,
    this.rotationCount = 100,
    this.selected = 0,
    this.minDuration = const Duration(seconds: 3),
    this.maxDuration = const Duration(seconds: 3),
    this.topIndicator = const TriangleIndicator(),
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

  Widget _buildTopIndicator(BoxConstraints constraints) {
    if (widget.topIndicator == null) {
      return Container();
    }

    final smallerSide = getSmallerSide(constraints);
    final offset = Offset(
      (constraints.maxWidth - smallerSide) / 2,
      (constraints.maxHeight - smallerSide) / 2,
    );
    return Align(
      alignment: Alignment.topCenter,
      child: Transform.translate(
        offset: offset,
        child: widget.topIndicator,
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
            _buildTopIndicator(constraints),
          ],
        );
      },
    );
  }
}
