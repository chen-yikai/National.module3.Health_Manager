import 'dart:async';

import 'package:flutter/material.dart';

class WorkOutData extends ChangeNotifier {
  static final WorkOutData _instance = WorkOutData._internal();

  factory WorkOutData() => _instance;

  WorkOutData._internal();

  List<WorkOut> _workout_data = [
    WorkOut(
      id: 20,
      name: "Testing Workout",
      exercise: [
        Exercise(id: 0, name: "羽球", time: 5, level: 2),
        Exercise(id: 1, name: "排球", time: 5, level: 2),
        Exercise(id: 2, name: "桌球", time: 5, level: 2),
        Exercise(id: 3, name: "網球", time: 5, level: 2),
        Exercise(id: 6, name: "跑步", time: 5, level: 2),
        Exercise(id: 4, name: "翻牆", time: 5, level: 5),
        Exercise(id: 5, name: "育華", time: 5, level: 5),
      ],
    )
  ];

  List<WorkOut> get workout_data => _workout_data;

  Timer _stopwatch = Timer(Duration(seconds: 1), () {});
  Timer get stopwatch => _stopwatch;

  bool _timerStarted = false;
  bool get timerStarted => _timerStarted;

  bool _timerActive = false;
  bool get timerActive => _timerActive;

  int _stopwatch_count = 0;
  int get stopwatch_count => _stopwatch_count;

  void startStopWatch() {
    _timerActive = true;
    notifyListeners();
    if (!_timerStarted) {
      _timerStarted = true;
      notifyListeners();
      _stopwatch = Timer.periodic(const Duration(seconds: 1), (time) {
        _stopwatch_count++;
        notifyListeners();
      });
    }
  }

  void pauseStopWatch() {
    _stopwatch.cancel();
    _timerStarted = false;
    notifyListeners();
  }

  void resetStopWatch() {
    _stopwatch.cancel();
    _timerStarted = false;
    _timerActive = false;
    _stopwatch_count = 0;
    notifyListeners();
  }

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

  void addNewItemInWorkout(int id, Exercise exercise) {
    getById(id).exercise.add(exercise);
    notifyListeners();
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
