import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/data/exercise_data.dart';
import 'package:flutter_health_pre_test/data/share.dart';

void addExercise(BuildContext context) {
  final nameController = TextEditingController();

  showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                sheetHandle,
                Text("New Exercise", style: titleStyle),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                          child: FilledButton(
                              onPressed: () {
                                ExerciseData().addItem(ExerciseType(
                                    id: DateTime.now().millisecondsSinceEpoch,
                                    name: nameController.text));
                                Navigator.pop(context);
                              },
                              child: Text("Add"))),
                    ],
                  ),
                )
              ],
            ),
          );
        });
      });
}
