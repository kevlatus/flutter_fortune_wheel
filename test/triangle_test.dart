import 'package:flutter/material.dart';
import 'file:///C:/Users/kevin/dev/kevlatus/libs/flutter_fortune_wheel/lib/src/wheel/triangle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Triangle', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(
        Triangle(
          fillColor: Colors.red,
        ),
      );
    });
  });
}
