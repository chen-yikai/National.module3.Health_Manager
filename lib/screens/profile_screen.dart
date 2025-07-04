import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/data/share.dart';

import '../action/open_exercise_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Recent Exercise Status", style: titleStyle),
                  ],
                ),
                Container(
                  height: 400,
                  color: Colors.greenAccent,
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Your Profile", style: titleStyle),
                  ],
                ),
                SizedBox(height: 10),
                ListTile(
                    title: const Row(
                      children: [
                        Icon(
                          Icons.run_circle_outlined,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Text("Manage Exercise"),
                      ],
                    ),
                    onTap: () {
                      open_exercise_manager(context);
                    }),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
