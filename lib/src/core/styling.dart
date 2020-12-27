part of 'core.dart';

@immutable
class FortuneItemStyle {
  /// The color used for filling the background of a fortune item.
  final Color color;

  /// The color used for painting the border of a fortune item.
  final Color borderColor;

  /// The border width of a fortune item.
  final double borderWidth;

  final TextAlign textAlign;

  final TextStyle textStyle;

  const FortuneItemStyle({
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    this.textAlign = TextAlign.start,
    this.textStyle,
  })  : assert(color != null),
        assert(borderColor != null),
        assert(borderWidth != null);

  @override
  int get hashCode => hashObjects([
        borderColor,
        borderWidth,
        color,
        textAlign,
        textStyle,
      ]);

  @override
  bool operator ==(Object other) {
    return other is FortuneItemStyle &&
        borderColor == other.borderColor &&
        borderWidth == other.borderWidth &&
        color == other.color &&
        textAlign == other.textAlign &&
        textStyle == other.textStyle;
  }
}

abstract class StyleStrategy {
  FortuneItemStyle getItemStyle(
    ThemeData data,
    int index,
    int itemCount,
  );
}

class UniformStyleStrategy implements StyleStrategy {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final TextAlign textAlign;
  final TextStyle textStyle;

  const UniformStyleStrategy({
    this.color,
    this.borderColor,
    this.borderWidth,
    this.textAlign,
    this.textStyle,
  });

  @override
  FortuneItemStyle getItemStyle(ThemeData theme, int index, int itemCount) {
    return FortuneItemStyle(
      color: color ??
          Color.alphaBlend(
            theme.primaryColor.withOpacity(0.3),
            theme.colorScheme.surface,
          ),
      borderColor: borderColor ?? theme.primaryColor,
      borderWidth: borderWidth ?? 1.0,
      textStyle: textStyle ?? TextStyle(color: theme.colorScheme.onSurface),
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}

class AlternatingStyleStrategy implements StyleStrategy {
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

  const AlternatingStyleStrategy();

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
