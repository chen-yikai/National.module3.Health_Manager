import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_health_pre_test/data/share.dart';

class ExerciseData extends ChangeNotifier {
  static final ExerciseData _instance = ExerciseData._internal();

  factory ExerciseData() => _instance;

  ExerciseData._internal() {
    getExerciseMethod();
  }

  final List<ExerciseType> _default_exercise_type = [
    ExerciseType(id: 0, name: "羽球"),
    ExerciseType(id: 1, name: "桌球"),
    ExerciseType(id: 2, name: "跑步"),
    ExerciseType(id: 3, name: "慢跑"),
    ExerciseType(id: 4, name: "游泳"),
    ExerciseType(id: 5, name: "舉重"),
    ExerciseType(id: 6, name: "瑜伽"),
    ExerciseType(id: 7, name: "伏地挺身"),
    ExerciseType(id: 8, name: "仰臥起坐"),
    ExerciseType(id: 9, name: "深蹲"),
  ];

  List<ExerciseType> _exercise_data = [];

  List<ExerciseType> get exercise_data => _exercise_data;

  void writeExerciseMethod() {
    try {
      final dataMap = _exercise_data.map((item) => item.toJson()).toList();
      final jsonString = jsonEncode(dataMap);

      MethodChannel(method_channel_name)
          .invokeMethod("write_exercise", jsonString);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getExerciseMethod() async {
    try {
      final jsonString = await const MethodChannel(method_channel_name)
          .invokeMethod("get_exercise");
      final jsonData = jsonDecode(jsonString);
      _exercise_data.clear();
      _exercise_data.addAll(
          (jsonData as List).map((item) => ExerciseType.fromJson(item)));
    } catch (e) {
      _exercise_data.clear();
      _exercise_data = _default_exercise_type;
      writeExerciseMethod();
    }
    notifyListeners();
  }

  void addItem(ExerciseType item) {
    _exercise_data.add(item);
    writeExerciseMethod();
    notifyListeners();
  }

  void renameItem(int id, String newName) {
    for (var i = 0; i < _exercise_data.length; i++) {
      if (_exercise_data[i].id == id) {
        _exercise_data[i] = ExerciseType(id: id, name: newName);
        writeExerciseMethod();
        notifyListeners();
        break;
      }
    }
  }

  void deleteItem(int id) {
    _exercise_data.removeWhere((item) => item.id == id);
    writeExerciseMethod();
    notifyListeners();
  }

  String getExerciseById(int id) {
    return _exercise_data.where((item) => item.id == id).first.name;
  }
}

class ExerciseType {
  final int id;
  final String name;

  ExerciseType({required this.id, required this.name});

  factory ExerciseType.fromJson(Map<String, dynamic> json) =>
      ExerciseType(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
