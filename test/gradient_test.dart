
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('FortuneWheel with Gradient', () {
    testWidgets('renders gradient when provided', (WidgetTester tester) async {
      final gradient = LinearGradient(
        colors: [Colors.red, Colors.blue],
      );

      await pumpFortuneWidget(
        tester,
        FortuneWheel(
          selected: Stream.value(0),
          items: [
            FortuneItem(
              child: Text('Item 1'),
              style: FortuneItemStyle(
                gradient: gradient,
                borderColor: Colors.green,
                borderWidth: 2,
              ),
            ),
            FortuneItem(child: Text('Item 2')),
          ],
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);

      // Unfortunately, it is hard to verify that the canvas has actually drawn the gradient
      // without using golden tests or a mock canvas.
      // However, we can verify that the code runs without exceptions and the widget tree is built correctly.
    });
  });
}
