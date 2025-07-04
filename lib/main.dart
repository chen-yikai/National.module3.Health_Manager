import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_health_pre_test/action/add_workout.dart';
import 'package:flutter_health_pre_test/screens/exercise_screen.dart';
import 'package:flutter_health_pre_test/screens/history_screen.dart';
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
    return const MaterialApp(
      home: Entry(),
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
    Route(route: 'workout', label: 'WorkOut', icon: Icons.add_box),
    Route(route: 'exercise', label: 'Exercise', icon: Icons.fitness_center),
    Route(route: 'history', label: 'History', icon: Icons.history),
  ];
  int _currentIndex = 0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final List<String> _routeStack = ['workout'];

  Widget _buildPage(String route) {
    switch (route) {
      case 'workout':
        return const WorkOutScreen();
      case 'exercise':
        return const ExerciseScreen();
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
                initialRoute: routes[0].route,
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (context) => _buildPage(settings.name!),
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
