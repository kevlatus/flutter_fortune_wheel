import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

double _getItemWidth(double maxWidth, int itemCount) {
  final visibleItemCount = Math.min(itemCount, 3);
  return maxWidth / visibleItemCount;
}

double _getOffsetX({
  double itemWidth,
  int itemIndex,
  int itemCount,
  double animationOffset,
}) {
  if(itemWidth * (itemIndex + 1) < animationOffset) {
    return itemWidth * itemIndex - animationOffset + itemWidth * itemCount;
  } else {
    return itemWidth * itemIndex - animationOffset;

  }
}

class FortuneBand extends HookWidget {
  final double height;

  const FortuneBand({
    Key key,
    this.height = 56.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationCtrl = useAnimationController(
      duration: Duration(milliseconds: 300),
    );

    final items = <Widget>[
      Text('A'),
      Text('B'),
      Text('C'),
      Text('D'),
      Text('E'),
      Text('F'),
    ];

    return GestureDetector(
      onTap: () {
        animationCtrl.forward();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = _getItemWidth(constraints.maxWidth, items.length);
          final totalWidth = itemWidth * items.length;

          final animation = animationCtrl.drive(
            Tween<double>(begin: 0, end: totalWidth),
          );

          return SizedBox(
            width: constraints.maxWidth,
            height: 56,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                return Stack(
                  children: [
                    for (var entry in items.asMap().entries)
                      Transform.translate(
                        offset: Offset(
                          _getOffsetX(
                            itemIndex: entry.key,
                            itemWidth: itemWidth,
                            animationOffset: animation.value,
                            itemCount: items.length,
                          ),
                          0,
                        ),
                        child: Container(
                          width: itemWidth,
                          height: height,
                          decoration: BoxDecoration(
                            border: Border(right: BorderSide()),
                          ),
                          child: Center(child: entry.value),
                        ),
                      )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
