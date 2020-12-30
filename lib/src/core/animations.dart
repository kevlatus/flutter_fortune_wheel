part of 'core.dart';

/// A selection of commonly used curves for animating when the value of
/// [FortuneWidget.selected] changes.
class FortuneCurve {
  const FortuneCurve._();

  static const Curve spin = Cubic(0, 1.0, 0, 1.0);

  static const Curve none = Threshold(0.0);
}
