import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'dart:async';

import 'dart:ui';
import 'fps_calculate.dart';
import 'pv_exception.dart';




Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    //将异常转发至Zone
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  runZoned<Future<Null>>(() async {
    runApp(MyApp());
    orginalCallback = window.onReportTimings;
    window.onReportTimings = onReportTimings;

  }, onError: (error, stackTrace) async {
    //拦截异常
    await reportError(error, stackTrace);
  });
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [
        MyObserver(),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  int startTime;
  int endTime;
  MyHomePage({Key key, this.title}) : startTime = DateTime.now().millisecondsSinceEpoch, super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.endTime = DateTime.now().millisecondsSinceEpoch;
      int timeSpend = widget.endTime - widget.startTime;
      print("Page render time:${timeSpend} ms");
    });
  }

  void _incrementCounter() {
    setState(() {

      _counter++;
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
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
