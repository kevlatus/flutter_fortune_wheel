import 'package:flutter_fortune_wheel/src/fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FortuneWheel', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(
        FortuneWheel(
          slices: [],
        ),
      );
    });
  });
}
