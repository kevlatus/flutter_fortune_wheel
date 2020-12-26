import 'package:flutter/widgets.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

Future pumpBar(WidgetTester tester, FortuneBar bar) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: bar,
    ),
  );
}

const List<FortuneItem> testItems = const <FortuneItem>[
  FortuneItem(child: Text('1')),
  FortuneItem(child: Text('2')),
];

void main() {
  group('FortuneBar', () {
    group('animation callbacks', () {
      testWidgets(
        'are not called on first build when animateFirst is false',
        (WidgetTester tester) async {
          bool didCallStart = false;
          bool didCallEnd = false;

          void onStart() {
            didCallStart = true;
          }

          void onEnd() {
            didCallEnd = true;
          }

          await pumpBar(
            tester,
            FortuneBar(
              animateFirst: false,
              selected: 0,
              onAnimationStart: onStart,
              onAnimationEnd: onEnd,
              items: testItems,
            ),
          );

          await tester.pumpAndSettle();

          expect(didCallStart, isFalse);
          expect(didCallEnd, isFalse);
        },
      );

      testWidgets(
        'are called once on first build when animateFirst is true',
        (WidgetTester tester) async {
          List<bool> startLog = <bool>[];
          List<bool> endLog = <bool>[];

          void onStart() {
            startLog.add(true);
          }

          void onEnd() {
            endLog.add(true);
          }

          await pumpBar(
            tester,
            FortuneBar(
              animateFirst: true,
              selected: 0,
              onAnimationStart: onStart,
              onAnimationEnd: onEnd,
              items: testItems,
            ),
          );

          await tester.pumpAndSettle();

          expect(startLog, hasLength(1));
          expect(startLog, contains(true));
          expect(endLog, hasLength(1));
          expect(endLog, contains(true));
        },
      );

      testWidgets(
        'are called when the value of selected changes',
        (WidgetTester tester) async {
          List<bool> startLog = <bool>[];
          List<bool> endLog = <bool>[];

          void onStart() {
            startLog.add(true);
          }

          void onEnd() {
            endLog.add(true);
          }

          await pumpBar(
            tester,
            FortuneBar(
              animateFirst: false,
              selected: 0,
              items: testItems,
              onAnimationStart: onStart,
              onAnimationEnd: onEnd,
            ),
          );

          await tester.pumpAndSettle();

          expect(startLog, isEmpty);
          expect(endLog, isEmpty);

          await pumpBar(
            tester,
            FortuneBar(
              animateFirst: false,
              selected: 1,
              items: testItems,
              onAnimationStart: onStart,
              onAnimationEnd: onEnd,
            ),
          );

          await tester.pumpAndSettle();

          expect(startLog, hasLength(1));
          expect(startLog, contains(true));
          expect(endLog, hasLength(1));
          expect(endLog, contains(true));
        },
      );
    });
  });
}
