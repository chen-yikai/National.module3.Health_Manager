import 'package:flutter/material.dart';

const TextStyle titleStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

Widget sheetHandle = Padding(
  padding: const EdgeInsets.all(10),
  child: Container(
    width: 70,
    height: 10,
    decoration: BoxDecoration(
        color: Colors.grey, borderRadius: BorderRadius.circular(10)),
  ),
);

const double maxScreenWidth = 800;

String timeFormatter(int seconds) {
  final mm = seconds ~/ 60;
  final ss = seconds % 60;
  return "${mm.toString().padLeft(2, '0')}:${ss.toString().padLeft(2, '0')}";
}

const String methodChannelName = "com.example.flutter_health_pre_test/method";
