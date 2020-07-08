import 'dart:math';

import 'package:flutter_fortune_wheel/src/util.dart';
import 'package:flutter_test/flutter_test.dart';

bool equalsNumWithPrecision(num a, num b, double epsilon) {
  final diff = (a - b).abs();
  if (a == b) {
    return true;
  } else {
    return diff / min((a.abs() + b.abs()), double.maxFinite) < epsilon;
  }
}

bool equalsPointWithPrecision(Point<num> a, Point<num> b, double precision) {
  return equalsNumWithPrecision(a.x, b.x, precision) &&
      equalsNumWithPrecision(a.y, b.y, precision);
}

void main() {
  group('rotateVector', () {
    test('returns the same vector for 0 angle.', () {
      final inputVector = Point(14.0, 14.0);
      final angle = 0.0;
      final rotatedVector = rotateVector(inputVector, angle);
      expect(
          equalsPointWithPrecision(inputVector, rotatedVector, 0.00001), true);
    });

    test('returns the same vector for 2 * pi angle.', () {
      final inputVector = Point(14.0, 14.0);
      final angle = pi * 2;
      final rotatedVector = rotateVector(inputVector, angle);
      expect(
          equalsPointWithPrecision(inputVector, rotatedVector, 0.00001), true);
    });
  });

  group('rangedRandomInt', () {
    test('returns all values within the given range after a million runs', () {
      final min = 10;
      final max = 100;
      for (int i = 0; i < 10e6; i++) {
        final rnd = rangedRandomInt(min, max);
        expect(rnd >= min && rnd < max, true);
      }
    });
  });

  group('rangedRandomDuration', () {});

  group('getSmallerSide', () {});
}
