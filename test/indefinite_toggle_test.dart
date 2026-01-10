import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('pressing toggle starts indefinite then stops on second press',
      (tester) async {
    final selected = StreamController<int>();
    final isAnimating = ValueNotifier<bool>(false);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: isAnimating,
                builder: (context, anim, child) {
                  return ElevatedButton(
                    child: Text('Toggle'),
                    onPressed: () {
                      if (!anim) {
                        selected.add(Fortune.indefinite);
                      } else {
                        selected.add(0);
                      }
                    },
                  );
                },
              ),
              Expanded(
                child: FortuneWheel(
                  items: [
                    FortuneItem(child: Text('0')),
                    FortuneItem(child: Text('1')),
                  ],
                  selected: selected.stream,
                  duration: const Duration(milliseconds: 200),
                  onAnimationStart: () => isAnimating.value = true,
                  onAnimationEnd: () => isAnimating.value = false,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Start indefinite spinning
    await tester.tap(find.text('Toggle'));
    await tester.pump();

    // Wait until onAnimationStart has been called (with a reasonable timeout)
    var started = false;
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 20));
      if (isAnimating.value) {
        started = true;
        break;
      }
    }
    expect(started, isTrue, reason: 'Expected indefinite spin to start');

    // Press again to stop
    await tester.tap(find.text('Toggle'));

    var stopped = false;
    for (var i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 20));
      if (!isAnimating.value) {
        stopped = true;
        break;
      }
    }

    expect(stopped, isTrue,
        reason: 'Expected indefinite spin to stop after pressing');
  });
}
