import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'roll_button.dart';

class BarDemo extends HookWidget {
  final List<String> items;

  const BarDemo({
    Key key,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selected = useState(0);
    final isAnimating = useState(false);

    return Column(
      children: [
        RollButtonWithPreview(
          selected: selected.value,
          items: items,
          onPressed: isAnimating.value
              ? null
              : (value) {
                  selected.value = value;
                },
        ),
        SizedBox(height: 8),
        Expanded(
          child: Center(
            child: FortuneBar(
              selected: selected.value,
              items: [for (var it in items) FortuneItem(child: Text(it))],
              onAnimationStart: () {
                isAnimating.value = true;
              },
              onAnimationEnd: () {
                isAnimating.value = false;
              },
            ),
          ),
        ),
      ],
    );
  }
}
