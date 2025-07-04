import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/action/add_workout.dart';
import 'package:flutter_health_pre_test/data/history_data.dart';
import 'package:flutter_health_pre_test/screens/workout_detail_screen.dart';
import 'package:flutter_health_pre_test/screens/workout_done.dart';

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
                          builder: (context) =>
                              WorkOutDetailScreen(id: WorkOutData().current_id),
                        ),
                      );
                    }
                  },
                  child: Hero(
                    tag: 'workout-fab',
                    child: FloatingActionButton.extended(
                      heroTag: null,
                      enableFeedback: true,
                      backgroundColor:
                          widget.isRoot ? null : Colors.greenAccent,
                      onPressed: () {
                        if (WorkOutData().timerStarted) {
                          WorkOutData().pauseStopWatch();
                        } else {
                          if (widget.isRoot && !WorkOutData().timerActive) {
                            add_workout(context);
                          } else {
                            if (!HistoryData().current_history_init) {
                              HistoryData().current_history_init = true;
                              HistoryData().current_history = History(
                                id: DateTime.now().millisecondsSinceEpoch,
                                finishTime: 0,
                                time: 0,
                                name: WorkOutData().getById(widget.id!).name,
                                data: [],
                              );
                            }
                            WorkOutData().startStopWatch(
                                WorkOutData().current_id != -1
                                    ? WorkOutData().current_id
                                    : widget.id!);
                          }
                        }
                      },
                      icon: Icon(WorkOutData().timerActive
                          ? WorkOutData().timerStarted
                              ? Icons.pause
                              : Icons.play_arrow
                          : widget.isRoot
                              ? Icons.directions_run
                              : Icons.play_arrow),
                      label: Text(WorkOutData().timerActive
                          ? timeFormatter(WorkOutData().stopwatch_count)
                          : widget.isRoot
                              ? "New Workout"
                              : "Start Workout"),
                    ),
                  ),
                ),
                if (!WorkOutData().timerStarted &&
                    WorkOutData().timerActive) ...[
                  const SizedBox(width: 10),
                  FloatingActionButton.small(
                    heroTag: widget.isRoot
                        ? 'small-root-fab'
                        : 'small-detail-fab-${widget.id}',
                    onPressed: () {
                      setState(() {
                        WorkOutData().resetStopWatch();
                      });
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) => const WorkoutDone()));
                    },
                    backgroundColor: Colors.redAccent[100],
                    child: const Icon(Icons.stop_circle_outlined),
                  ),
                ],
              ],
            ),
          );
        });
  }
}
