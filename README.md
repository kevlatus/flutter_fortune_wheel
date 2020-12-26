[![](https://img.shields.io/pub/v/flutter_fortune_wheel)](https://pub.dev/packages/flutter_fortune_wheel)
[![Coverage Status](https://coveralls.io/repos/github/kevlatus/flutter_fortune_wheel/badge.svg?branch=main)](https://coveralls.io/github/kevlatus/flutter_fortune_wheel?branch=main)

# Flutter Fortune Wheel

Wheel of fortune widgets for Flutter, which allow you to visualize random selection processes.
They are highly customizable and work across mobile, desktop and the web.

<p align="center">
  <img src="https://raw.githubusercontent.com/kevlatus/flutter_fortune_wheel/main/images/img-wheel-256.png">
</p>

## Quick Start

First install the package via [pub.dev](https://pub.dev/packages/flutter_fortune_wheel/install).
Then import and use the [FortuneWidget](https://pub.dev/documentation/flutter_fortune_wheel/latest/flutter_fortune_wheel/FortuneWidget-class.html):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

FortuneWidget.wheel(
  selected: 0,
  items: [
    FortuneItem(child: Text('Han Solo')),
    FortuneItem(child: Text('Yoda')),
    FortuneItem(child: Text('Obi-Wan Kenobi')),
  ],
)
```

## Examples

The wheel of fortune is the most iconic visualization.

<p align="center">
  <img src="https://raw.githubusercontent.com/kevlatus/flutter_fortune_wheel/main/images/img-wheel-anim.gif">
</p>

Unfortunately, it is not the best solution when available vertical screen space is small.

The fortune bar is an alternative visualization, which is smaller in the vertical direction, 
but is supposed to take the full screen width. See below for an example:

<p align="center">
  <img src="https://raw.githubusercontent.com/kevlatus/flutter_fortune_wheel/main/images/img-bar-anim.gif">
</p>

```dart
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

FortuneWidget.bar(
  selected: 0,
  items: [
    FortuneItem(child: Text('Han Solo')),
    FortuneItem(child: Text('Yoda')),
    FortuneItem(child: Text('Obi-Wan Kenobi')),
  ],
)
```

## Contributions

Contributions are much appreciated.

If you have any ideas for alternative visualizations, feel free to 
[open a pull request](https://github.com/kevlatus/flutter_fortune_wheel/pulls) or
[raise an issue](https://github.com/kevlatus/flutter_fortune_wheel/issues).
The same holds for any requests regarding existing widgets.
