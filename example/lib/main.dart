import 'package:flutter/material.dart';
import 'package:flutter_realtime_chart/flutter_realtime_chart.dart';
import 'dart:async';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      Data.instance.startTimer(_counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            Card(
              margin: const EdgeInsets.all(24.0),              
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: RealtimeChart(
                  height: 200,
                  chartInfo: Data.instance.chartInfo,
                  chartDataStream: Data.instance.chartDataStream,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Data {
  static Data _instance = Data();
  static Data get instance => _instance;

  static ChartInfo _createChartInfo() {
    List<SeriesInfo> seriesInfos = <SeriesInfo>[
      SeriesInfo(color: Colors.blue, name: "0"),
      SeriesInfo(color: Colors.red, name: "1"),
      SeriesInfo(color: Colors.green, name: "2"),
    ];
    return ChartInfo(
        minY: -10, maxY: 10, seriesInfos: seriesInfos, timeAxisRange: 10);
  }

  final ChartInfo chartInfo;

  StreamController<ChartData> _controller;
  Stream<ChartData> get chartDataStream => _controller.stream;

  Timer _time;

  Data() : chartInfo = _createChartInfo() {
    _controller = StreamController.broadcast();
  }

  void addValue(double time) {
    List<List<DataPoint>> points = [
      [
        DataPoint(time: time - 0.015, value: ((time * 1.3) % 10)),
        DataPoint(time: time - 0.01, value: ((time * 1.3) % 10)),
        DataPoint(time: time - 0.005, value: ((time * 1.3) % 10)),
        DataPoint(time: time, value: ((time * 1.3) % 10)),
      ],
      [DataPoint(time: time, value: (math.sin(time) * 10))],
      [DataPoint(time: time, value: (math.sin(time) * 20))],
    ];
    _controller.add(ChartData(currentTime: time, points: points));
  }

  void startTimer(int count){
    if(count.isOdd){
      _time = Timer.periodic(const Duration(milliseconds: 20), (t){
        double time = t.tick / 50.0;
        addValue(time);
      });
    }else{
      _time?.cancel();
    }
  }
}
