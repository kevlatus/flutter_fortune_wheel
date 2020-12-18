import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/indicators/triangle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Triangle', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(
        Triangle(
          color: Colors.red,
        ),
      );
    });
  });
}
