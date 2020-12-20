import 'dart:math' as Math;

import 'package:flutter/widgets.dart';

import 'fortune_widget.dart' show FortuneWidget;

/// Static methods for common tasks when working with [FortuneWidget]s.
abstract class Fortune {
  /// Generates a random integer uniformly distributed in the range
  /// from [min], inclusive, to [max], exclusive.
  ///
  /// The value of [max] must be larger than or equal to [min]. If it is equal
  /// to [min], this function always returns [min].
  ///
  /// An instance of [Math.Random] can optionally be passed to customize the
  /// random sample distribution.
  static int randomInt(int min, int max, [Math.Random random]) {
    random = random ?? Math.Random();
    if (min == max) {
      return min;
    }
    final _rng = Math.Random();
    return min + _rng.nextInt(max - min);
  }

  /// Generates a random [Duration] uniformly distributed in the range
  /// from [min], inclusive, to [max], exclusive.
  ///
  /// The value of [max] must be larger than or equal to [min]. If it is equal
  /// to [min], this function always returns [min].
  ///
  /// An instance of [Math.Random] can optionally be passed to customize the
  /// random sample distribution.
  static Duration randomDuration(
    Duration min,
    Duration max, [
    Math.Random random,
  ]) {
    random = random ?? Math.Random();
    return Duration(
      milliseconds: randomInt(min.inMilliseconds, max.inMilliseconds, random),
    );
  }
}

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
