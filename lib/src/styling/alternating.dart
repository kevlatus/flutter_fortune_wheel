part of 'styling.dart';

class _AlternatingStyleStrategy implements StyleStrategy {
  Color _getFillColor(ThemeData theme, int index, int itemCount) {
    final color = theme.primaryColor;
    final background = theme.backgroundColor;
    final opacity = itemCount % 2 == 1 && index == 0
        ? 0.7
        : index % 2 == 0
            ? 0.5
            : 1.0;

    return Color.alphaBlend(
      color.withOpacity(opacity),
      background,
    );
  }

  const _AlternatingStyleStrategy();

  @override
  FortuneItemStyle getItemStyle(ThemeData theme, int index, int itemCount) {
    return FortuneItemStyle(
      color: _getFillColor(theme, index, itemCount),
      borderColor: theme.primaryColor,
      borderWidth: 1.0,
      textAlign: TextAlign.start,
      textStyle: TextStyle(color: theme.colorScheme.onPrimary),
    );
  }
}
