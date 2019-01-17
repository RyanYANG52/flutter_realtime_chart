import 'dart:collection';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'models.dart';

class LineSeriesPainter extends CustomPainter {
  final double currentTime;
  final ChartInfo chartInfo;
  final List<Queue<DataPoint>> dataPointBuffer;
  static const double _minIntervalPixel = 0.25;
  LineSeriesPainter({this.currentTime, this.chartInfo, this.dataPointBuffer});

  @override
  void paint(Canvas canvas, Size size) {
    var minTimeInterval = chartInfo.timeAxisRange / size.width * _minIntervalPixel;
    var beginTime = currentTime - chartInfo.timeAxisRange;
    var yRange = chartInfo.maxY - chartInfo.minY;
    for (var i = 0; i < dataPointBuffer.length; i++) {
      if (dataPointBuffer[i].isEmpty) continue;
      List<Offset> points = [];
      var paint = Paint()
        ..color = chartInfo.seriesInfos[i].color
        ..strokeWidth = 2;
      double previousTime = -1000000;
      for (var dataPoint in dataPointBuffer[i]) {
        if (dataPoint.time >= beginTime && dataPoint.time <= currentTime) {
          if (dataPoint.time - previousTime >= minTimeInterval) {
            previousTime = dataPoint.time;

            var offsetY =
                ((dataPoint.value - chartInfo.minY) / yRange * size.height)
                    .clamp(0.0, size.height);

            var offset = beginTime < 0
                ? Offset(dataPoint.time / chartInfo.timeAxisRange * size.width,
                    offsetY)
                : Offset(
                    (dataPoint.time - beginTime) /
                        chartInfo.timeAxisRange *
                        size.width,
                    offsetY);
            points.add(offset);
          }
        }
      }
      canvas.drawPoints(PointMode.polygon, points, paint);
    }
  }

  @override
  bool shouldRepaint(LineSeriesPainter oldDelegate) =>
      currentTime != oldDelegate.currentTime;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}