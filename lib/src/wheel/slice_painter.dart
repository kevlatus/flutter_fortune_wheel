part of 'wheel.dart';

class SliceBorder {
  final BorderSide left;
  final BorderSide right;
  final BorderSide bottom;

  const SliceBorder({this.left = BorderSide.none, this.right = BorderSide.none, this.bottom = BorderSide.none});
}

/// Draws a slice of a circle. The slice's arc starts at the right (3 o'clock)
/// and moves clockwise as far as specified by angle.
class _CircleSlicePainter extends CustomPainter {
  final Color fillColor;
  final SliceBorder border;
  final double angle;
  final Gradient? gradient;

  const _CircleSlicePainter({
    required this.fillColor,
    this.gradient,
    this.border = const SliceBorder(),
    this.angle = _math.pi / 2,
  }) : assert(angle > 0 && angle < 2 * _math.pi);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = _math.min(size.width, size.height);
    final center = Offset.zero;

    final startAngle = 0.0;
    final endAngle = angle;

    /// ===== Fill =====
    final slicePath = _CircleSlice.buildSlicePath(radius, angle);

    final fillPaint =
        Paint()
          ..style = PaintingStyle.fill
          ..color = fillColor
          ..isAntiAlias = true;

    if (gradient != null) {
      fillPaint.shader = gradient!.createShader(Rect.fromCircle(center: center, radius: radius));
    }

    canvas.drawPath(slicePath, fillPaint);

    /// ===== Left edge =====
    if (border.left.width > 0) {
      final leftBorderPaint = Paint()
        ..color = border.left.color
        ..strokeWidth = border.left.width
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeCap = StrokeCap.round;
      // Extend slightly beyond radius to ensure overlap with adjacent slice
      final leftEndPoint = Offset(
        (radius + border.left.width / 2) * _math.cos(startAngle),
        (radius + border.left.width / 2) * _math.sin(startAngle),
      );
      canvas.drawLine(
        center,
        leftEndPoint,
        leftBorderPaint,
      );
    }

    /// ===== Right edge =====
    if (border.right.width > 0) {
      final rightBorderPaint = Paint()
        ..color = border.right.color
        ..strokeWidth = border.right.width
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeCap = StrokeCap.round;
      // Extend slightly beyond radius to ensure overlap with adjacent slice
      final rightEndPoint = Offset(
        (radius + border.right.width / 2) * _math.cos(endAngle),
        (radius + border.right.width / 2) * _math.sin(endAngle),
      );
      canvas.drawLine(
        center,
        rightEndPoint,
        rightBorderPaint,
      );
    }

    /// ===== Arc (bottom) =====
    if (border.bottom.width > 0) {
      final arcBorderPaint = Paint()
        ..color = border.bottom.color
        ..strokeWidth = border.bottom.width
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        angle,
        false,
        arcBorderPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircleSlicePainter oldDelegate) {
    return angle != oldDelegate.angle ||
        fillColor != oldDelegate.fillColor ||
        border.left != oldDelegate.border.left ||
        border.right != oldDelegate.border.right ||
        border.bottom != oldDelegate.border.bottom;
  }
}
