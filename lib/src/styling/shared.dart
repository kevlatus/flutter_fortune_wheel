part of 'styling.dart';

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

  const factory StyleStrategy.alternating() = _AlternatingStyleStrategy;

  const factory StyleStrategy.uniform({
    Color color,
    Color borderColor,
    double borderWidth,
    TextStyle textStyle,
  }) = _UniformStyleStrategy;
}
