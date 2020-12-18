import 'package:flutter/widgets.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FortuneWheel', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: FortuneWheel(
            items: <FortuneItem>[
              FortuneItem(),
              FortuneItem(),
            ],
          ),
        ),
      );
    });
  });
}
