import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Progress Bar'),
        ),
        body: Center(
            child: ChangeNotifierProvider<TimeState>(
          create: (context) => TimeState(),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Consumer<TimeState>(
                    builder: (context, timeState, _) => CustomProgressBar(
                        width: 200, value: timeState.time, totalValue: 15)),
                const SizedBox(
                  height: 10,
                ),
                Consumer<TimeState>(
                  builder: (context, timeState, _) => TextButton(
                    onPressed: () {
                      Timer.periodic(const Duration(seconds: 1), (timer) {
                        if (timeState.time < 1) {
                          timer.cancel();
                        } else {
                          timeState.time -= 1;
                        }
                      });
                    },
                    child: const Text(
                      "Start",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightBlue)),
                  ),
                )
              ]),
        )),
      ),
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  final double width;
  final int value;
  final int totalValue;

  CustomProgressBar({this.width, this.value, this.totalValue});

  @override
  Widget build(BuildContext context) {
    double ratio = value / totalValue;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.timer, color: Colors.grey[700]),
        const SizedBox(
          width: 5,
        ),
        Stack(
          children: <Widget>[
            Container(
              width: width,
              height: 10,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5)),
            ),
            Material(
              borderRadius: BorderRadius.circular(5),
              elevation: 3,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: 10,
                width: width * ratio,
                decoration: BoxDecoration(
                    color: (ratio < 0.3)
                        ? Colors.red
                        : (ratio < 0.6)
                            ? Colors.amber[400]
                            : Colors.lightGreen,
                    borderRadius: BorderRadius.circular(5)),
              ),
            )
          ],
        )
      ],
    );
  }
}

class TimeState with ChangeNotifier {
  int _time = 15;

  int get time => _time;

  set time(int newTime) {
    _time = newTime;
    notifyListeners();
  }
}
