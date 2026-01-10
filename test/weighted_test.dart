import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('FortuneBar Weighted Items', () {
    testWidgets('renders items with different weights', (tester) async {
      final items = [
        FortuneItem(child: Text('1'), weight: 1),
        FortuneItem(child: Text('3'), weight: 3),
      ];

      await pumpFortuneWidget(
        tester,
        FortuneBar(
          items: items,
          selected: Stream.value(0),
          animateFirst: false,
          visibleItemCount: 2,
        ),
      );

      await tester.pumpAndSettle();

      // InfiniteBar may render duplicates for infinite scrolling effect.
      // We expect at least one of each.
      expect(find.text('1'), findsAtLeastNWidgets(1));
      expect(find.text('3'), findsAtLeastNWidgets(1));
    });
  });

  group('FortuneWheel Weighted Items', () {
    testWidgets('renders items with different weights', (tester) async {
       final items = [
        FortuneItem(child: Text('1'), weight: 1),
        FortuneItem(child: Text('3'), weight: 3),
      ];

      await pumpFortuneWidget(
        tester,
        FortuneWheel(
          items: items,
          selected: Stream.value(0),
          animateFirst: false,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('1'), findsAtLeastNWidgets(1));
      expect(find.text('3'), findsAtLeastNWidgets(1));
    });
  });
}
