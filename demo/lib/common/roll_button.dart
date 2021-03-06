part of 'common.dart';

int roll(int itemCount, {int lastValue}) {
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

typedef IntCallback = void Function(int);

class RollButton extends StatelessWidget {
  final int lastValue;
  final VoidCallback onPressed;
  final int itemCount;

  const RollButton({
    Key key,
    this.onPressed,
    this.itemCount,
    this.lastValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Roll'),
      onPressed: onPressed,
    );
  }
}

class RollButtonWithPreview extends StatelessWidget {
  final int selected;
  final List<String> items;
  final VoidCallback onPressed;

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
