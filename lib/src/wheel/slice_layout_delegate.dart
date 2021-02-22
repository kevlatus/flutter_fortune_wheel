part of 'wheel.dart';

enum _SliceSlot {
  Slice,
  Child,
}

class _CircleSliceLayoutDelegate extends MultiChildLayoutDelegate {
  final double angle;

  _CircleSliceLayoutDelegate(this.angle);

  @override
  void performLayout(Size size) {
    late Size sliceSize;
    Size childSize;

    if (hasChild(_SliceSlot.Slice)) {
      sliceSize = layoutChild(
        _SliceSlot.Slice,
        BoxConstraints.tight(size),
      );
      positionChild(_SliceSlot.Slice, Offset.zero);
    }

    if (hasChild(_SliceSlot.Child)) {
      childSize = layoutChild(
        _SliceSlot.Child,
        BoxConstraints.loose(size),
      );

      final topRectVector = Math.Point(sliceSize.width / 2, 0.0);
      final halfAngleVector = rotateVector(topRectVector, angle / 2);

      positionChild(
        _SliceSlot.Child,
        Offset(
          halfAngleVector.x - childSize.width / 2,
          halfAngleVector.y - childSize.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRelayout(_CircleSliceLayoutDelegate oldDelegate) {
    return angle != oldDelegate.angle;
  }
}
