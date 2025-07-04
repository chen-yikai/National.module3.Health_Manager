import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/action/add_exercise.dart';
import 'package:flutter_health_pre_test/data/exercise_data.dart';
import 'package:flutter_health_pre_test/data/workout_data.dart';
import '../data/share.dart';

void add_current_workout_exercise(BuildContext context, int id) {
  int exerciseId = 0;
  int levelId = 3;

  final timeController = TextEditingController();

  List<ExerciseType> exercises = ExerciseData().exercise_data;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return ListenableBuilder(
        listenable: ExerciseData(),
        builder: (context, _) => Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              sheet_handle,
              Text("New Item", style: titleStyle),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: exerciseId,
                          items: exercises
                              .map((item) => DropdownMenuItem<int>(
                                    value: item.id,
                                    child: Text(item.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              exerciseId = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Choose Exercise',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilledButton.tonal(
                        onPressed: () {
                          add_exercise(context);
                        },
                        child: const Icon(Icons.add),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: timeController,
                          decoration: InputDecoration(
                            labelText: "Time (Minutes)",
                            helperText: "Default is 30 minutes",
                            hintText: "30",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: levelId,
                          items: List.generate(
                            5,
                            (item) {
                              final id = item + 1;
                              return DropdownMenuItem(
                                value: id,
                                child: Text(id.toString()),
                              );
                            },
                          ),
                          onChanged: (value) {
                            setState(() {
                              levelId = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Choose Level',
                            helperText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            WorkOutData().addNewItemInWorkout(
                                id,
                                Exercise(
                                    id: DateTime.now().millisecondsSinceEpoch,
                                    name: ExerciseData()
                                        .getExerciseById(exerciseId),
                                    time:
                                        int.tryParse(timeController.text) ?? 30,
                                    level: levelId));
                            Navigator.pop(context);
                          },
                          child: const Text("Add"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }),
  );
}
