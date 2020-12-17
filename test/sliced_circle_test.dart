import 'package:flutter/material.dart';
import 'file:///C:/Users/kevin/dev/kevlatus/libs/flutter_fortune_wheel/lib/src/wheel/circle_slice.dart';
import 'file:///C:/Users/kevin/dev/kevlatus/libs/flutter_fortune_wheel/lib/src/wheel/sliced_circle.dart';
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
