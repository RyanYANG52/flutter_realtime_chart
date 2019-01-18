import 'package:flutter/widgets.dart';
import 'package:flutter_realtime_chart/src/chart_area.dart';
import 'package:flutter_realtime_chart/src/legend_box.dart';
import 'models.dart';

class RealtimeChart extends StatelessWidget {
  final ChartInfo chartInfo;
  final Stream<ChartData> chartDataStream;
  final double chartArarHeight;

  RealtimeChart(
      {Key key,
      @required this.chartInfo,
      @required this.chartDataStream,
      this.chartArarHeight = 150})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget current;
    var chartArea = ChartArea(
      chartInfo: chartInfo,
      chartDataStream: chartDataStream,
      height: chartArarHeight,
    );
    if (!chartInfo.isLegendVisible) {
      current = chartArea;
    } else {
      var legendBox = LegendBox(
        seriesInfos: chartInfo.seriesInfos,
      );
      CrossAxisAlignment crossAxisAlignment =
          CrossAxisAlignment.values[chartInfo.legendBoxAlignment.index];
      var interval = const SizedBox(
        height: 8,
      );
      current = Column(
        crossAxisAlignment: crossAxisAlignment,
        children: chartInfo.legendBoxPosition == LegendBoxPosition.top
            ? [
                legendBox,
                interval,
                chartArea,
              ]
            : [
                chartArea,
                interval,
                legendBox,
              ],
      );
    }
    return current;
  }
}
