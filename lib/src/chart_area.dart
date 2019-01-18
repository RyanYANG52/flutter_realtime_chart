import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:flutter_realtime_chart/src/line_series_painter.dart';
import 'package:flutter_realtime_chart/src/models.dart';

class ChartArea extends StatefulWidget {
  final ChartInfo chartInfo;
  final Stream<ChartData> chartDataStream;
  final List<Queue<DataPoint>> dataPointBuffer;
  final double height;

  ChartArea({
    Key key,
    @required this.chartInfo,
    @required this.chartDataStream,
    @required this.height,
  })  : assert(chartInfo?.seriesInfos != null),
        dataPointBuffer = List<Queue<DataPoint>>.generate(
            chartInfo.seriesInfos.length, (_) => Queue<DataPoint>()),
        super(key: key);

  @override
  _ChartAreaState createState() => _ChartAreaState();
}

class _ChartAreaState extends State<ChartArea> {
  @override
  void didUpdateWidget(ChartArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chartInfo == widget.chartInfo) {
      widget.dataPointBuffer.clear();
      widget.dataPointBuffer.addAll(oldWidget.dataPointBuffer);
    }
  }

  void _addPoints(ChartData chartData) {
    double removeTime = chartData.currentTime - widget.chartInfo.timeAxisRange;
    for (var i = 0; i < chartData.points.length; i++) {
      if (widget.dataPointBuffer[i].isNotEmpty &&
          widget.dataPointBuffer[i].last.time > chartData.currentTime) {
        widget.dataPointBuffer[i].clear();
      }
      if (chartData.points[i] != null) {
        widget.dataPointBuffer[i].addAll(chartData.points[i]);
      }
      while (widget.dataPointBuffer[i].isNotEmpty) {
        if (widget.dataPointBuffer[i].first.time < removeTime) {
          widget.dataPointBuffer[i].removeFirst();
        } else {
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var placehoder = Container(height: widget.height,);
    return StreamBuilder<ChartData>(
      stream: widget.chartDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.data.points.length ==
                widget.chartInfo.seriesInfos.length) {
          _addPoints(snapshot.data);
          return RepaintBoundary(
            child: CustomPaint(
              painter: LineSeriesPainter(
                  currentTime: snapshot.data.currentTime,
                  chartInfo: widget.chartInfo,
                  dataPointBuffer: widget.dataPointBuffer),
              child: placehoder,
            ),
          );
        } else {
          return placehoder;
        }
      },
    );
  }
}
