import 'package:classinsights/providers/auth_provider.dart';
import 'package:classinsights/providers/lesson_provider.dart';
import 'package:classinsights/providers/room_provider.dart';
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
    const RoomOverviewScreen(key: Key("classes_screen")),
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
            backgroundColor: Theme.of(context).colorScheme.secondary,
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
                            elevation: const MaterialStatePropertyAll(0.0),
                            backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
                            foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onBackground),
                            textStyle: MaterialStatePropertyAll(Theme.of(context).textTheme.bodyLarge),
                          ),
                          child: const Text("Zurück"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ButtonStyle(
                            elevation: const MaterialStatePropertyAll(0.0),
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

    onChangedScreen(int index) {
      setState(() => _currentIndex = index);
      scrollController.jumpTo(0.0);
    }

    onTabNavigation(int index) async {
      await pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      setState(() => _currentIndex = index);
    }

    ref.listen(screenProvider, (_, newScreen) => onTabNavigation(Screen.values.indexOf(newScreen)));

    const defaultPadding = 30.0;
    const appBarHeight = 50.0;

    refreshDashboard() async {
      await ref.read(lessonProvider.notifier).refreshLessons();
      await ref.read(roomProvider.notifier).refreshRooms();
    }

    refreshRooms() async => await ref.read(roomProvider.notifier).refreshRooms();

    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) return true;
        await pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
        setState(() => _currentIndex = 0);
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) => PageView(
                physics: const BouncingScrollPhysics(),
                onPageChanged: onChangedScreen,
                controller: pageController,
                children: _screens.map(
                  (screen) {
                    var content = SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - (MediaQuery.of(context).padding.top + appBarHeight) + .1,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top, bottom: defaultPadding, left: defaultPadding, right: defaultPadding),
                          child: screen,
                        ),
                      ),
                    );

                    return Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + appBarHeight),
                      child: _currentIndex == Screen.dashboard.index || _currentIndex == Screen.rooms.index
                          ? RefreshIndicator(
                              onRefresh: _currentIndex == Screen.dashboard.index ? refreshDashboard : refreshRooms,
                              color: Theme.of(context).colorScheme.background,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: content,
                            )
                          : content,
                    );
                  },
                ).toList(),
              ),
            ),
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
      ),
    );
  }
}
