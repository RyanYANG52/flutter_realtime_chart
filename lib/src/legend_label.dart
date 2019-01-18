import 'package:flutter/widgets.dart';
import 'models.dart';

class LegendLabel extends StatelessWidget {
  final SeriesInfo seriesInfo;

  const LegendLabel({Key key, @required this.seriesInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 24,
          height: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: seriesInfo.color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(seriesInfo.name),
        ),
      ],
    );
  }
}
