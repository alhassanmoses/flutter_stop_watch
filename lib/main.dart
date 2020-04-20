import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());
enum MenuChoice {
  Reset,
  Exit,
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _duration = Duration(milliseconds: 1);
  var _startButtonIsPressed = false;
  var _stopButtonIsPressed = true;
  var _displayTime = '00:00:00:00';
  var _stopWatch = Stopwatch();
  Size deviceSize;
  double statusBarHeight;
  double appBarHeight;

//  var _timer = Timer();
  void _onSelectedMenuItem(MenuChoice choice) {}

  void _startTimer() {
    Timer.periodic(_duration, _updateDisplayTimer);
  }

  void _setTimer() {
    if (_stopWatch.isRunning) {
      _startTimer();
    }
  }

  void _updateDisplayTimer(Timer time) {
    setState(() {
      _displayTime = _stopWatch.elapsed.inHours.toString().padLeft(2, '0') +
          ':' +
          (_stopWatch.elapsed.inMinutes % 60).toString().padLeft(2, '0') +
          ':' +
          (_stopWatch.elapsed.inSeconds % 60).toString().padLeft(2, '0') +
          ':' +
          (_stopWatch.elapsed.inMilliseconds % 60).toString().padLeft(2, '0');
    });
  }

  void _buttonPressed() {
    setState(() {
      _startButtonIsPressed = !_startButtonIsPressed;
      _stopButtonIsPressed = !_stopButtonIsPressed;
    });
    if (_startButtonIsPressed) {
      _stopWatch.start();
    } else if (_stopButtonIsPressed) {
      _stopWatch.stop();
    }
    _setTimer();
  }

  Widget _buildTimerCard() {
    return Card(
      color: Color(0xffddeaf3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 8.0,
      child: Container(
        constraints: BoxConstraints(minHeight: deviceSize.height * 0.2),
        width: deviceSize.width * 0.85,
        padding: EdgeInsets.all(10.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Color(0xffc7cfc1),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: Color(0xffa8a8a8),
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Text(
                _displayTime,
                style: TextStyle(
                    fontFamily: 'Digital-Dismay',
                    fontSize: deviceSize.width * 0.15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleLoaderAndStartButton() {
    return Container(
      height: deviceSize.height * 0.5,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: deviceSize.width * 0.1,
            top: deviceSize.height * 0.001,
            child: Container(
              height: deviceSize.height * 0.5,
              width: deviceSize.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 10,
                  color: Colors.white,
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.black12,
//                    Color(0xffc7d2db),
//                    Color(0xfff3f7fb),
                    Colors.white30,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 0.6],
                ),
              ),
            ),
          ),
          Positioned(
            left: deviceSize.width * 0.26,
            top: deviceSize.height * 0.1,
            child: Container(
              height: deviceSize.height * 0.3,
              width: deviceSize.width * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 10,
                  color: Colors.white,
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.black12,
//                    Color(0xffc7d2db),
//                    Color(0xfff3f7fb),
                    Colors.white30,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 0.6],
                ),
              ),
            ),
          ),
          Positioned(
            left: deviceSize.width * 0.4,
            top: deviceSize.height * 0.18,
            child: Card(
              elevation: 8.0,
              color:
                  _stopButtonIsPressed ? Color(0xffe2f6e4) : Color(0xffddeaf3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: GestureDetector(
                child: Icon(
                  _stopButtonIsPressed ? Icons.play_arrow : Icons.stop,
                  size: deviceSize.width * 0.2,
                  color: _stopButtonIsPressed
                      ? Color(0xff00f66c)
                      : Color(0xfff97277),
                ),
                onTap: _buttonPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetStopWatch() {
    _stopWatch.reset();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    statusBarHeight = MediaQuery.of(context).padding.top;
    appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffddeaf3),
        title: Text(
          'Timer',
          style: TextStyle(
            color: Color(0xff294768),
            fontSize: 24.0,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (MenuChoice choice) => setState(() {
              if (choice == MenuChoice.Reset) {
                _resetStopWatch();
              } else {
                exit(0);
              }
            }),
            icon: Icon(
              Icons.menu,
              color: Colors.black12,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Reset'),
                value: MenuChoice.Reset,
              ),
              PopupMenuItem(
                child: Text('Exit'),
                value: MenuChoice.Exit,
              ),
            ],
          )
        ],
      ),
      body: Container(
        color: Color(0xffe3f1fb),
        height: deviceSize.height - statusBarHeight - appBarHeight,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildTimerCard(),
            _buildCircleLoaderAndStartButton(),
            GestureDetector(
              child: Container(
                width: deviceSize.width * 0.9,
                height: deviceSize.height * 0.1,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 8.0,
                  color: Color(0xffe3f1fb),
                  child: Center(
                      child: Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: deviceSize.width * 0.06,
                      fontFamily: 'Roboto-Condensed',
                      fontWeight: FontWeight.bold,
                      color: Color(0xff294768),
                    ),
                  )),
                ),
              ),
              onTap: _resetStopWatch,
            ),
          ],
        ),
      ),
    );
  }
}
