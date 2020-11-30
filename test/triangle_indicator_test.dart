import 'package:flutter_fortune_wheel/src/indicators/indicators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TriangleIndicator', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(
        TriangleIndicator(),
      );
    });
  });
}
