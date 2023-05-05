import 'package:flutter/material.dart';

import './dashboard_screen.dart';
import './chart_screen.dart';
import './monitor_screen.dart';
import './settings_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var _currentIndex = 0;
  Widget _currentScreen = const DashboardScreen();
  final _screens = const [
    DashboardScreen(),
    ChartScreen(),
    MonitorScreen(),
    SettingsScreen(),
  ];

  void _selectPage(int index) => setState(() {
        _currentIndex = index;
        _currentScreen = _screens[index];
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        unselectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onTap: _selectPage,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_rounded),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "",
          ),
        ],
      ),
    );
  }
}
