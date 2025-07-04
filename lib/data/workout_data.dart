import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_health_pre_test/data/history_data.dart';
import 'package:flutter_health_pre_test/data/share.dart';

class WorkOutData extends ChangeNotifier {
  static final WorkOutData _instance = WorkOutData._internal();

  factory WorkOutData() => _instance;

  WorkOutData._internal() {
    getWorkoutMethod();
  }

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

  int _current_id = -1;

  int get current_id => _current_id;

  Future<void> saveWorkoutMethod() async {
    try {
      final jsonMap = _workout_data.map((item) => item.toJson()).toList();
      final jsonString = jsonEncode(jsonMap);
      await MethodChannel(method_channel_name)
          .invokeMethod("write_workout", jsonString);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getWorkoutMethod() async {
    try {
      final jsonString =
          await MethodChannel(method_channel_name).invokeMethod("get_workout");
      final jsonMap = jsonDecode(jsonString);
      _workout_data =
          (jsonMap as List).map((item) => WorkOut.fromJson(item)).toList();
    } catch (e) {
      _workout_data = [];
      saveWorkoutMethod();
    }
    notifyListeners();
  }

  void startStopWatch(int id) {
    _timerActive = true;
    _current_id = id;
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
    HistoryData().current_history.time = _stopwatch_count;
    HistoryData().current_history.finishTime =
        DateTime.now().millisecondsSinceEpoch;
    HistoryData().addCurrent();
    HistoryData().current_history =
        History(id: 0, finishTime: 0, time: 0, name: "", data: []);
    HistoryData().current_history_init = false;
    _timerStarted = false;
    _timerActive = false;
    _current_id = -1;
    _stopwatch_count = 0;
    notifyListeners();
  }

  void add(WorkOut item) {
    _workout_data.add(item);
    saveWorkoutMethod();
    notifyListeners();
  }

  void removeAt(int id) {
    _workout_data.removeWhere((item) => item.id == id);
    saveWorkoutMethod();
    notifyListeners();
  }

  void updateRecord(WorkOut workout) {
    final index = _workout_data.indexWhere((item) => item.id == workout.id);
    if (index != -1) {
      _workout_data[index] = workout;
      saveWorkoutMethod();
      notifyListeners();
    }
  }

  void addNewItemInWorkout(int id, Exercise exercise) {
    getById(id).exercise.add(exercise);
    saveWorkoutMethod();
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

  factory WorkOut.fromJson(Map<String, dynamic> json) => WorkOut(
      id: json['id'],
      name: json['name'],
      exercise: (json['exercise'] as List)
          .map((item) => Exercise.fromJson(item))
          .toList());

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'exercise': exercise};
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

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
      id: json['id'],
      name: json['name'],
      time: json['time'],
      level: json['level']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'time': time, 'level': level};
}
