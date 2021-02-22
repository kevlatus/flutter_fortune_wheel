part of 'wheel.dart';

class _CircleSlice extends StatelessWidget {
  static Path buildSlicePath(double radius, double angle) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(radius, 0)
      ..arcTo(
          Rect.fromCircle(
            center: Offset(0, 0),
            radius: radius,
          ),
          0,
          angle,
          false)
      ..close();
  }

  final double radius;
  final double angle;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;

  const _CircleSlice({
    Key? key,
    required this.radius,
    required this.fillColor,
    required this.strokeColor,
    this.strokeWidth = 1,
    required this.angle,
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
      child: CustomPaint(
        painter: _CircleSlicePainter(
          angle: angle,
          fillColor: fillColor,
          strokeColor: strokeColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _CircleSliceLayout extends StatelessWidget {
  final Widget? child;
  final _CircleSlice slice;

  const _CircleSliceLayout({
    Key? key,
    required this.slice,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: slice.radius,
      height: slice.radius,
      child: ClipPath(
        clipper: _CircleSliceClipper(slice.angle),
        child: CustomMultiChildLayout(
          delegate: _CircleSliceLayoutDelegate(slice.angle),
          children: [
            LayoutId(
              id: _SliceSlot.Slice,
              child: slice,
            ),
            if (child != null)
              LayoutId(
                id: _SliceSlot.Child,
                child: Transform.rotate(
                  angle: slice.angle / 2,
                  child: child,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
