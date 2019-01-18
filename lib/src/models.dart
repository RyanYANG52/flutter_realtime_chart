import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class DataPoint {
  final double time;
  final double value;
  DataPoint({@required this.time, @required this.value});
}

class ChartData {
  final double currentTime;
  final List<Iterable<DataPoint>> points;
  ChartData({@required this.currentTime, @required this.points});
}

class SeriesInfo {
  final String name;
  final Color color;
  SeriesInfo({@required this.name, @required this.color});
}

class ChartInfo {
  final double timeAxisRange;
  final List<SeriesInfo> seriesInfos;
  final double minY;
  final double maxY;
  final bool isLegendVisible;
  final LegendBoxPosition legendBoxPosition;
  final LegendBoxAlignment legendBoxAlignment;

  ChartInfo({
    @required this.timeAxisRange,
    @required this.seriesInfos,
    @required this.minY,
    @required this.maxY,
    this.isLegendVisible = true,
    this.legendBoxPosition = LegendBoxPosition.bottom,
    this.legendBoxAlignment = LegendBoxAlignment.start,
  });
}

enum LegendBoxPosition {
  top,
  bottom,
}

enum LegendBoxAlignment {
  start,
  end,
  center,
}
