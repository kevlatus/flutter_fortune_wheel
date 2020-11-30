import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/circle_slice.dart';
import 'package:flutter_fortune_wheel/src/sliced_circle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SlicedCircle', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SlicedCircle(
            slices: [
              CircleSlice(),
              CircleSlice(),
            ],
          ),
        ),
      );
    });
  });
}
