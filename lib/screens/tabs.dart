import 'package:classinsights/screens/classes_screen.dart';
import 'package:classinsights/screens/dashboard_screen.dart';
import 'package:classinsights/screens/profile_screen.dart';
import 'package:flutter/material.dart';

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
    ClassesScreen(),
    ProfileScreen(),
  ];

  void _selectTab(int index) => setState(() {
        _currentIndex = index;
        _currentScreen = _screens[_currentIndex];
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          // padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Text('HAK/HAS/HLW Landeck'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 0.5,
            ),
          ),
        ),
      ),
      body: _currentScreen,
      bottomNavigationBar: BottomNavigationBar(
          onTap: _selectTab,
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.class_outlined),
              label: "Classes",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined),
              label: "Profile",
            ),
          ]),
    );
  }
}
