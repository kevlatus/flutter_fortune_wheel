import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('FortuneBar', () {
    testWidgets('renders children with correct values', (tester) async {
      await pumpFortuneWidget(
        tester,
        FortuneBar(
          selected: const Stream.empty(),
          items: const [
            FortuneItem(child: Text('Item 1')),
            FortuneItem(child: Text('Item 2')),
            FortuneItem(child: Text('Item 3')),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsAtLeastNWidgets(1));
      expect(find.text('Item 2'), findsAtLeastNWidgets(1));
      expect(find.text('Item 3'), findsAtLeastNWidgets(1));
    });

    testWidgets('calls onFling when flung', (tester) async {
      var flung = false;
      await pumpFortuneWidget(
        tester,
        FortuneBar(
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
          find.byType(FortuneBar), const Offset(-500, 0), 2000, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(flung, isTrue);
    });
  });
}
