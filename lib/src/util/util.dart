import 'dart:math' as Math;

import 'package:flutter/widgets.dart';
import 'package:flutter_fortune_wheel/src/core/core.dart';

import '../core/core.dart' show FortuneWidget;

part 'random.dart';

Math.Point<double> rotateVector(Math.Point<double> vector, double angle) {
  return Math.Point(
    Math.cos(angle) * vector.x - Math.sin(angle) * vector.x,
    Math.sin(angle) * vector.y + Math.cos(angle) * vector.y,
  );
}

double getSmallerSide(BoxConstraints constraints) {
  return Math.min(constraints.maxWidth, constraints.maxHeight);
}

Offset getCenteredMargins(BoxConstraints constraints) {
  final smallerSide = getSmallerSide(constraints);
  return Offset(
    (constraints.maxWidth - smallerSide) / 2,
    (constraints.maxHeight - smallerSide) / 2,
  );
}
