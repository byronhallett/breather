import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.deepOrange,
          scaffoldBackgroundColor: Colors.deepPurple,
          textTheme: TextTheme(display1: TextStyle(color: Colors.white))),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const Duration timerPeriod =
      const Duration(milliseconds: 100); // 0.1 seconds
  static const int fullTime = 1000 * 60 * 5; // 5 mins

  List<int> _inhaleDurations = [];
  List<int> _exhaleDurations = [];
  int _latestDuration = 0;
  int _totalDuration = 0;
  Timer _timer;

  void _updateTimes(Timer timer) {
    // if timer has reached max, cancel the timer
    setState(() {
      _totalDuration = timer.tick * timerPeriod.inMilliseconds;
      _latestDuration += timerPeriod.inMilliseconds;
    });
    if (_totalDuration == fullTime) {
      timer.cancel();
    }
  }

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = new Timer.periodic(timerPeriod, _updateTimes);
  }

  void stopTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = null;
  }

  void _setBreathIn(TapUpDetails tap) {
    if (_totalDuration == fullTime) {
      return;
    }
    // if latest duration is non zero, add it to the exhales
    // if durations are zero, start both timers
    if (_inhaleDurations.length == _exhaleDurations.length &&
        _latestDuration > 0) {
      setState(() {
        _exhaleDurations.add(_latestDuration);
        _latestDuration = 0;
      });
    }
  }

  void _setBreathOut(TapDownDetails tap) {
    if (_totalDuration == fullTime) {
      return;
    }
    // if the latest duration is non zero, add it to the inhales)
    if (_inhaleDurations.length + 1 == _exhaleDurations.length &&
        _latestDuration > 0)
      setState(() {
        _inhaleDurations.add(_latestDuration);
        _latestDuration = 0;
      });
    if (_timer == null) {
      startTimer();
    }
  }

  void _resetState() {
    setState(() {
      _inhaleDurations.clear();
      _exhaleDurations.clear();
      _latestDuration = 0;
      _totalDuration = 0;
      stopTimer();
    });
  }

  int sumFunc(int a, int b) {
    return a + b;
  }

  double computeAverage(List<int> xs) {
    if (xs.length == 0) {
      return 0.0;
    }
    int sum = xs.reduce(sumFunc);
    return sum / xs.length;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    double dur = _totalDuration / 60000;
    if (dur == 0) {
      dur = 1.0;
    }
    double cpm = _inhaleDurations.length / dur;
    double inhales = computeAverage(_inhaleDurations) / 1000;
    double exhales = computeAverage(_exhaleDurations) / 1000;

    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new GestureDetector(
          onTapDown: _setBreathOut,
          onTapUp: _setBreathIn,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'begin with exhale',
                style: Theme.of(context).textTheme.display1,
              ),
              new Text(
                'average inhale: ${inhales.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.display1,
              ),
              new Text(
                'average exhale: ${exhales.toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.display1,
              ),
              new Text(
                'time elapsed: ${(_totalDuration / 1000).toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.display1,
              ),
              new Text(
                '''cycles per minute: 
                ${cpm.toStringAsFixed(1)}''',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: new FloatingActionButton(
        onPressed: _resetState,
        tooltip: 'Increment',
        child: new Icon(Icons.restore),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
