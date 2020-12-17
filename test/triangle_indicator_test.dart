import 'package:flutter_fortune_wheel/src/wheel/indicators/triangle_indicator.dart';
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
