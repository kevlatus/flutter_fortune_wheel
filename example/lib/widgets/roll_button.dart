import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

int roll(int itemCount) {
  return Random().nextInt(itemCount);
}

typedef IntCallback = void Function(int);

class RollButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const RollButton({
    Key? key,
    this.onPressed,
    this.label = 'Roll',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(label),
      onPressed: onPressed,
    );
  }
}

class RollButtonWithPreview extends StatelessWidget {
  final int selected;
  final List<String> items;
  final VoidCallback? onPressed;
  final bool isStopMode;

  const RollButtonWithPreview({
    Key? key,
    required this.selected,
    required this.items,
    this.onPressed,
    this.isStopMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final preview = selected == Fortune.indefinite
        ? 'Indefinite'
        : (selected < 0 || selected >= items.length ? '-' : items[selected]);

    return Wrap(
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.vertical,
      children: [
        RollButton(onPressed: onPressed, label: isStopMode ? 'Stop' : 'Roll'),
        Text('Rolled Value: $preview'),
      ],
    );
  }
}
