import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('FortuneBar', () {
    testWidgets('renders indicators', (tester) async {
      await pumpFortuneWidget(
        tester,
        FortuneBar(
          selected: const Stream.empty(),
          indicators: const [
            FortuneIndicator(
              child: Text('Indicator'),
            )
          ],
          items: const [
            FortuneItem(child: Text('Item 1')),
            FortuneItem(child: Text('Item 2')),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Indicator'), findsOneWidget);
    });
  });
}
