import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../common/common.dart';
import '../widgets/widgets.dart';

class FortuneBarPage extends HookWidget {
  static const kRouteName = 'FortuneBarPage';

  static void go(BuildContext context) {
    context.goNamed(kRouteName);
  }

  @override
  Widget build(BuildContext context) {
    final selected = useStreamController<int>();
    final selectedIndex = useStream(selected.stream, initialData: 0).data ?? 0;
    final isAnimating = useState(false);
    final isIndefinite = useState(false);

    void handleRoll() {
      if (isIndefinite.value) {
        if (isAnimating.value) {
          // Stop an ongoing indefinite spin by sending a definitive target
          selected.add(roll(Constants.fortuneValues.length));
        } else {
          // Start indefinite spin
          selected.add(Fortune.indefinite);
        }
      } else {
        selected.add(
          roll(Constants.fortuneValues.length),
        );
      }
    }

    return AppLayout(
      child: Column(
        children: [
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Indefinite wait'),
              Switch(
                value: isIndefinite.value,
                onChanged: (v) => isIndefinite.value = v,
              ),
            ],
          ),
          SizedBox(height: 8),
          RollButtonWithPreview(
            selected: selectedIndex,
            items: Constants.fortuneValues,
            onPressed:
                (isIndefinite.value || !isAnimating.value) ? handleRoll : null,
            isStopMode: isIndefinite.value && isAnimating.value,
          ),
          SizedBox(height: 8),
          Expanded(
            child: Center(
              child: FortuneBar(
                selected: selected.stream,
                items: [
                  for (var i = 0; i < Constants.fortuneValues.length; i++)
                    FortuneItem(
                      child: Text(Constants.fortuneValues[i]),
                      onTap: () => print(Constants.fortuneValues[i]),
                      weight: i.isEven ? 1 : 2,
                    )
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
      ),
    );
  }
}
