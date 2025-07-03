import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/data/share_style.dart';
import 'package:flutter_health_pre_test/data/workout_data.dart';
import 'package:flutter_health_pre_test/data/exercise_data.dart';

void add_workout(BuildContext context) {
  final nameController = TextEditingController();
  final timeController = TextEditingController();
  List<Exercise> selectedExercises = [];
  final exerciseData = ExerciseData();
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: double.infinity,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                sheet_handle,
                Text("New Workout", style: titleStyle),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Workout Name Field
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: "Workout Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Time Field
                        TextField(
                          controller: timeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Duration (minutes)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Exercise Selection
                        Row(
                          children: [
                            Text(
                              "Select Exercises:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: exerciseData.exercise_data.length,
                            itemBuilder: (context, index) {
                              final exercise = exerciseData.exercise_data[index];
                              final isSelected = selectedExercises.any((e) => e.id == exercise.id);
                              
                              return Card(
                                child: CheckboxListTile(
                                  title: Text(exercise.name),
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedExercises.add(Exercise(
                                          id: exercise.id,
                                          name: exercise.name,
                                          type: 1, // Default type
                                          time: 30, // Default time
                                          level: 1, // Default level
                                        ));
                                      } else {
                                        selectedExercises.removeWhere((e) => e.id == exercise.id);
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Add Button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            if (nameController.text.isNotEmpty) {
                              final workout = WorkOut(
                                id: DateTime.now().millisecondsSinceEpoch,
                                name: nameController.text,
                                time: int.tryParse(timeController.text) ?? 0,
                                exercise: selectedExercises,
                              );
                              WorkOutData().add(workout);
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Add Workout"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
