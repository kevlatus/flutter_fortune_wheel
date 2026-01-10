part of 'bar.dart';

class _InfiniteBar extends StatelessWidget {
  final List<Widget> children;
  final Size size;
  final double scrollOffset;
  final List<double> itemWidths;
  final double totalWidth;

  const _InfiniteBar({
    Key? key,
    required this.children,
    required this.size,
    required this.scrollOffset,
    required this.itemWidths,
    required this.totalWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final centerOffset = size.width / 2;
    // Current point on strip at center of screen is P = scrollOffset % totalWidth.
    // If P < 0, P += totalWidth.

    var P = scrollOffset % totalWidth;
    if (P < 0) P += totalWidth;

    final visibleItems = <Widget>[];

    // Iterate all items.
    double currentItemStart = 0;

    for (var i = 0; i < children.length; i++) {
      final w = itemWidths[i];
      final itemCenter = currentItemStart + w / 2;

      // Relative center to P
      var relCenter = itemCenter - P;

      // Normalize relCenter to [-totalWidth/2, totalWidth/2]
      // We want the item instance closest to the center P.
      // relCenter is distance from P.
      // We want distance to be minimal modulo totalWidth.

      // Algorithm to minimize |relCenter| with wrapping:
      // relCenter = (relCenter + totalWidth/2) % totalWidth - totalWidth/2;
      // Dart % operator can be negative.

      // Safe normalization:
      while (relCenter < -totalWidth / 2) {
        relCenter += totalWidth;
      }
      while (relCenter > totalWidth / 2) {
        relCenter -= totalWidth;
      }

      // Determine screen X
      final screenCenter = relCenter + centerOffset;
      final screenLeft = screenCenter - w / 2;

      // Check visibility and add to list
      void addIfVisible(double left) {
        if (left < size.width && left + w > 0) {
          visibleItems.add(Positioned(
            left: left,
            top: 0,
            width: w,
            height: size.height,
            child: children[i],
          ));
        }
      }

      addIfVisible(screenLeft);

      // Wrap neighbors to fill the viewport when the total strip width is small.
      if (totalWidth > 0 && totalWidth < size.width + w) {
        final repeats = (size.width / totalWidth).ceil() + 1;
        for (var n = -repeats; n <= repeats; n++) {
          if (n == 0) continue;
          addIfVisible(screenLeft + n * totalWidth);
        }
      }

      currentItemStart += w;
    }

    return ClipRect(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: visibleItems,
        ),
      ),
    );
  }
}
