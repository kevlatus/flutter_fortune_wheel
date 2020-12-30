part of 'bar.dart';

class _FortuneBarItem extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final FortuneItemStyle style;

  const _FortuneBarItem({
    Key key,
    @required this.child,
    @required this.width,
    @required this.height,
    @required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
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
