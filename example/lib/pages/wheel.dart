import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:go_router/go_router.dart';

import '../common/common.dart';
import '../widgets/widgets.dart';

class FortuneWheelPage extends StatefulWidget {
  static const kRouteName = 'FortuneWheelPage';

  static void go(BuildContext context) {
    context.goNamed(kRouteName);
  }

  @override
  _FortuneWheelPageState createState() => _FortuneWheelPageState();
}

class _FortuneWheelPageState extends State<FortuneWheelPage> {
  Alignment _alignment = Alignment.topCenter;
  late StreamController<int> _selected;
  int _selectedIndex = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _selected = StreamController<int>.broadcast();
    _selected.stream.listen((event) {
      if (mounted) {
        setState(() {
          _selectedIndex = event;
        });
      }
    });
  }

  @override
  void dispose() {
    _selected.close();
    super.dispose();
  }

  void _handleRoll() {
    _selected.add(
      roll(Constants.fortuneValues.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alignmentSelector = AlignmentSelector(
      selected: _alignment,
      onChanged: (v) {
        if (v != null) {
          setState(() {
            _alignment = v;
          });
        }
      },
    );

    return AppLayout(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            alignmentSelector,
            SizedBox(height: 8),
            RollButtonWithPreview(
              selected: _selectedIndex,
              items: Constants.fortuneValues,
              onPressed: _isAnimating ? null : _handleRoll,
            ),
            SizedBox(height: 8),
            Expanded(
              child: FortuneWheel(
                alignment: _alignment,
                selected: _selected.stream,
                onAnimationStart: () => setState(() => _isAnimating = true),
                onAnimationEnd: () => setState(() => _isAnimating = false),
                onFling: _handleRoll,
                hapticImpact: HapticImpact.heavy,
                indicators: [
                  FortuneIndicator(
                    alignment: _alignment,
                    child: TriangleIndicator(),
                  ),
                ],
                items: [
                  for (var it in Constants.fortuneValues)
                    FortuneItem(child: Text(it), onTap: () => print(it))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
