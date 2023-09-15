import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/screen_provider.dart';
import 'package:classinsights/providers/theme_provider.dart';
import 'package:classinsights/screens/login_screen.dart';
import 'package:classinsights/screens/room_overview_screen.dart';
import 'package:classinsights/screens/dashboard_screen.dart';
import 'package:classinsights/screens/profile_screen.dart';
import 'package:classinsights/widgets/appbars/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _currentIndex = 0;

  final _screens = [
    const DashboardScreen(key: Key("dashboard_screen")),
    const ClassesScreen(key: Key("classes_screen")),
    const ProfileScreen(key: Key("profile_screen")),
  ];

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    var pageController = PageController(initialPage: 0);

    onLogout() => showDialog<bool>(
          context: context,
          builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Willst du dich wirklich abmelden?",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10.0),
                  const Text("Du kannst dich jederzeit wieder anmelden."),
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary),
                            foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onBackground),
                            textStyle: MaterialStatePropertyAll(Theme.of(context).textTheme.bodyLarge),
                          ),
                          child: const Text("Zurück"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.error),
                            textStyle: MaterialStatePropertyAll(Theme.of(context).textTheme.bodyLarge),
                          ),
                          child: const Text("Abmelden"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).then(
          (shouldLogout) {
            if (shouldLogout != true) return;
            ref.read(authProvider.notifier).logout();
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                  pageBuilder: (context, firstAnimation, secondAnimation) => const LoginScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero),
            );
          },
        );

    onChangedScreen(int index) => setState(() => _currentIndex = index);
    onTabNavigation(int index, {bool setScreen = true}) async {
      debugPrint("Navigating to $index");
      await pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      setState(() => _currentIndex = index);
      if (setScreen) ref.read(screenProvider.notifier).setScreen(Screen.values[index]);
    }

    ref.listen(screenProvider, (_, newScreen) {
      onTabNavigation(Screen.values.indexOf(newScreen), setScreen: false);
    });

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: "HAK/HAS/HLW Landeck",
            action: _currentIndex == 2
                ? IconButton(
                    icon: const Icon(Icons.logout),
                    color: Theme.of(context).colorScheme.error,
                    onPressed: onLogout,
                  )
                : null,
          ),
          Expanded(
            child: PageView(
              physics: const BouncingScrollPhysics(),
              onPageChanged: onChangedScreen,
              controller: pageController,
              children: _screens
                  .map(
                    (screen) => SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 30.0),
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: screen,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        iconSize: 30.0,
        onTap: onTabNavigation,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            ref.read(themeProvider) == ThemeMode.dark ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary,
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
        ],
      ),
    );
  }
}
