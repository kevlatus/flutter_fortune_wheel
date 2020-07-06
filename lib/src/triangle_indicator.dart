import 'dart:math' as Math;

import 'package:flutter/material.dart';

import 'triangle.dart';

class TriangleIndicator extends StatelessWidget {
  final Color color;

  const TriangleIndicator({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Transform.rotate(
      angle: Math.pi,
      child: SizedBox(
        width: 24,
        height: 36,
        child: Triangle(
          fillColor: color ?? theme.accentColor,
          elevation: 2,
        ),
      ),
    );
  }
}
