import 'package:flutter/material.dart';

import '../data/workout_data.dart';
import '../data/share.dart';

void edit_workout_exercise(
    Exercise exercise, WorkOut workOut, int index, BuildContext context) {
  final nameController = TextEditingController(text: exercise.name);
  final timeController = TextEditingController(text: exercise.time.toString());
  final levelController = TextEditingController(text: exercise.level.toString());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Edit Exercise", style: titleStyle),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    workOut!.exercise[index] = Exercise(
                      id: exercise.id,
                      name: nameController.text.trim(),
                      time: int.tryParse(timeController.text) ?? exercise.time,
                      level: int.tryParse(levelController.text) ?? exercise.level,
                    );
                    WorkOutData().updateRecord(workOut);

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Exercise updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
