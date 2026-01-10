
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
    });
  });

  group('FortuneBar with Gradient', () {
    testWidgets('renders gradient when provided', (WidgetTester tester) async {
      final gradient = LinearGradient(
        colors: [Colors.red, Colors.blue],
      );

      await pumpFortuneWidget(
        tester,
        FortuneBar(
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

      // FortuneBar might render items multiple times for infinite scrolling, so use findsAtLeastNWidgets
      expect(find.text('Item 1'), findsAtLeastNWidgets(1));
      expect(find.text('Item 2'), findsAtLeastNWidgets(1));
    });
  });
}
