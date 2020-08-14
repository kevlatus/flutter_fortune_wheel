import 'dart:math' as Math;

import 'package:flutter/material.dart';

import 'circle_slice.dart';
import 'util.dart';

class CircleSlice {
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  final Widget child;

  const CircleSlice({
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 1,
    this.child,
  }) : assert(strokeWidth != null);
}

class SlicedCircle extends StatelessWidget {
  final List<CircleSlice> slices;

  const SlicedCircle({Key key, @required this.slices})
      : assert(slices != null && slices.length > 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final anglePerChild = kPiDouble / slices.length;

    return LayoutBuilder(builder: (context, constraints) {
      final smallerSide = getSmallerSide(constraints);

      return Transform.translate(
        offset: Offset(constraints.maxWidth / 2, constraints.maxHeight / 2),
        child: Stack(
          children: slices.asMap().keys.map((index) {
            final theme = Theme.of(context);
            final fillColor = slices[index].fillColor ??
                theme.primaryColor.withOpacity(index % 2 == 0 ? 0.2 : 0.4);
            final strokeColor = slices[index].strokeColor ?? theme.primaryColor;

            final childAngle = anglePerChild * index;
            // first slice starts at 90 degrees, if 0 degrees is at the top.
            // The angle offset puts the center of the first slice at the top.
            final angleOffset = -1 * (kPiHalf + anglePerChild / 2);

            return Transform.rotate(
              alignment: Alignment.topLeft,
              angle: childAngle + angleOffset,
              child: CircleSliceImpl(
                child: slices[index].child,
                radius: smallerSide / 2,
                angle: kPiDouble / slices.length,
                fillColor: fillColor,
                strokeColor: strokeColor,
                strokeWidth: slices[index].strokeWidth,
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
