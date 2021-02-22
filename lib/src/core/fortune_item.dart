part of 'core.dart';

/// A [FortuneItem] represents a value, which is chosen during a selection
/// process and displayed within a [FortuneWidget].
///
/// See also:
///  * [FortuneWidget]
@immutable
class FortuneItem {
  final FortuneItemStyle? style;

  /// A widget to be rendered within this item.
  final Widget child;

  const FortuneItem({
    this.style,
    required this.child,
  }) : assert(child != null);

  @override
  int get hashCode => hash2(child, style);

  @override
  bool operator ==(Object other) {
    return other is FortuneItem && style == other.style && child == other.child;
  }
}
