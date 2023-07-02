import 'package:classinsights/screens/classes_screen.dart';
import 'package:classinsights/screens/dashboard_screen.dart';
import 'package:classinsights/screens/profile_screen.dart';
import 'package:classinsights/widgets/custom_appbar.dart';
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
    DashboardScreen(key: Key("DashboardScreen")),
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
      body: Column(
        children: [
          CustomAppBar(
            height: 60,
            title: "HAK/HAS/HLW Landeck",
            index: _currentIndex,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: _currentScreen,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
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
