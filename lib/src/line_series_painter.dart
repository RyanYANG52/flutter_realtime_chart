import 'dart:collection';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'models.dart';

class LineSeriesPainter extends CustomPainter {
  final double currentTime;
  final ChartInfo chartInfo;
  final List<Queue<DataPoint>> dataPointBuffer;
  LineSeriesPainter({this.currentTime, this.chartInfo, this.dataPointBuffer});

  @override
  void paint(Canvas canvas, Size size) {
    var beginTime = currentTime - chartInfo.timeAxisRange;
    var yRange = chartInfo.curMaxY - chartInfo.curMinY;
    for (var i = 0; i < dataPointBuffer.length; i++) {
      if (dataPointBuffer[i].isEmpty) continue;
      List<Offset> points = [];
      var paint = Paint()
        ..color = chartInfo.seriesInfos[i].color
        ..strokeWidth = 2;
      bool paintFromBeginning = beginTime < 0;
      double previousTime = -1000000;
      for (var dataPoint in dataPointBuffer[i]) {
        if (dataPoint.time >= beginTime && dataPoint.time <= currentTime) {
          if (dataPoint.time > previousTime) {
            previousTime = dataPoint.time;

            var offsetY = size.height -
                ((dataPoint.value - chartInfo.curMinY) / yRange * size.height)
                    .clamp(0.0, size.height);

            var offset = paintFromBeginning
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
