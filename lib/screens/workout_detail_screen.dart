import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/action/add_current_workout_item.dart';
import 'package:flutter_health_pre_test/action/edit_workout_exercise.dart';
import 'package:flutter_health_pre_test/data/share.dart';
import 'package:flutter_health_pre_test/data/workout_data.dart';
import 'package:flutter_health_pre_test/widget/external_stopwatch_fab.dart';

class WorkOutDetailScreen extends StatefulWidget {
  final int id;

  const WorkOutDetailScreen({super.key, required this.id});

  @override
  State<WorkOutDetailScreen> createState() => _WorkOutDetailScreenState();
}

class _WorkOutDetailScreenState extends State<WorkOutDetailScreen> {
  WorkOut? workOut;
  var load = false;
  var hasError = false;

  @override
  void initState() {
    super.initState();
    try {
      workOut = WorkOutData().getById(widget.id);
      setState(() {
        load = true;
      });
    } catch (e) {
      setState(() {
        load = false;
      });
    }
  }

  void _reorderExercises(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final exercise = workOut!.exercise.removeAt(oldIndex);
      workOut!.exercise.insert(newIndex, exercise);
      WorkOutData().updateRecord(workOut!);
    });
  }

  void _deleteExercise(int index) {
    setState(() {
      workOut!.exercise.removeAt(index);
      WorkOutData().updateRecord(workOut!);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exercise removed from workout'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, String exerciseName) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Exercise'),
            content: const Text('Are you sure?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ListenableBuilder(
          listenable: WorkOutData(),
          builder: (context, _) {
            return FittedBox(
              child: Row(
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      add_current_workout_exercise(context, widget.id);
                    },
                    icon: const Icon(Icons.directions_run),
                    label: const Text("Add Item"),
                  ),
                  const SizedBox(width: 20),
                  ExternalStopwatchFab(isRoot: false, id: widget.id)
                ],
              ),
            );
          }),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: !load
                ? const Center(
                    child: Text("error"),
                  )
                : ListenableBuilder(
                    listenable: WorkOutData(),
                    builder: (context, _) => Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back)),
                            const SizedBox(width: 10),
                            Text(
                              workOut!.name,
                              style: titleStyle,
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.grey,
                                width: 1), // border color and thickness
                            borderRadius: BorderRadius.circular(
                                10), // optional rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.timer,
                                      size: 30,
                                      color: Colors.blueAccent,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Total Time"),
                                    Text(
                                      "${WorkOutData().getTotalTime(widget.id)} min",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 100,
                                  child: VerticalDivider(),
                                ),
                                Column(
                                  children: [
                                    const Icon(
                                      Icons.fitness_center,
                                      size: 30,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Exercise"),
                                    Text(
                                      WorkOutData()
                                          .getContainExerciseOf(widget.id)
                                          .length
                                          .toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: workOut!.exercise.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "No exercises in this workout",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ReorderableListView.builder(
                                  itemBuilder: (context, index) {
                                    final exercise = workOut!.exercise[index];
                                    return Container(
                                      key: ValueKey(exercise.id),
                                      margin: EdgeInsets.only(
                                          bottom: workOut!.exercise.length ==
                                                  index + 1
                                              ? 100
                                              : 0),
                                      child: Dismissible(
                                        key: ValueKey(exercise.id),
                                        background: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Edit',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        secondaryBackground: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          alignment: Alignment.centerRight,
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                            ],
                                          ),
                                        ),
                                        confirmDismiss: (direction) async {
                                          if (direction ==
                                              DismissDirection.startToEnd) {
                                            edit_workout_exercise(exercise,
                                                workOut!, index, context);
                                            return false;
                                          } else if (direction ==
                                              DismissDirection.endToStart) {
                                            return await _confirmDelete(
                                                context, exercise.name);
                                          }
                                          return false;
                                        },
                                        onDismissed: (direction) {
                                          if (direction ==
                                              DismissDirection.endToStart) {
                                            _deleteExercise(index);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            clipBehavior: Clip.antiAlias,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Row(
                                                  children: [
                                                    // Exercise number
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue[100],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "${index + 1}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .blue[700],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    // Exercise details
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            exercise.name,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 4),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.timer,
                                                                size: 14,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                "${exercise.time} min",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 16),
                                                              Icon(
                                                                Icons
                                                                    .local_fire_department,
                                                                size: 14,
                                                                color: Colors
                                                                        .orange[
                                                                    600],
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                "Level ${exercise.level}",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Drag handle
                                                    Icon(
                                                      Icons.drag_handle,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: workOut!.exercise.length,
                                  onReorder: (oldIndex, newIndex) {
                                    _reorderExercises(oldIndex, newIndex);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
