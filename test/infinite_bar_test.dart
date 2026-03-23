import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('infinite bar wraps items to fill viewport', (tester) async {
    await pumpFortuneWidget(
      tester,
      FortuneBar(
        selected: Stream.value(0),
        items: [
          FortuneItem(child: Text('A')),
          FortuneItem(child: Text('B')),
          FortuneItem(child: Text('C')),
        ],
        visibleItemCount: 12,
      ),
    );

    await tester.pumpAndSettle();

    // Expect multiple instances of the same item since total strip width is small
    expect(find.text('A'), findsAtLeastNWidgets(4));
    expect(find.text('B'), findsAtLeastNWidgets(4));
    expect(find.text('C'), findsAtLeastNWidgets(4));
  });
}
