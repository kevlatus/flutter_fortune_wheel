import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BarIndicator', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(const BarIndicator());
      await tester.pumpAndSettle();
    });
  });
}
