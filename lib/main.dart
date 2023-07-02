import 'package:classinsights/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MainApp());

const _lightColorScheme = ColorScheme.dark(
  primary: Color.fromRGBO(44, 99, 241, 1),
  secondary: Color.fromRGBO(100, 121, 175, 1),
  primaryContainer: Color.fromRGBO(44, 99, 241, 1),
  secondaryContainer: Color.fromRGBO(197, 210, 244, 1),
  background: Color.fromRGBO(245, 245, 245, 1),
  surface: Color.fromRGBO(245, 245, 245, 1),
  scrim: Color.fromRGBO(245, 245, 245, 1),
  onBackground: Color.fromRGBO(10, 10, 10, 1),
  error: Color.fromRGBO(195, 0, 0, 1),
  onSurface: Color.fromRGBO(138, 138, 138, 1),
);

const _darkColorScheme = ColorScheme.light(
  primary: Color.fromRGBO(72, 123, 255, 1),
  secondary: Color.fromRGBO(65, 111, 229, 1),
  primaryContainer: Color.fromRGBO(72, 123, 255, 1),
  secondaryContainer: Color.fromRGBO(5, 11, 26, 1),
  background: Color.fromRGBO(2, 5, 13, 1),
  onBackground: Color.fromRGBO(245, 245, 245, 1),
  error: Color.fromRGBO(185, 35, 36, 1),
  onSurface: Color.fromRGBO(10, 31, 89, 1),
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light().copyWith(
          brightness: Brightness.light,
          scaffoldBackgroundColor: _lightColorScheme.background,
          appBarTheme: AppBarTheme(
            backgroundColor: _lightColorScheme.background,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: _lightColorScheme.background,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarDividerColor: _lightColorScheme.onSurface,
            ),
            foregroundColor: _lightColorScheme.onBackground,
            elevation: 0,
          ),
          colorScheme: _lightColorScheme,
        ),
        darkTheme: ThemeData.dark().copyWith(
          brightness: Brightness.dark,
          colorScheme: _darkColorScheme,
        ),
        home: const TabsScreen());
  }
}
