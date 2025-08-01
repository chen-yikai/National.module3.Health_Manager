import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_health_pre_test/data/exercise_data.dart';
import 'package:flutter_health_pre_test/data/history_data.dart';
import 'package:flutter_health_pre_test/data/workout_data.dart';
import 'package:flutter_health_pre_test/screens/history_screen.dart';
import 'package:flutter_health_pre_test/screens/profile_screen.dart';
import 'package:flutter_health_pre_test/screens/workout_screen.dart';
import 'package:flutter_health_pre_test/widget/external_stopwatch_fab.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const Entry(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Route {
  final String route;
  final String label;
  final IconData icon;

  Route({required this.route, required this.label, required this.icon});
}

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  final List<Route> routes = [
    Route(route: 'profile', label: 'Profile', icon: Icons.person),
    Route(route: 'workout', label: 'Workout', icon: Icons.directions_run),
    Route(route: 'history', label: 'History', icon: Icons.history),
  ];
  int _currentIndex = 1; // Start with workout index
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final List<String> _routeStack = ['workout'];

  @override
  void initState() {
    super.initState();
    HistoryData();
    ExerciseData();
    WorkOutData();
  }

  Widget _buildPage(String route) {
    switch (route) {
      case 'workout':
        return const WorkOutScreen();
      case 'profile':
        return const ProfileScreen();
      case 'history':
        return const HistoryScreen();
      default:
        return const Center(child: Text('404'));
    }
  }

  void _onDestinationSelected(int index) {
    final selectedRoute = routes[index].route;
    if (selectedRoute != _routeStack.last) {
      setState(() {
        _currentIndex = index;
        _routeStack.add(selectedRoute);
      });
      _navigatorKey.currentState?.pushNamed(selectedRoute);
    }
  }

  Future<bool> _onWillPop() async {
    if (_routeStack.length > 1) {
      setState(() {
        _routeStack.removeLast();
        _currentIndex = routes.indexWhere((r) => r.route == _routeStack.last);
      });
      _navigatorKey.currentState?.pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: ExternalStopwatchFab(isRoot: true),
        body: Row(
          children: [
            NavigationRail(
              labelType: NavigationRailLabelType.all,
              destinations: routes.map((route) {
                return NavigationRailDestination(
                  icon: Icon(route.icon),
                  label: Text(route.label),
                );
              }).toList(),
              selectedIndex: _currentIndex,
              onDestinationSelected: _onDestinationSelected,
            ),
            const VerticalDivider(),
            Expanded(
              child: Navigator(
                key: _navigatorKey,
                initialRoute: 'workout', // Start with workout
                onGenerateRoute: (RouteSettings settings) {
                  return PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (context, animation, secondaryAnimation) => _buildPage(settings.name!),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve),
                      );

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 250),
                    reverseTransitionDuration: const Duration(milliseconds: 250),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
