import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('FortuneWheel', () {
    testWidgets('renders children with correct values', (tester) async {
      await pumpFortuneWidget(
        tester,
        FortuneWheel(
          selected: const Stream.empty(),
          items: const [
            FortuneItem(child: Text('Item 1')),
            FortuneItem(child: Text('Item 2')),
            FortuneItem(child: Text('Item 3')),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('calls onFling when flung', (tester) async {
      var flung = false;
      await pumpFortuneWidget(
        tester,
        FortuneWheel(
          selected: const Stream.empty(),
          onFling: () {
            flung = true;
          },
          items: const [
            FortuneItem(child: Text('Item 1')),
            FortuneItem(child: Text('Item 2')),
          ],
        ),
      );

      await tester.pumpAndSettle();

      await tester.fling(
          find.byType(FortuneWheel), const Offset(0, -500), 2000);
      await tester.pumpAndSettle();

      expect(flung, isTrue);
    });

    testWidgets('renders indicators', (tester) async {
      await pumpFortuneWidget(
        tester,
        FortuneWheel(
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
