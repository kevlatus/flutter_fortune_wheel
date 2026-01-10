import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('FortuneBar default indicators', () {
    testWidgets('uses BarIndicator by default', (tester) async {
      await pumpFortuneWidget(
        tester,
        FortuneBar(
          selected: const Stream.empty(),
          items: const [
            FortuneItem(child: Text('Item 1')),
            FortuneItem(child: Text('Item 2')),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(BarIndicator), findsOneWidget);

      // Ensure the indicator width is 80% of the smallest item width.
      final barWidth = tester.getSize(find.byType(FortuneBar)).width;
      final totalWeight = 2.0; // two items with default weight 1 each
      final avgWeight = totalWeight / 2; // =1
      final visibleWeight = 3 * avgWeight; // default visibleItemCount = 3
      final unitWidth = barWidth / visibleWeight;
      final expected = unitWidth *
          0.8; // smallest item weight is 1 -> item width = unitWidth

      final size = tester.getSize(find.byType(BarIndicator));
      expect(size.width, moreOrLessEquals(expected, epsilon: 0.5));
    });
  });
}
