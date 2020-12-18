import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SlicedCircle', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SlicedCircle(
            items: [
              FortuneItem(),
              FortuneItem(),
            ],
          ),
        ),
      );
    });
  });
}
