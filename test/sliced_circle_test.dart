import 'package:flutter_fortune_wheel/src/sliced_circle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SlicedCircle', () {
    testWidgets('', (WidgetTester tester) async {
      await tester.pumpWidget(
        SlicedCircle(
          slices: [],
        ),
      );
    });
  });
}
