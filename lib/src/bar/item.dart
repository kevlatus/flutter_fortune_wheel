part of 'bar.dart';

class _FortuneBarItem extends StatelessWidget {
  final Widget child;
  final FortuneItemStyle style;

  const _FortuneBarItem({
    Key? key,
    required this.child,
    this.style = const FortuneItemStyle(),
  })  : assert(child != null),
        assert(style != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: style.borderColor,
            width: style.borderWidth / 2,
          ),
          vertical: BorderSide(
            color: style.borderColor,
            width: style.borderWidth / 4,
          ),
        ),
        color: style.color,
      ),
      child: Center(
        child: DefaultTextStyle(
          textAlign: style.textAlign,
          style: style.textStyle,
          child: child,
        ),
      ),
    );
  }
}
