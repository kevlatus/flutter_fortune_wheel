import 'dart:math';

import 'package:flutter/material.dart';

typedef IntCallback = void Function(int);

class RollButton extends StatelessWidget {
  final int lastValue;
  final IntCallback onPressed;
  final int itemCount;

  const RollButton({
    Key key,
    this.onPressed,
    this.itemCount,
    this.lastValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int roll() {
      if (lastValue == null) {
        return Random().nextInt(itemCount);
      } else {
        int val = lastValue;
        while (val == lastValue) {
          val = Random().nextInt(itemCount);
        }
        return val;
      }
    }

    return ElevatedButton(
      child: Text('Roll'),
      onPressed: onPressed == null ? null : () => onPressed(roll()),
    );
  }
}

class RollButtonWithPreview extends StatelessWidget {
  final int selected;
  final List<String> items;
  final IntCallback onPressed;

  const RollButtonWithPreview({
    Key key,
    this.selected,
    this.items,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.vertical,
      children: [
        RollButton(
          itemCount: items.length,
          onPressed: onPressed,
          lastValue: selected,
        ),
        Text('Rolled Value: ${items[selected]}'),
      ],
    );
  }
}
