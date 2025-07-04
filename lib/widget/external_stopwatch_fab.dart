import 'package:flutter/material.dart';

import '../data/share.dart';
import '../data/workout_data.dart';

class ExternalStopwatchFab extends StatefulWidget {
  final bool isRoot;

  const ExternalStopwatchFab({super.key, required this.isRoot});

  @override
  State<ExternalStopwatchFab> createState() => _ExternalStopwatchFabState();
}

class _ExternalStopwatchFabState extends State<ExternalStopwatchFab> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        if (widget.isRoot) {
        } else {
          if (WorkOutData().timerStarted) {
            WorkOutData().pauseStopWatch();
          } else {
            WorkOutData().startStopWatch();
          }
        }
      },
      icon: Icon(
          WorkOutData().stopwatch.isActive ? Icons.pause : Icons.play_arrow),
      label: Text(WorkOutData().timerActive
          ? timeFormatter(WorkOutData().stopwatch_count)
          : "Start Workout"),
    );
  }
}
