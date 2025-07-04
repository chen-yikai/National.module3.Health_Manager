import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/action/add_workout.dart';
import 'package:flutter_health_pre_test/screens/workout_detail_screen.dart';

import '../data/share.dart';
import '../data/workout_data.dart';

class ExternalStopwatchFab extends StatefulWidget {
  final bool isRoot;
  final int? id;

  const ExternalStopwatchFab({super.key, required this.isRoot, this.id});

  @override
  State<ExternalStopwatchFab> createState() => _ExternalStopwatchFabState();
}

class _ExternalStopwatchFabState extends State<ExternalStopwatchFab> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: WorkOutData(),
        builder: (context, _) {
          return FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onLongPress: () {
                    if (WorkOutData().timerActive) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkOutDetailScreen(
                                  id: WorkOutData().current_id)));
                    }
                  },
                  child: FloatingActionButton.extended(
                    enableFeedback: true,
                    onPressed: () {
                      if (WorkOutData().timerStarted) {
                        WorkOutData().pauseStopWatch();
                      } else {
                        if (widget.isRoot && !WorkOutData().timerActive) {
                          add_workout(context);
                        } else {
                          WorkOutData().startStopWatch(
                              WorkOutData().current_id != -1
                                  ? WorkOutData().current_id
                                  : widget.id!);
                        }
                      }
                    },
                    icon: Icon(WorkOutData().timerActive
                        ? Icons.pause
                        : widget.isRoot
                            ? Icons.add
                            : Icons.play_arrow),
                    label: Text(WorkOutData().timerActive
                        ? timeFormatter(WorkOutData().stopwatch_count)
                        : widget.isRoot
                            ? "New Workout"
                            : "Start Workout"),
                  ),
                ),
                if (!WorkOutData().timerStarted &&
                    WorkOutData().timerActive) ...[
                  SizedBox(width: 10),
                  FloatingActionButton.small(
                    onPressed: () {},
                    backgroundColor: Colors.redAccent.withAlpha(100),
                    child: Icon(Icons.stop_circle_outlined),
                  ),
                ],
              ],
            ),
          );
        });
  }
}
