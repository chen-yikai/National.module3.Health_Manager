import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/screens/exercise_screen.dart';

void open_exercise_manager(context) {
  Navigator.of(context, rootNavigator: true)
      .push(MaterialPageRoute(builder: (context) => ExerciseScreen()));
}
