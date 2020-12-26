part of 'core.dart';

/// The type of animation, which is used when the value of
/// [FortuneWidget.selected] changes.
enum FortuneAnimation {
  /// Animate to the [FortuneWidget.selected] item using a spinning animation.
  Spin,
  // TODO: Move,
  /// Directly show the [FortuneWidget.selected] item without animating.
  None,
}
