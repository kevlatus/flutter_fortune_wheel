import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/src/triangle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Triangle', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(
        Triangle(
          fillColor: Colors.red,
        ),
      );
    });
  });
}
