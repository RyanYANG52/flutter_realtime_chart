import 'package:flutter/widgets.dart';
import 'package:flutter_realtime_chart/src/legend_label.dart';
import 'models.dart';

class LegendBox extends StatelessWidget {
  final Iterable<SeriesInfo> seriesInfos;

  LegendBox({Key key, @required this.seriesInfos});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: seriesInfos
          .map((info) => LegendLabel(
                seriesInfo: info,
              ))
          .toList(),
    );
  }
}
