part of 'core.dart';

class PanState {
  final bool isPanning;
  final double distance;
  final bool wasFlung;

  const PanState({
    this.distance = 0.0,
    this.isPanning = false,
    this.wasFlung = false,
  });

  PanState copyWith({
    bool? isPanning,
    double? distance,
    bool? wasFlung,
  }) =>
      PanState(
        distance: distance ?? this.distance,
        isPanning: isPanning ?? this.isPanning,
        wasFlung: wasFlung ?? this.wasFlung,
      );

  @override
  int get hashCode => hash3(distance, isPanning, wasFlung);

  @override
  bool operator ==(Object other) {
    return other is PanState &&
        distance == other.distance &&
        isPanning == other.isPanning &&
        wasFlung == other.wasFlung;
  }

  @override
  String toString() {
    return "PanState " +
        {
          "distance": distance,
          "isPanning": isPanning,
          "wasFlung": wasFlung,
        }.toString();
  }
}

abstract class PanPhysics extends ValueNotifier<PanState> {
  static const Duration kDefaultDuration = Duration(milliseconds: 300);
  static const Curve kDefaultCurve = Curves.linear;

  Size size = Size(0.0, 0.0);

  Duration get duration;

  Curve get curve;

  PanPhysics() : super(PanState());

  void handlePanStart(DragStartDetails details);

  void handlePanUpdate(DragUpdateDetails details);

  void handlePanEnd(DragEndDetails details);
}

class NoPanPhysics extends PanPhysics {
  final Duration duration = Duration.zero;
  final Curve curve = PanPhysics.kDefaultCurve;

  @override
  void handlePanEnd(DragEndDetails details) {}

  @override
  void handlePanStart(DragStartDetails details) {}

  @override
  void handlePanUpdate(DragUpdateDetails details) {}
}

// implementation inspired by https://fireship.io/snippets/circular-drag-flutter/
class CircularPanPhysics extends PanPhysics {
  final Duration duration;
  final Curve curve;

  CircularPanPhysics({
    this.duration = PanPhysics.kDefaultDuration,
    this.curve = PanPhysics.kDefaultCurve,
  })  : assert(duration != null),
        assert(curve != null);

  void handlePanStart(DragStartDetails details) {
    value = PanState(isPanning: true);
  }

  void handlePanUpdate(DragUpdateDetails details) {
    final center = Offset(
      size.width / 2,
      Math.min(size.width, size.height) / 2,
    );
    bool onTop = details.localPosition.dy <= center.dy;
    bool onLeftSide = details.localPosition.dx <= center.dx;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    bool panUp = details.delta.dy <= 0.0;
    bool panLeft = details.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    double yChange = details.delta.dy.abs();
    double xChange = details.delta.dx.abs();

    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    double rotationalChange = verticalRotation + horizontalRotation;

    value = value.copyWith(distance: value.distance + rotationalChange);
  }

  void handlePanEnd(DragEndDetails details) {
    if (value.distance.abs() > 100 &&
        details.velocity.pixelsPerSecond.distance.abs() > 300) {
      value = value.copyWith(isPanning: false, wasFlung: true);
    } else {
      value = value.copyWith(isPanning: false);
    }
  }
}

class DirectionalPanPhysics extends PanPhysics {
  final double _direction;

  double _startPosition = 0.0;

  final Curve curve;
  final Duration duration;

  double _getOffset(Offset offset) => _direction < 0 ? offset.dy : offset.dx;

  DirectionalPanPhysics._({
    required this.curve,
    required double direction,
    required this.duration,
  })   : _direction = direction,
        assert(curve != null),
        assert(direction != null),
        assert(duration != null);

  DirectionalPanPhysics.horizontal({
    Curve curve = PanPhysics.kDefaultCurve,
    Duration duration = PanPhysics.kDefaultDuration,
  }) : this._(
          curve: curve,
          direction: 1.0,
          duration: duration,
        );

  DirectionalPanPhysics.vertical({
    Curve curve = PanPhysics.kDefaultCurve,
    Duration duration = PanPhysics.kDefaultDuration,
  }) : this._(
          curve: curve,
          direction: -1.0,
          duration: duration,
        );

  void handlePanStart(DragStartDetails details) {
    _startPosition = _getOffset(details.globalPosition);
    value = PanState(isPanning: true);
  }

  void handlePanUpdate(DragUpdateDetails details) {
    final currentPosition = _getOffset(details.globalPosition);
    final distance = currentPosition - _startPosition;
    value = value.copyWith(distance: distance);
  }

  void handlePanEnd(DragEndDetails details) {
    final velocity = _getOffset(details.velocity.pixelsPerSecond);
    if (value.distance.abs() > 100 && velocity.abs() > 300) {
      value = value.copyWith(isPanning: false, wasFlung: true);
    } else {
      value = value.copyWith(isPanning: false);
    }
  }
}

class PanAwareBuilder extends HookWidget {
  final Widget Function(BuildContext, PanState) builder;
  final PanPhysics physics;
  final HitTestBehavior? behavior;
  final VoidCallback? onFling;

  PanAwareBuilder({
    required this.builder,
    required this.physics,
    this.behavior,
    this.onFling,
  })  : assert(builder != null),
        assert(physics != null);

  @override
  Widget build(BuildContext context) {
    PanState panState = useValueListenable(physics);
    final returnAnimCtrl = useAnimationController(duration: physics.duration);
    final returnAnim = CurvedAnimation(
      parent: returnAnimCtrl,
      curve: physics.curve,
    );

    useValueChanged(panState.isPanning, (bool oldValue, Future<void>? _) async {
      if (!oldValue) {
        returnAnimCtrl.reset();
      } else {
        await returnAnimCtrl.forward(from: 0.0);
      }
    });

    useValueChanged(panState.wasFlung, (bool oldValue, Future<void>? _) async {
      if (panState.wasFlung) {
        await Future.microtask(() => onFling?.call());
      }
    });

    return LayoutBuilder(builder: (context, constraints) {
      physics.size = Size(constraints.maxWidth, constraints.maxHeight);

      return GestureDetector(
        behavior: behavior,
        onPanStart: physics.handlePanStart,
        onPanUpdate: physics.handlePanUpdate,
        onPanEnd: physics.handlePanEnd,
        child: AnimatedBuilder(
            animation: returnAnim,
            builder: (context, _) {
              final mustApplyEasing = returnAnimCtrl.isAnimating ||
                  returnAnimCtrl.status == AnimationStatus.completed;

              if (mustApplyEasing) {
                panState = panState.copyWith(
                  distance: panState.distance * (1 - returnAnim.value),
                );
              }

              return Builder(
                builder: (context) => builder(context, panState),
              );
            }),
      );
    });
  }
}
