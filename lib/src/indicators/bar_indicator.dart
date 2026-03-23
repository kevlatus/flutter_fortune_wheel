part of 'indicators.dart';

class BarIndicator extends StatelessWidget {
  final double lineHeight;
  final double triangleHeight;
  final Color? color;
  final double elevation;

  const BarIndicator({
    Key? key,
    this.lineHeight = 2.0,
    this.triangleHeight = 8.0,
    this.color,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? Theme.of(context).colorScheme.secondary;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // horizontal line
          Container(
            width: width,
            height: lineHeight,
            color: indicatorColor,
          ),
          // downward pointing triangle (rotate the existing triangle)
          SizedBox(
            width: width / 2,
            height: triangleHeight,
            child: Transform.rotate(
              angle: _math.pi,
              child: _Triangle(
                color: indicatorColor,
                elevation: elevation,
              ),
            ),
          ),
        ],
      );
    });
  }
}
