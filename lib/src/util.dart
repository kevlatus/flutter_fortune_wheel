import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';

const kPiHalf = Math.pi / 2;
const kPiDouble = Math.pi * 2;

Math.Point<double> rotateVector(Math.Point<double> vector, double angle) {
  return Math.Point(
    Math.cos(angle) * vector.x - Math.sin(angle) * vector.x,
    Math.sin(angle) * vector.y + Math.cos(angle) * vector.y,
  );
}

int rangedRandomInt(int min, int max) {
  if (min == max) {
    return min;
  }
  final _rng = Math.Random();
  return min + _rng.nextInt(max - min);
}

Duration rangedRandomDuration(Duration min, Duration max) {
  return Duration(
    milliseconds: rangedRandomInt(min.inMilliseconds, max.inMilliseconds),
  );
}

double getSmallerSide(BoxConstraints constraints) {
  return Math.min(constraints.maxWidth, constraints.maxHeight);
}