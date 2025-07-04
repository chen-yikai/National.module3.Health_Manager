import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/data/history_data.dart';
import 'package:flutter_health_pre_test/data/workout_data.dart';

import '../data/share.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: HistoryData().history.length == 0
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "No history yet",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: HistoryData().history.length,
                    itemBuilder: (context, index) {
                      final item = HistoryData().history[index];
                      final time =
                          DateTime.fromMillisecondsSinceEpoch(item.finishTime);
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.5),
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent[100],
                                  borderRadius: BorderRadius.circular(100)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${time.month}/${time.day}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.green),
                                  ),
                                  Text(
                                    "${time.hour}:${time.minute}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      timeFormatter(item.time),
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    Container(
                                      height: 20,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: VerticalDivider(),
                                    ),
                                    Icon(
                                      Icons.directions_run,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 5),
                                    Row(
                                        children: HistoryData()
                                            .getContainExercise(item.id)
                                            .map((item) {
                                      return Container(
                                        child: Text(
                                          item,
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                        margin: EdgeInsets.only(right: 5),
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withAlpha(100),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.grey, width: 1)),
                                      );
                                    }).toList())
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
          ),
        ),
      ),
    );
  }
}
