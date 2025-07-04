import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/screens/exercise_screen.dart';
import 'package:flutter_health_pre_test/utils/page_transitions.dart';

void openExerciseManager(context) {
  Navigator.of(context, rootNavigator: true)
      .push(PageTransitions.slideTransition(ExerciseScreen()));
}
