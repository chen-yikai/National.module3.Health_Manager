import 'package:flutter/cupertino.dart';
import 'package:flutter_health_pre_test/data/workout_data.dart';

class HistoryData extends ChangeNotifier {
  static final HistoryData _instance = HistoryData._internal();

  factory HistoryData() => _instance;

  HistoryData._internal();

  List<History> _history = [];

  List<History> get history => _history;

  bool current_history_init = false;
  History current_history =
      History(id: 0, time: 0, finishTime: 0, name: "", data: []);

  void addCurrent() {
    _history.add(current_history);
    notifyListeners();
  }

  History getHistoryById(int id) {
    return _history.where((item) => item.id == id).first;
  }

  List<String> getContainExercise(int id) {
    List<String> exerciseList = [];
    getHistoryById(id).data.forEach((item) {
      if (!exerciseList.contains(item.name)) {
        exerciseList.add(item.name);
      }
    });
    return exerciseList;
  }
}

class History {
  int id;
  int time;
  int finishTime;
  String name;
  List<Exercise> data;

  History({
    required this.id,
    required this.time,
    required this.finishTime,
    required this.name,
    required this.data,
  });
}
