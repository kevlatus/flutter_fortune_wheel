import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
      'FortuneBar continuous motion during indefinite spin (no per-cycle pause)',
      (tester) async {
    final selected = StreamController<int>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 100,
            child: FortuneBar(
              selected: selected.stream,
              items: [
                FortuneItem(child: Text('A')),
                FortuneItem(child: Text('B')),
                FortuneItem(child: Text('C')),
              ],
              visibleItemCount: 3,
              duration: const Duration(milliseconds: 200),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Start indefinite spinning
    selected.add(Fortune.indefinite);
    await tester.pump();

    final aFinder = find.text('A');
    final pos0 = tester.getTopLeft(aFinder.first);

    // Sample positions at short intervals and ensure they change monotonically
    await tester.pump(const Duration(milliseconds: 50));
    final pos1 = tester.getTopLeft(aFinder.first);

    await tester.pump(const Duration(milliseconds: 50));
    final pos2 = tester.getTopLeft(aFinder.first);

    // Positions should be different across sampled times indicating continuous motion.
    expect(pos0 != pos1 || pos1 != pos2, isTrue,
        reason: 'Expected continuous motion during indefinite spin');
  });
}
