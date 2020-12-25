part of 'core.dart';

/// A [FortuneWidget] visualizes (random) selection processes by iterating over
/// a list of items before settling on a selected item.
///
/// See also:
///  * [FortuneWheel]
///  * [FortuneBar]
///  * [FortuneItem]
abstract class FortuneWidget implements Widget {
  /// The default value for [duration] (currently **5 seconds**).
  static const Duration kDefaultDuration = const Duration(seconds: 5);

  /// The default value for [rotationCount] (currently **100**).
  static const int kDefaultRotationCount = 100;

  /// {@template flutter_fortune_wheel.FortuneWidget.items}
  /// A list of [FortuneItem]s to be shown within this [FortuneWidget].
  /// {@endtemplate}
  List<FortuneItem> get items;

  /// {@template flutter_fortune_wheel.FortuneWidget.selected}
  /// The currently selected index within [items].
  /// Used by [FortuneWidget]s to align [indicators] on the selected item.
  /// {@endtemplate}
  int get selected;

  /// {@template flutter_fortune_wheel.FortuneWidget.rotationCount}
  /// The number of times a [FortuneWidget] rotates around all
  /// [items] before it settles on the [selected] value.
  /// {@endtemplate}
  int get rotationCount;

  /// {@template flutter_fortune_wheel.FortuneWidget.duration}
  /// The animation duration used for [FortuneAnimation.Spin]
  /// within [FortuneWidget] instances.
  /// {@endtemplate}
  Duration get duration;

  /// {@template flutter_fortune_wheel.FortuneWidget.animationType}
  /// The type of animation to be used when [selected] changes.
  ///
  /// See also:
  ///  * [FortuneAnimation]
  /// {@endtemplate}
  FortuneAnimation get animationType;

  /// {@template flutter_fortune_wheel.FortuneWidget.onAnimationStart}
  /// Called when this widget starts an animation.
  /// Useful for disabling other widgets during the animation.
  /// {@endtemplate}
  VoidCallback get onAnimationStart;

  /// {@template flutter_fortune_wheel.FortuneWidget.onAnimationEnd}
  /// Called when this widget's animation ends.
  /// Useful for enabling other widgets after the animation ends.
  /// {@endtemplate}
  VoidCallback get onAnimationEnd;

  /// {@template flutter_fortune_wheel.FortuneWidget.indicators}
  /// The list of [indicators] is rendered on top of the underlying
  /// [FortuneWidget]. These can be used to visualize the position of the
  /// [selected] item.
  /// {@endtemplate}
  List<FortuneIndicator> get indicators;

  /// {@template flutter_fortune_wheel.FortuneWidget.styleStrategy}
  /// The strategy to use for styling individual [items] when they have no
  /// dedicated [FortuneItem.style].
  /// {@endtemplate}
  StyleStrategy get styleStrategy;

  /// Creates a new [FortuneWheel] if the number of [items] is even or a
  /// [FortuneBar] if it is odd.
  ///
  /// {@template flutter_fortune_wheel.FortuneWidget.ctorArgs}
  /// The type of animation to be used when [selected] changes is determined
  /// by [animationType]. If it is set to [FortuneAnimation.Spin],
  /// [rotationCount] determines the number of rotations around all items before
  /// settling on the selected value during the animation [duration].
  /// The callbacks [onAnimationStart] and [onAnimationEnd] are called whenever
  /// this widget starts and ends an animation respectively. This applies to all
  /// values of [animationType].
  /// {@endtemplate}
  ///
  /// See also:
  ///  * [FortuneWidget.bar()]
  ///  * [FortuneWidget.wheel()]
  factory FortuneWidget({
    Key key,
    @required List<FortuneItem> items,
    @required int selected,
    int rotationCount = kDefaultRotationCount,
    Duration duration = kDefaultDuration,
    FortuneAnimation animationType = FortuneAnimation.Spin,
    List<FortuneIndicator> indicators,
    StyleStrategy styleStrategy,
    VoidCallback onAnimationStart,
    VoidCallback onAnimationEnd,
  }) {
    if (items.length % 2 == 0) {
      return FortuneWidget.wheel(
        key: key,
        items: items,
        selected: selected,
        rotationCount: rotationCount,
        duration: duration,
        animationType: animationType,
        indicators: indicators ?? FortuneWheel.kDefaultIndicators,
        styleStrategy: styleStrategy ?? FortuneWheel.kDefaultStyleStrategy,
        onAnimationStart: onAnimationStart,
        onAnimationEnd: onAnimationEnd,
      );
    } else {
      return FortuneWidget.bar(
        key: key,
        items: items,
        selected: selected,
        rotationCount: rotationCount,
        duration: duration,
        animationType: animationType,
        indicators: indicators ?? FortuneBar.kDefaultIndicators,
        styleStrategy: styleStrategy ?? FortuneBar.kDefaultStyleStrategy,
        onAnimationStart: onAnimationStart,
        onAnimationEnd: onAnimationEnd,
      );
    }
  }

  /// {@macro flutter_fortune_wheel.FortuneWheel}.
  const factory FortuneWidget.wheel({
    Key key,
    @required int selected,
    @required List<FortuneItem> items,
    int rotationCount,
    Duration duration,
    FortuneAnimation animationType,
    List<FortuneIndicator> indicators,
    VoidCallback onAnimationStart,
    VoidCallback onAnimationEnd,
    StyleStrategy styleStrategy,
  }) = FortuneWheel;

  /// {@macro flutter_fortune_wheel.FortuneBar}.
  const factory FortuneWidget.bar({
    Key key,
    @required List<FortuneItem> items,
    @required int selected,
    int rotationCount,
    Duration duration,
    FortuneAnimation animationType,
    List<FortuneIndicator> indicators,
    VoidCallback onAnimationStart,
    VoidCallback onAnimationEnd,
    double height,
    bool fullWidth,
    StyleStrategy styleStrategy,
  }) = FortuneBar;
}
