part of 'wheel.dart';

Color _getDefaultFillColor(BuildContext context, int index, int length) {
  final color = Theme.of(context).primaryColor;
  final background = Theme.of(context).backgroundColor;
  final opacity = length % 2 == 1 && index == 0
      ? 0.7
      : index % 2 == 0
          ? 0.5
          : 1.0;

  return Color.alphaBlend(
    color.withOpacity(opacity),
    background,
  );
}

class _SlicedCircle extends StatelessWidget {
  final List<FortuneItem> items;

  const _SlicedCircle({
    Key key,
    @required this.items,
  })  : assert(items != null && items.length > 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final anglePerChild = 2 * Math.pi / items.length;

    return LayoutBuilder(builder: (context, constraints) {
      final smallerSide = getSmallerSide(constraints);

      return Transform.translate(
        offset: Offset(constraints.maxWidth / 2, constraints.maxHeight / 2),
        child: Stack(
          children: items.asMap().keys.map((index) {
            final theme = Theme.of(context);
            Color fillColor = items[index].color ??
                _getDefaultFillColor(
                  context,
                  index,
                  items.length,
                );
            final strokeColor = items[index].borderColor ?? theme.primaryColor;
            final strokeWidth = items[index].borderWidth ?? 1;

            final childAngle = anglePerChild * index;
            // first slice starts at 90 degrees, if 0 degrees is at the top.
            // The angle offset puts the center of the first slice at the top.
            final angleOffset = -1 * (Math.pi / 2 + anglePerChild / 2);

            return Transform.rotate(
              alignment: Alignment.topLeft,
              angle: childAngle + angleOffset,
              child: _CircleSlice(
                child: DefaultTextStyle(
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  child: items[index].child,
                ),
                radius: smallerSide / 2,
                angle: 2 * Math.pi / items.length,
                fillColor: fillColor,
                strokeColor: strokeColor,
                strokeWidth: strokeWidth,
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
