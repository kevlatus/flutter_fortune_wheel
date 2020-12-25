part of 'styling.dart';

class _UniformStyleStrategy implements StyleStrategy {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final TextAlign textAlign;
  final TextStyle textStyle;

  const _UniformStyleStrategy({
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
