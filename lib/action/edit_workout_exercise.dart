import 'package:flutter/material.dart';

import '../data/workout_data.dart';

void edit_workout_exercise(
    Exercise exercise, WorkOut workOut, int index, BuildContext context) {
  final nameController = TextEditingController(text: exercise.name);
  final timeController = TextEditingController(text: exercise.time.toString());
  final levelController =
      TextEditingController(text: exercise.level.toString());

  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => AlertDialog(
        title: const Text('Edit Exercise'),
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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
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
  );
}
