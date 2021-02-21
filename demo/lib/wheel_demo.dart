import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'alignment_selector.dart';
import 'roll_button.dart';

class WheelDemo extends HookWidget {
  final List<String> items;

  const WheelDemo({
    Key key,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alignment = useState(Alignment.topCenter);
    final selected = useState(0);
    final isAnimating = useState(false);

    final alignmentSelector = AlignmentSelector(
      selected: alignment.value,
      onChanged: (v) => alignment.value = v,
    );

    void handleRoll() {
      selected.value = roll(
        items.length,
        lastValue: selected.value,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          alignmentSelector,
          SizedBox(height: 8),
          RollButtonWithPreview(
            selected: selected.value,
            items: items,
            onPressed: isAnimating.value ? null : handleRoll,
          ),
          SizedBox(height: 8),
          Expanded(
            child: FortuneWheel(
              selected: selected.value,
              onAnimationStart: () => isAnimating.value = true,
              onAnimationEnd: () => isAnimating.value = false,
              onFling: () {
                handleRoll();
              },
              indicators: [
                FortuneIndicator(
                  alignment: alignment.value,
                  child: TriangleIndicator(),
                ),
              ],
              items: [for (var it in items) FortuneItem(child: Text(it))],
            ),
          ),
        ],
      ),
    );
  }
}
