import 'package:flutter/material.dart';

class WorkOutData extends ChangeNotifier {
  static final WorkOutData _instance = WorkOutData._internal();

  factory WorkOutData() => _instance;

  WorkOutData._internal();

  List<WorkOut> _workout_data = [];

  List<WorkOut> get workout_data => _workout_data;

  void add(WorkOut item) {
    _workout_data.add(item);
    notifyListeners();
  }

  void removeAt(int id) {
    _workout_data.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateRecord(WorkOut workout) {
    final index = _workout_data.indexWhere((item) => item.id == workout.id);
    if (index != -1) {
      _workout_data[index] = workout;
      notifyListeners();
    }
  }

  WorkOut getById(int id) {
    return _workout_data.where((item) => item.id == id).first;
  }

  int getTotalTime(int id) {
    int totalTime = 0;
    getById(id).exercise.forEach((item) => totalTime += item.time);
    return totalTime;
  }

  List<String> getContainExerciseOf(int id) {
    List<String> typeList = [];
    getById(id).exercise.forEach((item) =>
        !typeList.contains(item.name) ? typeList.add(item.name) : null);
    return typeList;
  }
}

class WorkOut {
  final int id;
  final String name;
  final List<Exercise> exercise;

  WorkOut({
    required this.id,
    required this.name,
    required this.exercise,
  });
}

class Exercise {
  final int id;
  final String name;
  final int time;
  final int level;

  Exercise(
      {required this.id,
      required this.name,
      required this.time,
      required this.level});
}
