import 'package:flutter/material.dart';
import 'package:flutter_health_pre_test/data/share.dart';
import 'package:flutter_health_pre_test/painter/line_chart_painter.dart';
import 'package:flutter_health_pre_test/painter/bar_chart_painter.dart';

import '../action/open_exercise_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    
    // Start animation when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
    
    // Restart animation when tab changes
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<double> _getWeeklyWorkoutData() {
    return [45, 60, 30, 75, 50, 90, 65];
  }

  List<String> _getWeeklyLabels() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Recent Exercise Status", style: titleStyle),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.green[700],
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.greenAccent,
                        tabs: const [
                          Tab(text: 'Line Chart', icon: Icon(Icons.show_chart)),
                          Tab(text: 'Bar Chart', icon: Icon(Icons.bar_chart)),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return CustomPaint(
                                    painter: LineChartPainter(
                                      data: _getWeeklyWorkoutData(),
                                      labels: _getWeeklyLabels(),
                                      lineColor: Colors.green,
                                      pointColor: Colors.greenAccent,
                                      animationValue: _animation.value,
                                    ),
                                    size: Size.infinite,
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return CustomPaint(
                                    painter: BarChartPainter(
                                      data: _getWeeklyWorkoutData(),
                                      labels: _getWeeklyLabels(),
                                      barColor: Colors.greenAccent,
                                      animationValue: _animation.value,
                                    ),
                                    size: Size.infinite,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text("Your Profile", style: titleStyle),
                  ],
                ),
                const SizedBox(height: 10),
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
                      openExerciseManager(context);
                    }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
