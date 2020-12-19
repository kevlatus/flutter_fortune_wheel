part of 'bar.dart';

class _FortuneBarItem extends StatelessWidget {
  final double width;
  final double height;
  final FortuneItem item;

  const _FortuneBarItem({
    Key key,
    @required this.item,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fillColor = item.color ??
        Color.alphaBlend(
          theme.primaryColor.withOpacity(0.4),
          theme.colorScheme.surface,
        );
    final borderColor = item.borderColor ?? theme.primaryColor;
    final borderWidth = item.borderWidth ?? 4;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: borderColor,
            width: borderWidth / 2,
          ),
          vertical: BorderSide(
            color: borderColor,
            width: borderWidth / 4,
          ),
        ),
        color: fillColor,
      ),
      child: Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyle(color: theme.colorScheme.onSurface),
          child: item.child,
        ),
      ),
    );
  }
}
