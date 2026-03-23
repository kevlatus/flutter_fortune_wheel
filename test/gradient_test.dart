import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('FortuneWheel with Gradient', () {
    testWidgets('renders gradient when provided', (tester) async {
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

      final customPaintFinder = find.byType(CustomPaint);

      var foundGradient = false;
      for (final element in customPaintFinder.evaluate()) {
        final customPaint = element.widget as CustomPaint;
        final dynamic painter = customPaint.painter;
        try {
          // Check if the painter has a gradient property and it matches our gradient
          if (painter.gradient == gradient) {
            foundGradient = true;
            break;
          }
        } catch (_) {
          // Ignore painters that don't have a gradient property
        }
      }

      expect(foundGradient, isTrue,
          reason: 'Could not find a CustomPaint with the expected gradient');
    });
  });

  group('FortuneBar with Gradient', () {
    testWidgets('renders gradient when provided', (tester) async {
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

      final decoratedBoxFinder = find.byType(DecoratedBox);

      var foundGradient = false;
      for (final element in decoratedBoxFinder.evaluate()) {
        final decoratedBox = element.widget as DecoratedBox;
        final decoration = decoratedBox.decoration;
        if (decoration is BoxDecoration && decoration.gradient == gradient) {
          foundGradient = true;
          break;
        }
      }

      expect(foundGradient, isTrue,
          reason: 'Could not find a DecoratedBox with the expected gradient');
    });
  });
}
