import 'package:classinsights/providers/screen_provider.dart';
import 'package:classinsights/providers/theme_provider.dart';
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

    onChangedScreen(int index) {
      setState(() => _currentIndex = index);
      ref.read(screenProvider.notifier).setScreen(Screen.values[index]);
    }

    onTabNavigation(int index) => setState(
          () {
            _currentIndex = index;
            pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          },
        );

    ref.listen(screenProvider, (_, newScreen) {
      scrollController.jumpTo(0.0);
      pageController.animateToPage(
        Screen.values.indexOf(newScreen),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );
    });

    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            height: 50,
            title: "HAK/HAS/HLW Landeck",
            index: _currentIndex,
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

    // return Scaffold(
    //   body: Column(
    //     children: [
    //       CustomAppBar(
    //         height: 50,
    //         title: "HAK/HAS/HLW Landeck",
    //         index: _currentIndex,
    //       ),
    //       Expanded(
    //         child: SingleChildScrollView(
    //           controller: scrollController,
    //           physics: const BouncingScrollPhysics(),
    //           child: Container(
    //             width: double.infinity,
    //             margin: const EdgeInsets.only(top: 30.0),
    //             padding: const EdgeInsets.symmetric(horizontal: 30.0),
    //             child: Expanded(
    //               child: TabBarView(
    //                 controller: ,
    //                 physics: const BouncingScrollPhysics(),
    //                 children: const [
    //                   Center(child: Text("Dashboard")),
    //                   Center(child: Text("Rooms")),
    //                   Center(child: Text("Profile")),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   bottomNavigationBar: BottomNavigationBar(
    //     backgroundColor: Theme.of(context).colorScheme.background,
    //     elevation: 0,
    //     iconSize: 30.0,
    //     onTap: onTabTapped,
    //     currentIndex: _currentIndex,
    //     showSelectedLabels: false,
    //     showUnselectedLabels: false,
    //     selectedItemColor: Theme.of(context).colorScheme.primary,
    //     unselectedItemColor:
    //         ref.read(themeProvider) == ThemeMode.dark ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.secondary,
    //     items: const [
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home_rounded),
    //         label: "Home",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.class_outlined),
    //         label: "Classes",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.person_outline_outlined),
    //         label: "Profile",
    //       ),
    //     ],
    //   ),
    // );
  }
}
