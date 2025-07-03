import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/data/share_style.dart';
import 'package:flutter_health_pre_test/data/workout_data.dart';

class WorkOutProgressScreen extends StatefulWidget {
  final int id;

  const WorkOutProgressScreen({super.key, required this.id});

  @override
  State<WorkOutProgressScreen> createState() => _WorkOutProgressScreenState();
}

class _WorkOutProgressScreenState extends State<WorkOutProgressScreen> {
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
        hasError = true;
        load = true;
      });
    }
  }

  // Reorder exercises
  void _reorderExercises(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final exercise = workOut!.exercise.removeAt(oldIndex);
      workOut!.exercise.insert(newIndex, exercise);
      
      // Update the workout in data storage
      WorkOutData().updateRecord(workOut!);
    });
  }

  // Delete exercise
  void _deleteExercise(int index) {
    setState(() {
      workOut!.exercise.removeAt(index);
      
      // Update the workout in data storage
      WorkOutData().updateRecord(workOut!);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exercise removed from workout'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // You could implement undo functionality here
          },
        ),
      ),
    );
  }

  // Edit exercise
  void _editExercise(Exercise exercise, int index) {
    final nameController = TextEditingController(text: exercise.name);
    final timeController = TextEditingController(text: exercise.time.toString());
    final levelController = TextEditingController(text: exercise.level.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Exercise'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Exercise Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Duration (minutes)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: levelController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Level (1-5)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  workOut!.exercise[index] = Exercise(
                    id: exercise.id,
                    name: nameController.text.trim(),
                    time: int.tryParse(timeController.text) ?? exercise.time,
                    level: int.tryParse(levelController.text) ?? exercise.level,
                  );
                  
                  // Update the workout in data storage
                  WorkOutData().updateRecord(workOut!);
                });
                
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Exercise updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // Confirm delete dialog
  Future<bool> _confirmDelete(BuildContext context, String exerciseName) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Exercise'),
        content: Text('Are you sure you want to remove "$exerciseName" from this workout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: load
              ? hasError || workOut == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Workout not found",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Go Back"),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back)),
                            SizedBox(width: 10),
                            Text(
                              workOut!.name,
                              style: titleStyle,
                            )
                          ],
                        ),
                        Divider(),
                        SizedBox(height: 10),
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
                                    Icon(
                                      Icons.timer,
                                      size: 30,
                                      color: Colors.blueAccent,
                                    ),
                                    SizedBox(height: 10),
                                    Text("Total Time"),
                                    Text(
                                      WorkOutData()
                                              .getTotalTime(widget.id)
                                              .toString() +
                                          " min",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 100,
                                  child: VerticalDivider(),
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.fitness_center,
                                      size: 30,
                                      color: Colors.green,
                                    ),
                                    SizedBox(height: 10),
                                    Text("Exercise"),
                                    Text(
                                      WorkOutData()
                                          .getContainExerciseOf(widget.id)
                                          .length
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
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
                                    return Dismissible(
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
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            const SizedBox(width: 8),
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
                                        child: Row(
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
                                            const SizedBox(width: 8),
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
                                          // Swipe left to right - Edit
                                          _editExercise(exercise, index);
                                          return false; // Don't dismiss
                                        } else if (direction ==
                                            DismissDirection.endToStart) {
                                          // Swipe right to left - Delete
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
                                          elevation: 2,
                                          borderRadius: BorderRadius.circular(10),
                                          clipBehavior: Clip.antiAlias,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Row(
                                                children: [
                                                // Exercise number
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "${index + 1}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.blue[700],
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
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
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
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[600],
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
                                                                .orange[600],
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          Text(
                                                            "Level ${exercise.level}",
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[600],
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
                                    );
                                  },
                                  itemCount: workOut!.exercise.length,
                                  onReorder: (oldIndex, newIndex) {
                                    _reorderExercises(oldIndex, newIndex);
                                  },
                                ),
                        ),
                      ],
                    )
              : SizedBox(),
        ),
      ),
    ));
  }
}
