import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  group('FortuneWheel Indefinite Spin', () {
    testWidgets('supports indefinite spin then stop at target', (tester) async {
      final selected = StreamController<int>();

      await pumpFortuneWidget(
        tester,
        FortuneWheel(
          items: [
            FortuneItem(child: Text('0')),
            FortuneItem(child: Text('1')),
            FortuneItem(child: Text('2')),
          ],
          selected: selected.stream,
        ),
      );

      // Trigger indefinite spin
      selected.add(Fortune.indefinite);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Trigger stop
      selected.add(1);
      await tester.pump();
      await tester.pump(const Duration(seconds: 5)); // Allow time to settle

      // Verify no crashes.
      // In a real integration test we would verify the visual state, but here we ensure the logic runs.
    });
  });
}
