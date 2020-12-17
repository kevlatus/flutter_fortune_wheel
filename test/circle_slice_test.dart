import 'dart:math';

import 'package:flutter/material.dart';
import 'file:///C:/Users/kevin/dev/kevlatus/libs/flutter_fortune_wheel/lib/src/wheel/circle_slice.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CircleSliceImpl', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(CircleSliceImpl(
        radius: 5,
        angle: pi,
        fillColor: Colors.red,
        strokeColor: Colors.red,
      ));
    });
  });
}
