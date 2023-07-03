import 'package:classinsights/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MainApp());

const _lightColorScheme = ColorScheme.dark(
  primary: Color.fromRGBO(44, 99, 241, 1),
  primaryContainer: Color.fromRGBO(44, 99, 241, 1),
  secondary: Color.fromRGBO(100, 121, 175, 1),
  secondaryContainer: Color.fromRGBO(197, 210, 244, 1),
  background: Color.fromRGBO(245, 245, 245, 1),
  surface: Color.fromRGBO(245, 245, 245, 1),
  onBackground: Color.fromRGBO(10, 10, 10, 1),
  error: Color.fromRGBO(195, 0, 0, 1),
  onSurface: Color.fromRGBO(235, 235, 235, 1),
);

const _darkColorScheme = ColorScheme.light(
  primary: Color.fromRGBO(72, 123, 255, 1),
  primaryContainer: Color.fromRGBO(72, 123, 255, 1),
  secondary: Color.fromRGBO(65, 111, 229, 1),
  secondaryContainer: Color.fromRGBO(5, 11, 26, 1),
  background: Color.fromRGBO(2, 5, 13, 1),
  onBackground: Color.fromRGBO(245, 245, 245, 1),
  error: Color.fromRGBO(185, 35, 36, 1),
  onSurface: Color.fromRGBO(10, 31, 89, 1),
);

TextTheme _textTheme = const TextTheme().copyWith(
  titleLarge: const TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: const TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
  ),
  titleSmall: const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  ),
  bodyLarge: const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  ),
  bodyMedium: const TextStyle(
    fontSize: 14.0,
  ),
  labelLarge: const TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.bold,
  ),
  labelMedium: const TextStyle(
    fontSize: 10.0,
  ),
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        brightness: Brightness.light,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        scaffoldBackgroundColor: _lightColorScheme.background,
        colorScheme: _lightColorScheme,
        textTheme: _textTheme.apply(
          bodyColor: _lightColorScheme.onBackground,
          displayColor: _lightColorScheme.onBackground,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        scaffoldBackgroundColor: _darkColorScheme.background,
        colorScheme: _darkColorScheme,
        textTheme: _textTheme.apply(
          bodyColor: _darkColorScheme.onBackground,
          displayColor: _darkColorScheme.onBackground,
        ),
      ),
      home: const TabsScreen(),
    );
  }
}
