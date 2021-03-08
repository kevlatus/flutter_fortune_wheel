import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fortune_wheel_demo/common/common.dart';

class FortuneBarPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final selected = useStreamController<int>();
    final selectedIndex = useStream(selected.stream, initialData: 0).data ?? 0;
    final isAnimating = useState(false);

    void handleRoll() {
      selected.add(
        roll(fortuneValues.length),
      );
    }

    return Column(
      children: [
        SizedBox(height: 8),
        RollButtonWithPreview(
          selected: selectedIndex,
          items: fortuneValues,
          onPressed: isAnimating.value ? null : handleRoll,
        ),
        SizedBox(height: 8),
        Expanded(
          child: Center(
            child: FortuneBar(
              selected: selected.stream,
              items: [
                for (var it in fortuneValues) FortuneItem(child: Text(it))
              ],
              onFling: handleRoll,
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
