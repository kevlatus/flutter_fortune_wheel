import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
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
