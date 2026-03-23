import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FortuneBar moves during indefinite spin', (tester) async {
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

    // Capture position of first occurrence of 'A'
    final aFinder = find.text('A');
    expect(aFinder, findsAtLeastNWidgets(1));

    final box1 = tester.getTopLeft(aFinder.first);

    // Advance time a bit to let animation progress
    await tester.pump(const Duration(milliseconds: 300));

    final box2 = tester.getTopLeft(aFinder.first);

    expect(box1 != box2, isTrue,
        reason: 'Expected position to change during indefinite spin');
  });
}
