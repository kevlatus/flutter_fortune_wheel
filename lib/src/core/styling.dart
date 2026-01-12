part of 'core.dart';

/// Represents the style of a single [FortuneItem].
///
/// See also:
///  * [StyleStrategy], which allows for styling a list of [FortuneItem]s
@immutable
class FortuneItemStyle {
  /// The color used for filling the background of a [FortuneItem].
  final Color color;

  /// The color used for filling the background of a [FortuneItem].
  final Gradient? gradient;
  final SliceBorder border;

  /// The alignment of text within a [FortuneItem]
  final TextAlign textAlign;

  /// The text style to use within a [FortuneItem]
  final TextStyle textStyle;

  const FortuneItemStyle({
    this.color = Colors.white,
    this.border = const SliceBorder(),
    this.gradient,
    this.textAlign = TextAlign.start,
    this.textStyle = const TextStyle(),
  });

  /// Creates an opinionated disabled style based on the current [ThemeData].
  FortuneItemStyle.disabled(ThemeData theme, {double opacity = 0.0})
      : this(
          color: Color.alphaBlend(
            theme.disabledColor.withOpacity(opacity),
            theme.disabledColor,
          ),
          border: const SliceBorder(),
          textStyle: TextStyle(color: theme.colorScheme.onPrimary),
        );

  @override
  int get hashCode => hashObjects([
        border,
        color,
        textAlign,
        textStyle,
      ]);

  @override
  bool operator ==(Object other) {
    return other is FortuneItemStyle &&
        border == other.border &&
        color == other.color &&
        textAlign == other.textAlign &&
        textStyle == other.textStyle;
  }
}

/// Interface for providing common styling to a list of [FortuneItem]s.
abstract class StyleStrategy {
  /// {@template flutter_fortune_wheel.StyleStrategy.getItemStyle}
  /// Creates an [FortuneItemStyle] based on the passed [theme] while
  /// considering an item's [index] with respect to the overall [itemCount].
  /// {@endtemplate}
  FortuneItemStyle getItemStyle(
    ThemeData theme,
    int index,
    int itemCount,
  );
}

/// Mixin to allow style strategies to have a common style for disabled items.
mixin DisableAwareStyleStrategy {
  List<int> get disabledIndices;

  bool _isIndexDisabled(int index) {
    return disabledIndices.contains(index);
  }

  FortuneItemStyle getDisabledItemStyle(
    ThemeData theme,
    int index,
    int itemCount,
    FortuneItemStyle Function() orElse,
  ) {
    if (_isIndexDisabled(index)) {
      return FortuneItemStyle.disabled(
        theme,
        opacity: index % 2 == 0 ? 0.2 : 0.0,
      );
    } else {
      return orElse();
    }
  }
}

/// This strategy renders all items using the same style based on the current
/// [ThemeData].
///
/// The [ThemeData.primaryColor] is used as the border color and the background
/// is drawn using the same color at 0.3 opacity.
class UniformStyleStrategy with DisableAwareStyleStrategy implements StyleStrategy {
  final Color? color;
  final SliceBorder? border;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final List<int> disabledIndices;

  const UniformStyleStrategy({
    this.color,
    this.textAlign,
    this.border,
    this.textStyle,
    this.disabledIndices = const <int>[],
  });

  /// {@macro flutter_fortune_wheel.StyleStrategy.getItemStyle}
  @override
  FortuneItemStyle getItemStyle(ThemeData theme, int index, int itemCount) {
    return getDisabledItemStyle(
      theme,
      index,
      itemCount,
      () => FortuneItemStyle(
        color: color ??
            Color.alphaBlend(
              theme.colorScheme.primary.withOpacity(0.3),
              theme.colorScheme.surface,
            ),
        border: border ??
            SliceBorder(
              left: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.0,
              ),
              right: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.0,
              ),
              bottom: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.0,
              ),
            ),
        textStyle: textStyle ?? TextStyle(color: theme.colorScheme.onSurface),
        textAlign: textAlign ?? TextAlign.center,
      ),
    );
  }
}

/// This strategy renders items in alternating variations of the
/// [ThemeData.primaryColor].
///
/// It renders even items at 0.5 opacity and odd items using the original color.
/// If the item count is odd, the first item is rendered with 0.7 opacity to
/// prevent a non-uniform style.
class AlternatingStyleStrategy with DisableAwareStyleStrategy implements StyleStrategy {
  final List<int> disabledIndices;

  Color _getFillColor(ThemeData theme, int index, int itemCount) {
    final color = theme.colorScheme.primary;
    final background = theme.colorScheme.background;
    final opacity = itemCount % 2 == 1 && index == 0
        ? 0.7 // TODO: make 0.75
        : index % 2 == 0
            ? 0.5
            : 1.0;

    return Color.alphaBlend(
      color.withOpacity(opacity),
      background,
    );
  }

  const AlternatingStyleStrategy({
    this.disabledIndices = const <int>[],
  });

  /// {@macro flutter_fortune_wheel.StyleStrategy.getItemStyle}
  @override
  FortuneItemStyle getItemStyle(ThemeData theme, int index, int itemCount) {
    return getDisabledItemStyle(
      theme,
      index,
      itemCount,
      () => FortuneItemStyle(
        color: _getFillColor(theme, index, itemCount),
        border: SliceBorder(),
        textAlign: TextAlign.start,
        textStyle: TextStyle(color: theme.colorScheme.onPrimary),
      ),
    );
  }
}
