import 'package:classinsights/providers/screen_provider.dart';
import 'package:classinsights/screens/classes_screen.dart';
import 'package:classinsights/screens/dashboard_screen.dart';
import 'package:classinsights/screens/profile_screen.dart';
import 'package:classinsights/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  var _currentIndex = 0;
  Widget _currentScreen = const DashboardScreen();

  final _screens = const [
    DashboardScreen(key: Key("DashboardScreen")),
    ClassesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    setScreen(int index) => setState(() {
          _currentIndex = index;
          ref.read(screenProvider.notifier).setScreen(Screen.values[index]);
        });

    ref.listen(screenProvider, (_, newScreen) {
      setScreen(Screen.values.indexOf(newScreen));
      setState(() => _currentScreen = _screens[_currentIndex]);
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(
              height: 50,
              title: "HAK/HAS/HLW Landeck",
              index: _currentIndex,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  _currentScreen,
                  const SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
          iconSize: 30.0,
          onTap: setScreen,
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
