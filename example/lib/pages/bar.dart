import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:go_router/go_router.dart';

import '../common/common.dart';
import '../widgets/widgets.dart';

class FortuneBarPage extends StatefulWidget {
  static const kRouteName = 'FortuneBarPage';

  static void go(BuildContext context) {
    context.goNamed(kRouteName);
  }

  @override
  _FortuneBarPageState createState() => _FortuneBarPageState();
}

class _FortuneBarPageState extends State<FortuneBarPage> {
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
    return AppLayout(
      child: Column(
        children: [
          RollButtonWithPreview(
            selected: _selectedIndex,
            items: Constants.fortuneValues,
            onPressed: _isAnimating ? null : _handleRoll,
          ),
          SizedBox(height: 8),
          Expanded(
            child: Center(
              child: FortuneBar(
                selected: _selected.stream,
                items: [
                  for (var i = 0; i < Constants.fortuneValues.length; i++)
                    FortuneItem(
                      child: Text(Constants.fortuneValues[i]),
                      onTap: () => print(Constants.fortuneValues[i]),
                      weight: i.isEven ? 1 : 2,
                    )
                ],
                onFling: _handleRoll,
                onAnimationStart: () {
                  setState(() {
                    _isAnimating = true;
                  });
                },
                onAnimationEnd: () {
                  setState(() {
                    _isAnimating = false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
