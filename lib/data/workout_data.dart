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
}

class WorkOut {
  final int id;
  final String name;
  final int time;
  final List<Exercise> exercise;

  WorkOut({
    required this.id,
    required this.name,
    required this.exercise,
    required this.time,
  });
}

class Exercise {
  final int id;
  final String name;
  final int type;
  final int time;
  final int level;

  Exercise(
      {required this.id,
      required this.name,
      required this.type,
      required this.time,
      required this.level});
}
