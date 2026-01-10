import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('Fortune Styling', () {
    testWidgets('FortuneWheel respects item style', (tester) async {
      const style = FortuneItemStyle(
        color: Colors.red,
        borderColor: Colors.green,
        borderWidth: 5.0,
        textStyle: TextStyle(fontSize: 20),
      );

      await pumpFortuneWidget(
        tester,
        FortuneWheel(
          selected: const Stream.empty(),
          items: const [
            FortuneItem(child: Text('Item 1'), style: style),
            FortuneItem(child: Text('Item 2')),
          ],
        ),
      );

      await tester.pumpAndSettle();

      final textFinder = find.text('Item 1');
      expect(textFinder, findsOneWidget);

      final textContext = tester.element(textFinder.first);
      final defaultTextStyle = DefaultTextStyle.of(textContext);

      expect(defaultTextStyle.style.fontSize, 20);
    });

    testWidgets('FortuneBar respects item style', (tester) async {
      const style = FortuneItemStyle(
        color: Colors.red,
        borderColor: Colors.green,
        borderWidth: 5.0,
        textAlign: TextAlign.right,
        textStyle: TextStyle(fontSize: 20),
      );

      await pumpFortuneWidget(
        tester,
        FortuneBar(
          selected: const Stream.empty(),
          items: const [
            FortuneItem(child: Text('Item 1'), style: style),
            FortuneItem(child: Text('Item 2')),
          ],
        ),
      );

      await tester.pumpAndSettle();

      final boxes = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
      print('Found ${boxes.length} DecoratedBoxes');

      var foundCorrectDecoration = false;
      for (var box in boxes) {
        if (box.decoration is BoxDecoration) {
          final decoration = box.decoration as BoxDecoration;
          print(
              // ignore: lines_longer_than_80_chars
              'BoxDecoration: color=${decoration.color}, border=${decoration.border}');

          if (decoration.color == Colors.red) {
            if (decoration.border != null &&
                decoration.border!.top.color == Colors.green) {
              foundCorrectDecoration = true;
            }
          }
        }
      }

      expect(foundCorrectDecoration, isTrue,
          reason:
              'Could not find DecoratedBox with red color and green border');

      tester.firstWidget<Text>(find.text('Item 1'));
      final textContext = tester.element(find.text('Item 1').first);
      final defaultTextStyle = DefaultTextStyle.of(textContext);

      expect(defaultTextStyle.style.fontSize, 20);
      expect(defaultTextStyle.textAlign, TextAlign.right);
    });
  });
}
