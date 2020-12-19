import 'dart:math' as Math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../util.dart';

extension CirclePathExtensions on Path {
  void addSliceArc(double diameter, double angle) {
    this.arcTo(
      Rect.fromCircle(
        center: Offset(0, 0),
        radius: diameter,
      ),
      0,
      angle,
      false,
    );
  }
}

Path _buildSlicePath(double diameter, double angle) {
  return Path()
    ..moveTo(0, 0)
    ..lineTo(diameter, 0)
    ..addSliceArc(diameter, angle)
    ..lineTo(0, 0);
}

/// Draws a slice of a circle. The slice's arc starts at the right (3 o'clock)
/// and moves clockwise as far as specified by angle.
class _CircleSlicePainter extends CustomPainter {
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  final double angle;

  const _CircleSlicePainter({
    @required this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1,
    this.angle = kPiHalf,
  })  : assert(fillColor != null),
        assert(angle > 0 && angle < kPiDouble);

  @override
  void paint(Canvas canvas, Size size) {
    final diameter = Math.min(size.width, size.height);
    final path = _buildSlicePath(diameter, angle);
    // fill slice area
    canvas.drawPath(
      path,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill,
    );

    // draw slice border
    // TODO: remove condition once flutter bug is fixed
    // https://github.com/flutter/flutter/issues/67993
    if (!kIsWeb)
      canvas.drawPath(
        path,
        Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke,
      );

    // TODO: remove condition once flutter bug is fixed
    // https://github.com/flutter/flutter/issues/67993
    if (!kIsWeb)
      canvas.drawPath(
        Path()..addSliceArc(diameter, angle),
        Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth * 2
          ..style = PaintingStyle.stroke,
      );
  }

  @override
  bool shouldRepaint(_CircleSlicePainter oldDelegate) {
    return angle != oldDelegate.angle ||
        fillColor != oldDelegate.fillColor ||
        strokeColor != oldDelegate.strokeColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}

class _CircleSliceClipper extends CustomClipper<Path> {
  final double angle;

  const _CircleSliceClipper(this.angle);

  @override
  Path getClip(Size size) {
    final diameter = Math.min(size.width, size.height);
    return _buildSlicePath(diameter, angle);
  }

  @override
  bool shouldReclip(_CircleSliceClipper oldClipper) {
    return angle != oldClipper.angle;
  }
}

enum _CircleSliceSlot {
  Slice,
  Child,
}

class _CircleSliceLayoutDelegate extends MultiChildLayoutDelegate {
  final double angle;

  _CircleSliceLayoutDelegate(this.angle);

  @override
  void performLayout(Size size) {
    Size sliceSize;
    Size childSize;

    if (hasChild(_CircleSliceSlot.Slice)) {
      sliceSize = layoutChild(
        _CircleSliceSlot.Slice,
        BoxConstraints.tight(size),
      );
      positionChild(_CircleSliceSlot.Slice, Offset.zero);
    }

    if (hasChild(_CircleSliceSlot.Child)) {
      childSize = layoutChild(
        _CircleSliceSlot.Child,
        BoxConstraints.loose(size),
      );

      final diagonal = Math.Point(sliceSize.width, sliceSize.height);
      final unitDiagonal = diagonal * (1 / diagonal.magnitude);
      Math.Point<double> target = unitDiagonal * (sliceSize.width / 2);

      if (angle != kPiHalf) {
        final disposition = (angle - kPiHalf).abs() / 2;
        final direction = angle > kPiHalf ? 1 : -1;
        final rotation = disposition * direction;
        target = rotateVector(target, rotation);
      }

      positionChild(
        _CircleSliceSlot.Child,
        Offset(
          target.x - childSize.width / 2,
          target.y - childSize.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRelayout(_CircleSliceLayoutDelegate oldDelegate) {
    return angle != oldDelegate.angle;
  }
}

class CircleSlice extends StatelessWidget {
  final double radius;
  final double angle;
  final Widget child;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;

  Widget _buildChild(BuildContext context) {
    if (child == null) {
      return Container();
    }

    return Transform.rotate(
      angle: angle / 2,
      child: child,
    );
  }

  const CircleSlice({
    Key key,
    this.child,
    @required this.radius,
    @required this.fillColor,
    @required this.strokeColor,
    this.strokeWidth = 1,
    @required this.angle,
  })  : assert(radius > 0),
        assert(fillColor != null),
        assert(strokeColor != null),
        assert(angle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius,
      height: radius,
      child: ClipPath(
        clipper: _CircleSliceClipper(angle),
        child: CustomMultiChildLayout(
          delegate: _CircleSliceLayoutDelegate(angle),
          children: [
            LayoutId(
              id: _CircleSliceSlot.Slice,
              child: CustomPaint(
                painter: _CircleSlicePainter(
                  angle: angle,
                  fillColor: fillColor,
                  strokeColor: strokeColor,
                ),
              ),
            ),
            LayoutId(
              id: _CircleSliceSlot.Child,
              child: _buildChild(context),
            ),
          ],
        ),
      ),
    );
  }
}
