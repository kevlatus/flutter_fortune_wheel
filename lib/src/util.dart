import 'dart:math' as _math;

import 'package:flutter/widgets.dart';

/// Rotates a [vector] by [angle] radians around the origin.
///
/// See also:
///  * [Mathemical proof](https://matthew-brett.github.io/teaching/rotation_2d.html), for a detailed explanation
_math.Point<double> rotateVector(_math.Point<double> vector, double angle) {
  return _math.Point(
    _math.cos(angle) * vector.x - _math.sin(angle) * vector.y,
    _math.sin(angle) * vector.x + _math.cos(angle) * vector.y,
  );
}

double getSmallerSide(BoxConstraints constraints) {
  return _math.min(constraints.maxWidth, constraints.maxHeight);
}

Offset getCenteredMargins(BoxConstraints constraints) {
  final smallerSide = getSmallerSide(constraints);
  return Offset(
    (constraints.maxWidth - smallerSide) / 2,
    (constraints.maxHeight - smallerSide) / 2,
  );
}

double convertRange(
  double value,
  double minA,
  double maxA,
  double minB,
  double maxB,
) {
  return (((value - minA) * (maxB - minB)) / (maxA - minA)) + minB;
}
