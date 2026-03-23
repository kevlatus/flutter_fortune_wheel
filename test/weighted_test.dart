import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

// Access private types via type finding if necessary, or check public properties.
// Since we cannot import private types easily without forcing export or using dynamic,
// we will try to find widgets by type name or structure.

void main() {
  group('FortuneBar Weighted Items', () {
    testWidgets('renders items with different widths', (tester) async {
      final items = [
        FortuneItem(child: Text('1'), weight: 1),
        FortuneItem(child: Text('3'), weight: 3),
      ];

      await pumpFortuneWidget(
        tester,
        FortuneBar(
          items: items,
          selected: Stream.value(0),
          animateFirst: false,
          visibleItemCount: 2,
          // height: 100, width: 400?
          // pumpFortuneWidget wraps in MaterialApp/Scaffold.
          // By default screen size is 800x600.
        ),
      );

      await tester.pumpAndSettle();

      // In FortuneBar, items are wrapped in SizedBox inside _InfiniteBar.
      // We can find the SizedBoxes containing the Text widgets.

      final text1 = find.text('1');
      final text3 = find.text('3');

      expect(text1, findsAtLeastNWidgets(1));
      expect(text3, findsAtLeastNWidgets(1));

      // Find the SizedBox parent of Text('1')
      // Structure: SizedBox -> ... -> DecoratedBox -> Center -> DefaultTextStyle -> Text
      // Actually _FortuneBarItem builds:
      // GestureDetector -> DecoratedBox -> Center -> DefaultTextStyle -> Text
      // _InfiniteBar wraps _FortuneBarItem in SizedBox(width: itemWidth).

      // So we need to find the SizedBox that is an ancestor of Text('1') and child of Stack (in _InfiniteBar).

      // Let's get the render object of the Text and walk up to find the constrained width.

      double? getWidth(Finder finder) {
        final decoratedBoxFinder = find
            .ancestor(of: finder, matching: find.byType(DecoratedBox))
            .first;
        final decoratedBoxRenderObject =
            tester.renderObject(decoratedBoxFinder) as RenderBox;
        return decoratedBoxRenderObject.size.width;
      }

      final width1 = getWidth(text1);
      final width3 = getWidth(text3);

      expect(width1, isNotNull);
      expect(width3, isNotNull);

      // Allow for some floating point error
      expect(width3! / width1!, closeTo(3.0, 0.1));
    });
  });

  group('FortuneWheel Weighted Items', () {
    testWidgets('renders items with different angles', (tester) async {
      final items = [
        FortuneItem(child: Text('1'), weight: 1),
        FortuneItem(child: Text('3'), weight: 3),
      ];

      await pumpFortuneWidget(
        tester,
        FortuneWheel(
          items: items,
          selected: Stream.value(0),
          animateFirst: false,
        ),
      );

      await tester.pumpAndSettle();

      // For FortuneWheel, items are rendered in slices.
      // _TransformedCircleSlice uses CustomPaint with _CircleSlicePainter.
      // We can inspect the CustomPaint widget or finding _TransformedCircleSlice if we can export it or match it.
      // _TransformedCircleSlice is private.
      // But it contains the child Text.

      // The _CircleSliceLayout wraps the child.
      // It uses _CircleSliceLayoutDelegate(slice.angle).
      // We can try to find the CustomMultiChildLayout and check its delegate.

      double? getAngle(Finder textFinder) {
        final layoutFinder = find
            .ancestor(
                of: textFinder, matching: find.byType(CustomMultiChildLayout))
            .first;
        final layout = tester.widget(layoutFinder) as CustomMultiChildLayout;
        // The delegate is _CircleSliceLayoutDelegate. It has 'angle' property.
        // Since it is private, we can't cast it easily.
        // But we can use reflection (mirrors not available in Flutter usually) or just toString() if it helps? No.
        // Or dynamic access if we disable type checks? No.

        // Alternative: The CustomPaint sibling.
        // Inside _CircleSliceLayout, there is:
        // ClipPath -> CustomMultiChildLayout -> [LayoutId(slice), LayoutId(child)]
        // slice is _CircleSlice -> SizedBox -> CustomPaint -> _CircleSlicePainter

        // We can find the CustomPaint that is a descendant of the same _CircleSliceLayout.
        // But _CircleSliceLayout is not easily identifiable.

        // Let's use find.descendant on the CustomMultiChildLayout.
        // But CustomPaint is inside LayoutId(slice).
        // Let's iterate all CustomMultiChildLayouts.

        return (layout.delegate as dynamic).angle as double;
      }

      final angle1 = getAngle(find.text('1'));
      final angle3 = getAngle(find.text('3'));

      // Total weight = 4.
      // Item 1: 1/4 * 2pi = pi/2 = 90 deg.
      // Item 3: 3/4 * 2pi = 3pi/2 = 270 deg.

      expect(angle1, closeTo(math.pi / 2, 0.001));
      expect(angle3, closeTo(3 * math.pi / 2, 0.001));
    });
  });
}
