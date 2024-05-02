import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:volume_watcher/volume_watcher.dart';

class StopwatchApp extends StatefulWidget {
  @override
  _StopwatchAppState createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp> {
  Stopwatch _stopwatch = Stopwatch();
  List<String> _laps = [];
  String _displayTime = '00:00.000';

  void _startStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      setState(() {});
    } else {
      _stopwatch.start();
      Timer.periodic(Duration(milliseconds: 30), (Timer t) {
        setState(() {
          _displayTime = _stopwatch.elapsed.inMinutes
                  .toString()
                  .padLeft(2, '0')
                  .toString() +
              ':' +
              _stopwatch.elapsed.inSeconds
                  .remainder(60)
                  .toString()
                  .padLeft(2, '0')
                  .toString() +
              '.' +
              _stopwatch.elapsed.inMilliseconds
                  .remainder(1000)
                  .toString()
                  .padLeft(3, '0');
        });
      });
    }
  }

  void _resetStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      setState(() {});
    }
    _stopwatch.reset();
    _laps = [];
    setState(() {
      _displayTime = '00:00.000';
    });
  }

  void _lapStopwatch() {
    final lapTime = _stopwatch.elapsed;
    final lapDisplay =
        '${lapTime.inMinutes.toString().padLeft(2, '0')}:${lapTime.inSeconds.toString().padLeft(2, '0')}.${lapTime.inMilliseconds.toString().padLeft(3, '0')}';
    _laps.add(lapDisplay);
    setState(() {});
  }

  double currentVolume = 0.0;

  @override
  void initState() {
    super.initState();
    VolumeWatcher.addListener((volume) {
      setState(() {
        currentVolume = volume;
        if (currentVolume != previousVolume) {
          _lapStopwatch();
        }

        previousVolume = currentVolume;
      });
    });
  }

  double previousVolume = 0.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.primaryColor,
        title: const Center(
          child: Text(
            'Stopwatch',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Center(
              child: Text(
                _displayTime,
                style: const TextStyle(
                  fontSize: 60,
                ),
              ),
            ),
            Container(
              height: 400.0,
              decoration: BoxDecoration(
                color: Colors.deepPurple[50],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListView.builder(
                itemCount: _laps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Lap ${index + 1}",
                              style: TextStyle(
                                color: themeData.primaryColor,
                                fontSize: 16.0,
                              ),
                            ),
                            Spacer(
                              flex: 3,
                            ),
                            Spacer(
                              flex: 3,
                            ),
                            Spacer(
                              flex: 8,
                            ),
                            Spacer(
                              flex: 8,
                            ),
                            Text(
                              _laps[index],
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        Divider(
                          height: 1,
                          color: Colors.purple[200],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startStopwatch,
                  child: Icon(
                      _stopwatch.isRunning ? Icons.stop : Icons.play_arrow),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _resetStopwatch,
                  child: Icon(Icons.restore),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _lapStopwatch,
                  child: Icon(Icons.flag),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
