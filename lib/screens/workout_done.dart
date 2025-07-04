import 'package:flutter/material.dart';

class WorkoutDone extends StatefulWidget {
  const WorkoutDone({super.key});

  @override
  State<WorkoutDone> createState() => _WorkoutDoneState();
}

class _WorkoutDoneState extends State<WorkoutDone> {
  @override
  void initState() {
    super.initState();
    popBack();
  }

  Future<void> popBack() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.greenAccent, width: 2)),
              child: const Icon(
                Icons.celebration,
                size: 100,
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your done!!!\nCongratulation",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
