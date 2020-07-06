import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fortune Wheel Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Text('100.000'),
      Text('10'),
      Text('100.000'),
      Text('10'),
      Text('1.000.000'),
      Text('100.000'),
      Text('10'),
      Text('1.000.000'),
    ];

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                RaisedButton(
                  child: Text('Roll'),
                  onPressed: () {
                    setState(() {
                      int rand = _value;
                      while (rand == _value) {
                        rand = Random().nextInt(children.length);
                      }
                      _value = rand;
                    });
                  },
                ),
                Expanded(
                  child: FortuneWheel(
                    selected: _value,
                    slices: children.map((e) {
                      return CircleSlice(child: e);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
