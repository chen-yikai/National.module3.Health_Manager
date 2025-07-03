import 'package:flutter/material.dart';

class ExerciseData extends ChangeNotifier {
  static final ExerciseData _instance = ExerciseData._internal();

  factory ExerciseData() => _instance;

  ExerciseData._internal();

  List<String> default_exercise = ["羽球", "桌球", "跑步", "慢跑", "游泳", "舉重", "瑜伽", "伏地挺身", "仰臥起坐", "深蹲"];
  List<ExerciseType> _exercise_data = [
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

  List<ExerciseType> get exercise_data => _exercise_data;

  void addItem(ExerciseType item) {
    _exercise_data.add(item);
    notifyListeners();
  }

  void renameItem(int id, String newName) {
    for (var i = 0; i < _exercise_data.length; i++) {
      if (_exercise_data[i].id == id) {
        _exercise_data[i] = ExerciseType(id: id, name: newName);
        notifyListeners();
        break;
      }
    }
  }

  void deleteItem(int id) {
    _exercise_data.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}

class ExerciseType {
  final int id;
  final String name;

  ExerciseType({required this.id, required this.name});
}
