part of 'common.dart';

typedef AlignmentCallback = void Function(Alignment);

class AlignmentSelector extends StatelessWidget {
  final Alignment selected;
  final AlignmentCallback onChanged;

  const AlignmentSelector({
    Key key,
    @required this.selected,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<Alignment, String> alignments = {
      Alignment.topCenter: 'top center',
      // Alignment.topRight: 'top right',
      Alignment.centerRight: 'center right',
      // Alignment.bottomRight: 'bottom right',
      Alignment.bottomCenter: 'bottom center',
      // Alignment.bottomLeft: 'bottom left',
      Alignment.centerLeft: 'center left',
      // Alignment.topLeft: 'top left',
      Alignment.center: 'center',
    };

    return DropdownButtonFormField<Alignment>(
      decoration: InputDecoration(
        labelText: 'Indicator Alignment',
      ),
      value: selected,
      items: [
        for (final entry in alignments.entries)
          DropdownMenuItem(
            child: Text(entry.value),
            value: entry.key,
          )
      ],
      onChanged: onChanged,
    );
  }
}
