import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_health_pre_test/data/share.dart';
import 'package:flutter_health_pre_test/data/workout_data.dart';

class HistoryData extends ChangeNotifier {
  static final HistoryData _instance = HistoryData._internal();

  factory HistoryData() => _instance;

  HistoryData._internal() {
    getHistoryMethod();
  }

  List<History> _history = [];

  List<History> get history => _history;

  bool current_history_init = false;
  History current_history =
      History(id: 0, time: 0, finishTime: 0, name: "", data: []);

  void addCurrent() {
    _history.add(current_history);
    saveHistoryMethod();
    notifyListeners();
  }

  void saveHistoryMethod() {
    try {
      final jsonMap = _history.map((item) => item.toJson()).toList();
      final jsonString = jsonEncode(jsonMap);
      MethodChannel(methodChannelName)
          .invokeMethod("write_history", jsonString);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getHistoryMethod() async {
    try {
      final jsonString = await MethodChannel(methodChannelName)
          .invokeMethod("get_history");
      final json = jsonDecode(jsonString);
      _history.clear();
      _history.addAll((json as List).map((e) => History.fromJson(e)));
      notifyListeners();
    } catch (e) {
      saveHistoryMethod();
      _history.clear();
    }
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

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json['id'],
        time: json['time'],
        finishTime: json['finishTime'],
        name: json['name'],
        data: (json['data'] as List)
            .map((data) => Exercise.fromJson(data))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': time,
        'finishTime': finishTime,
        'name': name,
        'data': data.map((data) => data.toJson()).toList()
      };
}
