import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/action/add_exercise.dart';
import 'package:flutter_health_pre_test/data/exercise_data.dart';
import 'package:flutter_health_pre_test/data/share.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final ExerciseData exerciseData = ExerciseData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addExercise(context);
        },
        label: const Text("Add Exercise"),
        icon: const Icon(Icons.run_circle_outlined),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Expanded(
                  child: ListenableBuilder(
                    listenable: exerciseData,
                    builder: (context, _) {
                      if (exerciseData.exercise_data.isEmpty) {
                        return Center(
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
                                "No exercises yet",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Add your first exercise!",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.arrow_back)),
                                const SizedBox(width: 10),
                                Text("Manage Exercise", style: titleStyle),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: exerciseData.exercise_data.length,
                              itemBuilder: (context, index) {
                                final item = exerciseData.exercise_data[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      final controller = TextEditingController(
                                          text: item.name);
                                      final newName = await showDialog<String>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Rename Exercise'),
                                            content: TextField(
                                              controller: controller,
                                              autofocus: true,
                                              decoration: const InputDecoration(
                                                  labelText: 'New name'),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(controller.text),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (newName != null &&
                                          newName.trim().isNotEmpty) {
                                        exerciseData.renameItem(
                                            item.id, newName.trim());
                                      }
                                    },
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                item.name,
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () => exerciseData
                                                    .deleteItem(item.id),
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
