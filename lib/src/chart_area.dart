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

  void _restoreDefaultYAxis() {
    widget.chartInfo.curMinY = widget.chartInfo.minY;
    widget.chartInfo.curMaxY = widget.chartInfo.maxY;
    print('restore default y ${widget.chartInfo.minY} ${widget.chartInfo.maxY}');
  }

  void _autoYAxis() {
    var minY = double.infinity;
    var maxY = double.negativeInfinity;
    for (var i = 0; i < widget.dataPointBuffer.length; i++) {
      for (var dataPoint in widget.dataPointBuffer[i]) {
        if (dataPoint.value > maxY) {
          maxY = dataPoint.value;
        }
        if (dataPoint.value < minY) {
          minY = dataPoint.value;
        }
      }
    }
    print('auto default y $minY $maxY');
    if (minY >= maxY) {
      minY = widget.chartInfo.minY;
      maxY = widget.chartInfo.maxY;
    }
    widget.chartInfo.curMinY = minY;
    widget.chartInfo.curMaxY = maxY;
  }

  @override
  Widget build(BuildContext context) {
    var placehoder = Container(
      height: widget.height,
    );
    return GestureDetector(
      onDoubleTap: _autoYAxis,
      onLongPress: _restoreDefaultYAxis,
      child: StreamBuilder<ChartData>(
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
      ),
    );
  }
}
